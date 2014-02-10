//
//  BreakWindowController.h
//  Healthy Habits
//
//  Created by Patrick DeSantis on 2/9/14.
//  Copyright (c) 2014 Patrick DeSantis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol BreakWindowControllerDelegate;



@interface BreakWindowController : NSWindowController

@property (weak, nonatomic) id<BreakWindowControllerDelegate> delegate;

@end



@protocol BreakWindowControllerDelegate <NSObject>
- (void)breakWindowControllerDidAccept:(BreakWindowController *)windowController;
- (void)breakWindowControllerDidCancel:(BreakWindowController *)windowController;
@end
