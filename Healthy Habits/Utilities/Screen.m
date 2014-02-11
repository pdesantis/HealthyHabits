//
//  Screen.m
//  Healthy Habits
//
//  Created by Patrick DeSantis on 8/7/13.
//  Copyright (c) 2013 Patrick DeSantis. All rights reserved.
//

#import "Screen.h"
#import <IOKit/graphics/IOGraphicsLib.h>

CFStringRef const kDisplayBrightness = CFSTR(kIODisplayBrightnessKey);

@implementation Screen

+ (CGDisplayErr)adjustBrightness:(float)brightness
{
    // Get the main display
    CGDirectDisplayID mainDisplay = CGMainDisplayID();
    
    // Get the service port of the display
    io_service_t service = CGDisplayIOServicePort(mainDisplay);
    
    
    return IODisplaySetFloatParameter(service,
                                     kNilOptions,
                                     kDisplayBrightness,
                                     brightness);
}

+ (float)getBrightness
{
    CGDisplayErr err;
    float brightness;
    
    // Get the main display
    CGDirectDisplayID mainDisplay = CGMainDisplayID();
    
    // Get the service port of the display
    io_service_t service = CGDisplayIOServicePort(mainDisplay);
    
    // Get the brightness
    err = IODisplayGetFloatParameter(service, kNilOptions, kDisplayBrightness, &brightness);
    
    // If there was an error, log it
    if (err != kIOReturnSuccess) {
        NSLog(@"failed to geth the brightness of display 0x%x (error %d)", (unsigned int)mainDisplay, err);
        return -1;
    } else {
        return brightness;
    }
}

@end
