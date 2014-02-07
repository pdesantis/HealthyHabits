//
//  CustomStatusView.m
//  Healthy Habits
//
//  Created by Patrick DeSantis on 2/7/14.
//  Copyright (c) 2014 Patrick DeSantis. All rights reserved.
//

#import "CustomStatusView.h"

@implementation CustomStatusView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (_highlighted != highlighted) {
        _highlighted = highlighted;
        [self setNeedsDisplay:YES];
    }
}

- (void)setActive:(BOOL)active
{
    if (_active != active) {
        _active = active;
        [self setNeedsDisplay:YES];
    }
}

- (void)mouseUp:(NSEvent *)theEvent
{
    if ([theEvent modifierFlags] & NSControlKeyMask) {
        [self sendRightAction];
    } else if (!self.highlighted) {
        [NSApp sendAction:self.action to:self.target from:self];
    }
}

- (void)rightMouseUp:(NSEvent *)theEvent
{
    [self sendRightAction];
}

- (void)sendRightAction
{
    self.highlighted = !self.highlighted;
    if (self.highlighted) {
        [NSApp sendAction:self.rightAction to:self.target from:self];
    }
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];

    NSImage *image;
	
    // Drawing code here.
    if (self.highlighted) {
        [[NSColor selectedMenuItemColor] set];
        NSRectFill(dirtyRect);
        image = self.active ? self.activeImageHighlighted : self.unactiveImageHighlighted;
    } else {
        image = self.active ? self.activeImage : self.unactiveImage;
    }

    [self drawImage:image centeredInRect:dirtyRect];
}

- (void)drawImage:(NSImage *)image centeredInRect:(NSRect)rect
{
    NSRect imageRect = NSMakeRect(round((rect.size.width - image.size.width) / 2.0f),
                                  round((rect.size.height - image.size.height) / 2.0f),
                                  image.size.width,
                                  image.size.height);
    [image drawInRect:imageRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0f];
}

@end
