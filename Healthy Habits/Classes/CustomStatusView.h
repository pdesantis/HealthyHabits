//
//  CustomStatusView.h
//  Healthy Habits
//
//  Created by Patrick DeSantis on 2/7/14.
//  Copyright (c) 2014 Patrick DeSantis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CustomStatusView : NSView

@property (strong, nonatomic) NSImage *activeImage;
@property (strong, nonatomic) NSImage *activeImageHighlighted;
@property (strong, nonatomic) NSImage *unactiveImage;
@property (strong, nonatomic) NSImage *unactiveImageHighlighted;

@property (assign, nonatomic) id target;
@property (assign, nonatomic) SEL action;
@property (assign, nonatomic) SEL rightAction;

@property (assign, nonatomic) BOOL active;
@property (assign, nonatomic) BOOL highlighted;

@end
