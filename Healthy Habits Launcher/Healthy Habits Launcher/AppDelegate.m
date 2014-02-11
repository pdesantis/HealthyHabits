//
//  AppDelegate.m
//  Healthy Habits Launcher
//
//  Created by Patrick DeSantis on 2/10/14.
//  Copyright (c) 2014 Patrick DeSantis. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Check if the main app is already running
    BOOL isMainAppRunning = NO;
    NSArray *runningApps = [[NSWorkspace sharedWorkspace] runningApplications];
    for (NSRunningApplication *app in runningApps) {
        if ([app.bundleIdentifier isEqualToString:@"com.desantis.Healthy-Habits"]) {
            isMainAppRunning = [app isActive];
            break;
        }
    }
    NSLog(@"hello");

    // If the main app is not running, start it
    if (!isMainAppRunning) {
        NSString *basePath = [[NSBundle mainBundle] bundlePath];
        NSMutableArray *pathComponents = [NSMutableArray arrayWithArray:[basePath pathComponents]];
        [pathComponents removeLastObject];
        [pathComponents removeLastObject];
        [pathComponents removeLastObject];
        [pathComponents addObject:@"MacOS"];
        [pathComponents addObject:@"Healthy Habits"];
        NSString *mainAppPath = [NSString pathWithComponents:pathComponents];
        [[NSWorkspace sharedWorkspace] launchApplication:mainAppPath];
    }

    // We're done
    [[NSApplication sharedApplication] terminate:self];
}

@end
