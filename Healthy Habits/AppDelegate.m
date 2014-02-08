//
//  AppDelegate.m
//  Healthy Habits
//
//  Created by Patrick DeSantis on 8/7/13.
//  Copyright (c) 2013 Patrick DeSantis. All rights reserved.
//

#import "AppDelegate.h"
#import "AboutWindowController.h"
#import "CustomStatusView.h"
#import "Preferences.h"
#import "PreferencesWindowController.h"
#import "Screen.h"

@interface AppDelegate () <NSMenuDelegate, NSWindowDelegate>

@property (weak, nonatomic) IBOutlet NSMenu *menu;
@property (weak, nonatomic) IBOutlet NSMenuItem *activateButton;

@property (strong, nonatomic) NSStatusItem *statusItem;

@property (strong, nonatomic) id inputEventHandler;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSTimer *walkTimer;
@property (strong, nonatomic) NSSpeechSynthesizer *speechSynthesizer;

@property (assign, nonatomic) NSTimeInterval lastBreakTime;
@property (assign, nonatomic) NSTimeInterval lastInteractionTime;
@property (assign, nonatomic) BOOL isOnBreak;
@property (assign, nonatomic) float previousBrightness;

@property (strong, nonatomic) AboutWindowController *aboutWindowController;
@property (strong, nonatomic) PreferencesWindowController *preferencesWindowController;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{kActivateAtStartKey: [NSNumber numberWithBool:kDefaultActivateAtStart],
                                                              kStartAtLoginKey: [NSNumber numberWithInteger:kDefaultStartAtLogin],
                                                              kShowPreferencesAtStartKey: [NSNumber numberWithBool:kDefaultShowPreferencesAtStart],
                                                              kDurationBetweenBreaksKey: [NSNumber numberWithInteger:kDefaultTimeDurationBetweenBreaks],
                                                              kBreakDurationKey: [NSNumber numberWithInteger:kDefaultTimeDurationOfBreak] }];

    if ([Preferences sharedPreferences].showPreferencesAtStart) {
        [self preferencesButtonPressed:nil];
    }

    if ([Preferences sharedPreferences].activateAtStart) {
        [self activate];
    }
}

- (void)awakeFromNib
{
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:22.0f];
    self.statusItem.title = NSLocalizedString(@"menu bar title - unactive", nil);

    CustomStatusView *cool = [[CustomStatusView alloc] init];
    cool.target = self;
    cool.action = @selector(single:);
    cool.rightAction = @selector(double:);
    cool.activeImage = [NSImage imageNamed:@"tree"];
    cool.activeImageHighlighted = [NSImage imageNamed:@"tree-white"];
    cool.unactiveImage = [NSImage imageNamed:@"tree-empty"];
    cool.unactiveImageHighlighted = [NSImage imageNamed:@"tree-empty-white"];
    self.statusItem.view = cool;

    self.menu.delegate = self;
}

- (IBAction)single:(id)sender
{
    [self activateButtonPressed:nil];
}

- (IBAction)double:(id)sender
{
    [self.statusItem popUpStatusItemMenu:self.menu];
}


#pragma mark - IBAction
- (IBAction)aboutButtonPressed:(id)sender
{
    self.aboutWindowController = [[AboutWindowController alloc] init];
    [self.aboutWindowController showWindow:nil];
    self.aboutWindowController.window.delegate = self;
    [NSApp activateIgnoringOtherApps:YES];
}

- (IBAction)preferencesButtonPressed:(id)sender
{
    self.preferencesWindowController = [[PreferencesWindowController alloc] init];
    [self.preferencesWindowController showWindow:nil];
    self.preferencesWindowController.window.delegate = self;
    [NSApp activateIgnoringOtherApps:YES];
}

- (IBAction)activateButtonPressed:(id)sender
{
    if (self.timer.isValid) {
        [self deactivate];
    } else {
        [self activate];
    }
}

- (IBAction)quitButtonPressed:(id)sender
{
    [[NSApplication sharedApplication] terminate:sender];
}


