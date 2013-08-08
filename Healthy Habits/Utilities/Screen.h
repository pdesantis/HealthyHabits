//
//  Screen.h
//  Healthy Habits
//
//  Created by Patrick DeSantis on 8/7/13.
//  Copyright (c) 2013 Patrick DeSantis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Screen : NSObject

+ (CGDisplayErr)adjustBrightness:(float)brightness;
+ (float)getBrightness;

@end
