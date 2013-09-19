//
//  AppDelegate.h
//  Healthy Habits
//
//  Created by Patrick DeSantis on 8/7/13.
//  Copyright (c) 2013 Patrick DeSantis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet NSMenu *menu;
@property (weak) IBOutlet NSMenuItem *activateButton;

- (IBAction)aboutButtonPressed:(id)sender;
- (IBAction)activateButtonPressed:(id)sender;
- (IBAction)preferencesButtonPressed:(id)sender;
- (IBAction)quitButtonPressed:(id)sender;

@end
