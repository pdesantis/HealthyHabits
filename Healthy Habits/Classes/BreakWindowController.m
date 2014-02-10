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

- (void)awakeFromNib
{
    self.window.styleMask = NSBorderlessWindowMask;
    [self.window setOpaque:NO];
    self.window.backgroundColor = [NSColor clearColor];

    NSView *view = self.window.contentView;
    view.wantsLayer = YES;
    view.layer.frame = view.frame;
    view.layer.cornerRadius = 3.0f;
    view.layer.masksToBounds = YES;
    view.layer.backgroundColor = [NSColor windowBackgroundColor].CGColor;
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
