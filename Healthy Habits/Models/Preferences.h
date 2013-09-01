//
//  Preferences.h
//  Healthy Habits
//
//  Created by Patrick DeSantis on 8/29/13.
//  Copyright (c) 2013 Patrick DeSantis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Preferences : NSObject

+ (instancetype)sharedPreferences;

@property   (nonatomic) BOOL    shouldStartOnLogin;
@property   (nonatomic) BOOL    shouldActivateOnLaunch;
@property   (nonatomic) BOOL    shouldSpeak;
@property   (nonatomic) NSInteger   timeDurationOfWalk;
@property   (nonatomic) NSInteger   timeDurationBetweenWalks;

@end
