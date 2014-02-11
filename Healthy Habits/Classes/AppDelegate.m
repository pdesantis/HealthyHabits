//
//  AppDelegate.m
//  Healthy Habits
//
//  Created by Patrick DeSantis on 8/7/13.
//  Copyright (c) 2013 Patrick DeSantis. All rights reserved.
//

#import "AppDelegate.h"
#import "AboutWindowController.h"
#import "BreakWindowController.h"
#import "CustomStatusView.h"
#import "Preferences.h"
#import "PreferencesWindowController.h"
#import "Screen.h"

@interface AppDelegate () <BreakWindowControllerDelegate, NSMenuDelegate, NSWindowDelegate>

@property (weak, nonatomic) IBOutlet NSMenu *menu;
@property (weak, nonatomic) IBOutlet NSMenuItem *activateButton;

@property (strong, nonatomic) NSStatusItem *statusItem;
@property (weak, nonatomic) CustomStatusView *statusView;

@property (strong, nonatomic) id inputEventHandler;
@property (strong, nonatomic) NSTimer *timer;

@property (assign, nonatomic) BOOL isOnBreak;

@property (assign, nonatomic) NSTimeInterval lastBreakTime;
@property (assign, nonatomic) NSTimeInterval lastInteractionTime;
@property (assign, nonatomic) float previousBrightness;

@property (strong, nonatomic) AboutWindowController *aboutWindowController;
@property (strong, nonatomic) BreakWindowController *breakWindowController;
@property (strong, nonatomic) PreferencesWindowController *preferencesWindowController;

@end


static NSTimeInterval const kTimerInterval = 1;


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

    CustomStatusView *statusView = [[CustomStatusView alloc] init];
    statusView.target = self;
    statusView.action = @selector(leftClick:);
    statusView.rightAction = @selector(rightClick:);
    statusView.activeImage = [NSImage imageNamed:@"tree"];
    statusView.activeImageHighlighted = [NSImage imageNamed:@"tree-white"];
    statusView.unactiveImage = [NSImage imageNamed:@"tree-empty"];
    statusView.unactiveImageHighlighted = [NSImage imageNamed:@"tree-empty-white"];
    self.statusItem.view = statusView;
    self.statusView = statusView;

    self.menu.delegate = self;
}

- (IBAction)leftClick:(id)sender
{
    [self activateButtonPressed:nil];
}

- (IBAction)rightClick:(id)sender
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
    } else if (self.breakWindowController.window == window) {
        self.breakWindowController = nil;
    } else if (self.preferencesWindowController.window == window) {
        self.preferencesWindowController = nil;
    }
}



#pragma mark - NSMenuDelegate
- (void)menuDidClose:(NSMenu *)menu
{
    self.statusView.highlighted = NO;
}



#pragma mark - Start / Stop methods
- (void)activate
{
    // Create event handler for all input events
    self.inputEventHandler = [NSEvent addGlobalMonitorForEventsMatchingMask:NSMouseMovedMask handler:^(NSEvent *event){
        self.lastInteractionTime = [NSDate timeIntervalSinceReferenceDate];
    }];
    
    // Update labels
    self.activateButton.title = NSLocalizedString(@"Deactivate", @"Deactivate menu item");
    self.statusView.active = YES;
    
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
    self.activateButton.title = NSLocalizedString(@"Activate", @"Activate menu item");
    self.statusView.active = NO;
    
    // Stop timer
    [self.timer invalidate];
}



#pragma mark - Timer methods
- (void)update:(NSTimer *)timer
{
    // If we're on break, or prompting the user to go on break, do nothing
    if (self.isOnBreak || self.breakWindowController) {
        return;
    }

    Preferences *preferences = [Preferences sharedPreferences];

    // If the time since the user last touched the computer is more than the time between breaks, interperet it as the user is currently taking a break
    if ([NSDate timeIntervalSinceReferenceDate] - self.lastInteractionTime >= preferences.durationBetweenBreaks) {
        self.lastBreakTime = [NSDate timeIntervalSinceReferenceDate];
    }

    // If the time since the user last took a break is more than the time between breaks, tell the user to take a break
    if ([NSDate timeIntervalSinceReferenceDate] - self.lastBreakTime >= preferences.durationBetweenBreaks) {
        [self promptForBreak];
    }
}



#pragma mark - Break methods
- (void)promptForBreak
{
    BreakWindowController *breakWindowController = [[BreakWindowController alloc] init];
    breakWindowController.delegate = self;
    [breakWindowController showWindow:nil];
    breakWindowController.window.delegate = self;
    self.breakWindowController = breakWindowController;
    [NSApp activateIgnoringOtherApps:YES];
    [breakWindowController.window makeKeyAndOrderFront:nil];
}

- (void)beginBreak
{
    self.isOnBreak = YES;

    // UI updates
    self.previousBrightness = [Screen getBrightness];
    [Screen adjustBrightness:0.0f];

    NSTimeInterval breakDuration = [Preferences sharedPreferences].breakDuration;
    [self performSelector:@selector(endBreak:)
               withObject:nil
               afterDelay:breakDuration];
}

- (void)endBreak:(NSTimer *)timer
{
    self.isOnBreak = NO;
    self.lastBreakTime = [NSDate timeIntervalSinceReferenceDate];

    // UI updates
    if ([Screen getBrightness] == 0.0f) {
        [Screen adjustBrightness:self.previousBrightness];
    }
}



#pragma mark - BreakWindowControllerDelegate
- (void)breakWindowControllerDidCancel:(BreakWindowController *)windowController
{
    // Skip this break
    self.lastBreakTime = [NSDate timeIntervalSinceReferenceDate];
    [windowController close];
}

- (void)breakWindowControllerDidAccept:(BreakWindowController *)windowController
{
    // Start the break!
    [self beginBreak];
    [windowController close];
}

@end