#pragma mark - NSWindowDelegate
- (void)windowWillClose:(NSNotification *)notification
{
    id window = [notification object];
    if (self.aboutWindowController.window == window) {
        self.aboutWindowController = nil;
    } else if (self.preferencesWindowController.window == window) {
        self.preferencesWindowController = nil;
    }
}



#pragma mark - NSMenuDelegate
- (void)menuDidClose:(NSMenu *)menu
{
    ((CustomStatusView *)self.statusItem.view).highlighted = NO;
}



#pragma mark - Start / Stop methods
- (void)activate
{
    self.lastInteractionTime = [NSDate timeIntervalSinceReferenceDate];
    
    // Create event handler for all input events
    self.inputEventHandler = [NSEvent addGlobalMonitorForEventsMatchingMask:NSMouseMovedMask handler:^(NSEvent *event){
        self.lastInteractionTime = [NSDate timeIntervalSinceReferenceDate];
    }];
    
    // Update labels
    self.activateButton.title = NSLocalizedString(@"Deactivate", nil);

    self.statusItem.title = NSLocalizedString(@"menu bar title - active", nil);
    ((CustomStatusView *)self.statusItem.view).active = YES;
    
    // Create periodic update timer
    [self.timer invalidate];
    self.lastInteractionTime = [NSDate timeIntervalSinceReferenceDate];
    self.lastBreakTime = [NSDate timeIntervalSinceReferenceDate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kTimerInterval
                                                  target:self
                                                selector:@selector(update:)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)deactivate
{
    // Remove input event handler
    [NSEvent removeMonitor:self.inputEventHandler];
    self.inputEventHandler = nil;
    
    // Update labels
    self.activateButton.title = NSLocalizedString(@"Activate", nil);
    ((CustomStatusView *)self.statusItem.view).active = NO;

    self.statusItem.title = NSLocalizedString(@"menu bar title - unactive", nil);
    
    // Stop timer
    [self.timer invalidate];
}



#pragma mark - Timer methods
- (void)update:(NSTimer *)timer
{
    Preferences *preferences = [Preferences sharedPreferences];
    NSLog(@"%i - isWalking", self.isOnBreak);
    NSLog(@"%i - last interaction time, %f", [NSDate timeIntervalSinceReferenceDate] - self.lastInteractionTime >= preferences.durationBetweenBreaks, self.lastInteractionTime);
    NSLog(@"%i - last walk time, %f", [NSDate timeIntervalSinceReferenceDate] - self.lastBreakTime >= preferences.durationBetweenBreaks, self.lastBreakTime);

    // If the time since the user last touched the computer is more than the time between walks, interperet it as a walk
    if (!self.isOnBreak
        && [NSDate timeIntervalSinceReferenceDate] - self.lastInteractionTime >= preferences.durationBetweenBreaks) {
        self.lastBreakTime = [NSDate timeIntervalSinceReferenceDate];
    }

    // If the time since the user last went for a walk is more than the time between walks, tell the user to go for a walk
    if (!self.isOnBreak
        && [NSDate timeIntervalSinceReferenceDate] - self.lastBreakTime >= preferences.durationBetweenBreaks) {
        [self beginBreak];
    }
}

- (void)endBreak:(NSTimer *)timer
{
    // UI updates
    [self.speechSynthesizer startSpeakingString:NSLocalizedString(@"Welcome back", nil)];
    [Screen adjustBrightness:self.previousBrightness];

    self.isOnBreak = NO;
    self.lastBreakTime = [NSDate timeIntervalSinceReferenceDate];
}


- (void)beginBreak
{
    Preferences *preferences = [Preferences sharedPreferences];
    // UI updates
    [self.speechSynthesizer startSpeakingString:NSLocalizedString(@"You should go for a walk", nil)];
    self.previousBrightness = [Screen getBrightness];
    [Screen adjustBrightness:0.0f];

    self.isOnBreak = YES;
    self.walkTimer = [NSTimer scheduledTimerWithTimeInterval:preferences.breakDuration
                                     target:self
                                   selector:@selector(endBreak:)
                                   userInfo:nil
                                    repeats:NO];
}

@end
