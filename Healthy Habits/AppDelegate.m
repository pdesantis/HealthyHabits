//
//  AppDelegate.m
//  Healthy Habits
//
//  Created by Patrick DeSantis on 8/7/13.
//  Copyright (c) 2013 Patrick DeSantis. All rights reserved.
//

#import "AppDelegate.h"
#import "Screen.h"

@interface AppDelegate ()
@property   (strong, nonatomic) NSStatusItem        *statusItem;

@property   (strong, nonatomic) NSTimer             *timer;
@property   (strong, nonatomic) NSTimer             *actionTimer;
@property   (strong, nonatomic) NSSpeechSynthesizer *speechSynthesizer;

@property   (nonatomic) NSTimeInterval              lastWalkTime;
@property   (nonatomic) NSTimeInterval              lastInteractionTime;
@property   (nonatomic) BOOL                        isWalking;
@end

@implementation AppDelegate

- (void)awakeFromNib
{
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    self.statusItem.menu = self.menu;
    self.statusItem.title = NSLocalizedString(@"title", nil);
    self.statusItem.toolTip = NSLocalizedString(@"tooltip", nil);
    self.statusItem.highlightMode = YES;
    
    self.speechSynthesizer = [[NSSpeechSynthesizer alloc] init];
    
    self.lastInteractionTime = [NSDate timeIntervalSinceReferenceDate];
    [NSEvent addGlobalMonitorForEventsMatchingMask:NSMouseMovedMask handler:^(NSEvent *event){
        self.lastInteractionTime = [NSDate timeIntervalSinceReferenceDate];
    }];
}

- (IBAction)aboutButtonPressed:(id)sender
{
    
}

- (IBAction)activateButtonPressed:(id)sender
{
    NSLog(@"activateButtonPressed");
    if (self.timer.isValid) {
        self.activateButton.title = NSLocalizedString(@"Activate", nil);
        [self.timer invalidate];
    } else {
        self.activateButton.title = NSLocalizedString(@"Deactivate", nil);
        [self setupTimer];
    }
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

- (void)update:(NSTimer *)timer
{
    NSLog(@"%i - isWalking", self.isWalking);
    NSLog(@"%i - last walk time, %f", self.lastWalkTime < kDurationBetweenSleeps, self.lastWalkTime);
    NSLog(@"%i - last interaction time, %f", self.lastInteractionTime < kDurationBetweenSleeps, self.lastInteractionTime);
    
    if (!self.isWalking
        && [NSDate timeIntervalSinceReferenceDate] - self.lastInteractionTime >= kDurationBetweenSleeps) {
        self.lastWalkTime = [NSDate timeIntervalSinceReferenceDate];
    }
    
    if (!self.isWalking
        && [NSDate timeIntervalSinceReferenceDate] - self.lastWalkTime >= kDurationBetweenSleeps) {
        
        [self beginWalk];
    }
}

- (void)endWalk:(NSTimer *)timer
{
    NSLog(@"endWalk");
    [self.speechSynthesizer startSpeakingString:NSLocalizedString(@"Welcome back", nil)];
    self.lastWalkTime = [NSDate timeIntervalSinceReferenceDate];
    self.isWalking = NO;
    [Screen adjustBrightness:0.75f];
    [self.actionTimer invalidate];
    [self setupTimer];
}


- (void)beginWalk
{
    NSLog(@"beginWalk");
    self.isWalking = YES;
    [self.speechSynthesizer startSpeakingString:NSLocalizedString(@"You should go for a walk", nil)];
    
    [Screen adjustBrightness:0.0f];
    [NSTimer scheduledTimerWithTimeInterval:kDurationOfSleep
                                     target:self
                                   selector:@selector(endWalk:)
                                   userInfo:nil
                                    repeats:NO];
}

@end
