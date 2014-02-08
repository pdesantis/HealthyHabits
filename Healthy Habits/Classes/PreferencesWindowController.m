//
//  PreferencesWindowController.m
//  Healthy Habits
//
//  Created by Patrick DeSantis on 2/6/14.
//  Copyright (c) 2014 Patrick DeSantis. All rights reserved.
//

#import "PreferencesWindowController.h"
#import "Preferences.h"

@interface PreferencesWindowController ()
@property (weak) IBOutlet NSImageView *iconImageView;

@property (weak) IBOutlet NSButton *startAtLoginCheckbox;
@property (weak) IBOutlet NSButton *activateAtStartCheckbox;
@property (weak) IBOutlet NSButton *showPreferencesAtStartCheckbox;

@property (weak) IBOutlet NSTextField *durationBetweenBreakLabel;
@property (weak) IBOutlet NSSlider *durationBetweenBreakSlider;

@property (weak) IBOutlet NSTextField *breakDurationLabel;
@property (weak) IBOutlet NSSlider *breakDurationSlider;
@end

@implementation PreferencesWindowController

- (id)init
{
    return [self initWithWindowNibName:@"PreferencesWindowController"];
}

- (void)awakeFromNib
{
    self.iconImageView.image = [NSApp applicationIconImage];

    Preferences *prefs = [Preferences sharedPreferences];
    self.startAtLoginCheckbox.state = prefs.startAtLogin ? NSOnState : NSOffState;
    self.activateAtStartCheckbox.state = prefs.activateAtStart ? NSOnState : NSOffState;
    self.showPreferencesAtStartCheckbox.state = prefs.showPreferencesAtStart ? NSOnState : NSOffState;
    [self.durationBetweenBreakSlider setIntegerValue:(prefs.durationBetweenBreaks / 60)];
    [self.breakDurationSlider setIntegerValue:(prefs.breakDuration / 60)];

    [self updateLabelForSlider:self.durationBetweenBreakSlider];
    [self updateLabelForSlider:self.breakDurationSlider];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}



#pragma mark - IBAction
- (IBAction)changeDurationBetweenBreak:(NSSlider *)sender
{
    [Preferences sharedPreferences].durationBetweenBreaks = [sender integerValue] * 60;
    [[Preferences sharedPreferences] save];
    [self updateLabelForSlider:sender];
}

- (IBAction)changeBreakDuration:(NSSlider *)sender
{
    [Preferences sharedPreferences].breakDuration = [sender integerValue] * 60;
    [[Preferences sharedPreferences] save];
    [self updateLabelForSlider:sender];
}

- (IBAction)toggleStartAtLogin:(NSButton *)sender
{
    [Preferences sharedPreferences].startAtLogin = sender.state == NSOnState;
    [[Preferences sharedPreferences] save];
}

- (IBAction)toggleActivateAtStart:(NSButton *)sender
{
    [Preferences sharedPreferences].activateAtStart = sender.state == NSOnState;
    [[Preferences sharedPreferences] save];
}

- (IBAction)toggleShowPreferences:(NSButton *)sender
{
    [Preferences sharedPreferences].showPreferencesAtStart = sender.state == NSOnState;
    [[Preferences sharedPreferences] save];
}



#pragma mark - Private
- (void)updateLabelForSlider:(NSSlider *)slider
{
    NSInteger totalMinutes = [slider integerValue];
    NSInteger hours = floor(totalMinutes / 60);
    NSInteger minutes = totalMinutes % 60;

    NSMutableArray *strings = [NSMutableArray arrayWithCapacity:2];
    if (hours == 1) {
        [strings addObject:@"1 hour"];
    } else if (hours > 1) {
        [strings addObject:[NSString stringWithFormat:@"%ld hours", hours]];
    }

    if (minutes == 1) {
        [strings addObject:@"1 minute"];
    } else if (minutes > 1) {
        [strings addObject:[NSString stringWithFormat:@"%ld minutes", (long)minutes]];
    }

    NSTextField *textField;
    if (self.durationBetweenBreakSlider == slider) {
        textField = self.durationBetweenBreakLabel;
    } else if (self.breakDurationSlider == slider) {
        textField = self.breakDurationLabel;
    }

    textField.stringValue = [strings componentsJoinedByString:@" "];
}

@end
