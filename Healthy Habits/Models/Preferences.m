//
//  Preferences.m
//  Healthy Habits
//
//  Created by Patrick DeSantis on 8/29/13.
//  Copyright (c) 2013 Patrick DeSantis. All rights reserved.
//

#import "Preferences.h"

@implementation Preferences
@dynamic shouldActivateOnLaunch;
@dynamic shouldSpeak;
@dynamic shouldStartOnLogin;
@dynamic timeDurationBetweenWalks;
@dynamic timeDurationOfWalk;

+ (instancetype)sharedPreferences
{
    static Preferences *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Preferences alloc] init];
    });
    return sharedInstance;
}

- (BOOL)shouldActivateOnLaunch
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"shouldActivateOnLaunch"];
}

- (void)setShouldActivateOnLaunch:(BOOL)shouldActivateOnLaunch
{
    [[NSUserDefaults standardUserDefaults] setBool:shouldActivateOnLaunch forKey:@"shouldActivateOnLaunch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)shouldSpeak
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"shouldSpeak"];
}



- (void)setShouldSpeak:(BOOL)shouldSpeak
{
    [[NSUserDefaults standardUserDefaults] setBool:shouldSpeak forKey:@"shouldSpeak"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)shouldStartOnLogin
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"shouldStartOnLogin"];
}



- (void)setShouldStartOnLogin:(BOOL)shouldStartOnLogin
{
    [[NSUserDefaults standardUserDefaults] setBool:shouldStartOnLogin forKey:@"shouldStartOnLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



- (NSInteger)timeDurationBetweenWalks
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"timeDurationBetweenWalks"];
}

- (void)setTimeDurationBetweenWalks:(NSInteger)timeDurationBetweenWalks
{
    [[NSUserDefaults standardUserDefaults] setInteger:timeDurationBetweenWalks forKey:@"timeDurationBetweenWalks"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



- (NSInteger)timeDurationOfWalk
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"timeDurationOfWalk"];
}

- (void)setTimeDurationOfWalk:(NSInteger)timeDurationOfWalk
{
    [[NSUserDefaults standardUserDefaults] setInteger:timeDurationOfWalk forKey:@"timeDurationOfWalk"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
