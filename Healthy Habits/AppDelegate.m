//
//  AppDelegate.m
//  Healthy Habits
//
//  Created by Patrick DeSantis on 8/7/13.
//  Copyright (c) 2013 Patrick DeSantis. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@property   (strong, nonatomic) NSStatusItem    *statusItem;
@end

@implementation AppDelegate

- (void)awakeFromNib
{
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    self.statusItem.menu = self.menu;
    self.statusItem.title = @"∆";
    self.statusItem.highlightMode = YES;
}

@end
