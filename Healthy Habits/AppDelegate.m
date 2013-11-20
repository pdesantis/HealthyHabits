//
//  AppDelegate.m
//  Healthy Habits
//
//  Created by Patrick DeSantis on 8/7/13.
//  Copyright (c) 2013 Patrick DeSantis. All rights reserved.
//

#import "AppDelegate.h"
#import "AboutWindowController.h"
#import "Preferences.h"
#import "Screen.h"

@interface AppDelegate () <NSWindowDelegate>

@property (weak) IBOutlet NSMenu *menu;
@property (weak) IBOutlet NSMenuItem *activateButton;

@property   (strong, nonatomic) NSStatusItem        *statusItem;

@property   (strong, nonatomic) id                  inputEventHandler;
@property   (strong, nonatomic) NSTimer             *timer;
@property   (strong, nonatomic) NSTimer             *walkTimer;
@property   (strong, nonatomic) NSSpeechSynthesizer *speechSynthesizer;

@property   (strong, nonatomic) Preferences         *preferences;
@property   (nonatomic) NSTimeInterval              lastWalkTime;
@property   (nonatomic) NSTimeInterval              lastInteractionTime;
@property   (nonatomic) BOOL                        isWalking;
@property   (nonatomic) float                       previousBrightness;

@property   (strong, nonatomic) AboutWindowController   *aboutWindowController;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"shouldActivateOnLaunch": [NSNumber numberWithBool:kDefaultShouldActivateOnLaunch],
                                                              @"shouldSpeak": [NSNumber numberWithBool:kDefaultShouldSpeak],
                                                              @"shouldStartOnLogin": [NSNumber numberWithInteger:kDefaultShouldStartOnLogin],
                                                              @"timeDurationBetweenWalks": [NSNumber numberWithInteger:kDefaultTimeDurationBetweenWalks],
                                                              @"timeDurationOfWalk": [NSNumber numberWithInteger:kDefaultTimeDurationOfWalk] }];
    self.preferences = [Preferences sharedPreferences];
}

- (void)awakeFromNib
{
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    self.statusItem.menu = self.menu;
    self.statusItem.title = NSLocalizedString(@"title", nil);
    self.statusItem.toolTip = NSLocalizedString(@"tooltip", nil);
    self.statusItem.highlightMode = YES;
    
    self.speechSynthesizer = [[NSSpeechSynthesizer alloc] init];
}



#pragma mark - IBAction
- (IBAction)aboutButtonPressed:(id)sender
{
    self.aboutWindowController = [[AboutWindowController alloc] init];
    [self.aboutWindowController showWindow:nil];
    self.aboutWindowController.window.delegate = self;
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
    self.aboutWindowController = nil;
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
    
    // Create periodic update timer
    [self setupTimer];
}

- (void)deactivate
{
    // Remove input event handler
    [NSEvent removeMonitor:self.inputEventHandler];
    self.inputEventHandler = nil;
    
    // Update labels
    self.activateButton.title = NSLocalizedString(@"Activate", nil);
    
    // Stop timer
    [self.timer invalidate];
}

- (void)setupTimer
{
    self.lastInteractionTime = [NSDate timeIntervalSinceReferenceDate];
    self.lastWalkTime = [NSDate timeIntervalSinceReferenceDate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kTimerInterval
                                                  target:self
                                                selector:@selector(update:)
                                                userInfo:nil
                                                 repeats:YES];
}



#pragma mark - Timer methods
- (void)update:(NSTimer *)timer
{
    NSLog(@"%i - isWalking", self.isWalking);
    NSLog(@"%i - last interaction time, %f", [NSDate timeIntervalSinceReferenceDate] - self.lastInteractionTime >= self.preferences.timeDurationBetweenWalks, self.lastInteractionTime);
    NSLog(@"%i - last walk time, %f", [NSDate timeIntervalSinceReferenceDate] - self.lastWalkTime >= self.preferences.timeDurationBetweenWalks, self.lastWalkTime);

    // If the time since the user last touched the computer is more than the time between walks, interperet it as a walk
    if (!self.isWalking
        && [NSDate timeIntervalSinceReferenceDate] - self.lastInteractionTime >= self.preferences.timeDurationBetweenWalks) {
        self.lastWalkTime = [NSDate timeIntervalSinceReferenceDate];
    }

    // If the time since the user last went for a walk is more than the time between walks, tell the user to go for a walk
    if (!self.isWalking
        && [NSDate timeIntervalSinceReferenceDate] - self.lastWalkTime >= self.preferences.timeDurationBetweenWalks) {
        [self beginWalk];
    }
}

- (void)endWalk:(NSTimer *)timer
{
    // UI updates
    [self.speechSynthesizer startSpeakingString:NSLocalizedString(@"Welcome back", nil)];
    [Screen adjustBrightness:self.previousBrightness];

    self.isWalking = NO;
    self.lastWalkTime = [NSDate timeIntervalSinceReferenceDate];
}


- (void)beginWalk
{
    // UI updates
    [self.speechSynthesizer startSpeakingString:NSLocalizedString(@"You should go for a walk", nil)];
    self.previousBrightness = [Screen getBrightness];
    [Screen adjustBrightness:0.0f];

    self.isWalking = YES;
    self.walkTimer = [NSTimer scheduledTimerWithTimeInterval:self.preferences.timeDurationOfWalk
                                     target:self
                                   selector:@selector(endWalk:)
                                   userInfo:nil
                                    repeats:NO];
}

@end
