//
//  AboutWindowController.m
//  Healthy Habits
//
//  Created by Patrick DeSantis on 8/25/13.
//  Copyright (c) 2013 Patrick DeSantis. All rights reserved.
//

#import "AboutWindowController.h"

@interface AboutWindowController ()

@end

@implementation AboutWindowController

- (id)init
{
    return [self initWithWindowNibName:@"AboutWindowController"];
}

- (void)awakeFromNib
{
    self.versionLabel.stringValue = [NSString stringWithFormat:NSLocalizedString(@"version", @"short version, version"),
                                     [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                                     [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
}

@end
