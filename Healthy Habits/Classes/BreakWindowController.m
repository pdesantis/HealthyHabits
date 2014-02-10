//
//  BreakWindowController.m
//  Healthy Habits
//
//  Created by Patrick DeSantis on 2/9/14.
//  Copyright (c) 2014 Patrick DeSantis. All rights reserved.
//

#import "BreakWindowController.h"

@interface BreakWindowController ()

@end

@implementation BreakWindowController

- (id)init
{
    return [self initWithWindowNibName:@"BreakWindowController"];
}

- (IBAction)cancel:(id)sender
{
    [self.delegate breakWindowControllerDidCancel:self];
}

- (IBAction)accept:(id)sender
{
    [self.delegate breakWindowControllerDidAccept:self];
}

@end
