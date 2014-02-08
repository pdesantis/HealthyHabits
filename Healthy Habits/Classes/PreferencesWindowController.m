//
//  PreferencesWindowController.m
//  Healthy Habits
//
//  Created by Patrick DeSantis on 2/6/14.
//  Copyright (c) 2014 Patrick DeSantis. All rights reserved.
//

#import "PreferencesWindowController.h"

@interface PreferencesWindowController ()
@property (weak) IBOutlet NSImageView *iconImageView;

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

    [self updateLabelForSlider:self.durationBetweenBreakSlider];
    [self updateLabelForSlider:self.breakDurationSlider];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}



#pragma mark - IBAction
- (IBAction)changeDurationBetweenBreak:(id)sender
{
    [self updateLabelForSlider:sender];
}

- (IBAction)changeBreakDuration:(id)sender
{
    [self updateLabelForSlider:sender];
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
