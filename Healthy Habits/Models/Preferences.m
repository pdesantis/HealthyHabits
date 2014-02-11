//
//  Preferences.m
//  Healthy Habits
//
//  Created by Patrick DeSantis on 8/29/13.
//  Copyright (c) 2013 Patrick DeSantis. All rights reserved.
//

#import "Preferences.h"
#import <ServiceManagement/ServiceManagement.h>

// Preferences keys
NSString * const kStartAtLoginKey = @"startAtLogin";
NSString * const kActivateAtStartKey = @"activateAtStart";
NSString * const kShowPreferencesAtStartKey = @"showPreferencesAtStart";
NSString * const kBreakDurationKey = @"breakDuration";
NSString * const kDurationBetweenBreaksKey = @"durationBetweenBreaks";

// Default Preference values
BOOL const kDefaultStartAtLogin = NO;
BOOL const kDefaultActivateAtStart = YES;
BOOL const kDefaultShowPreferencesAtStart = YES;
NSInteger const kDefaultTimeDurationBetweenBreaks = 60 * 20;
NSInteger const kDefaultTimeDurationOfBreak = 60 * 5;

static NSString const *kLaunchHelperBundleID = @"com.pattappat.Healthy-Habits-Launcher";

@implementation Preferences

+ (instancetype)sharedPreferences
{
    static Preferences *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Preferences alloc] init];
        [sharedInstance load];
    });
    return sharedInstance;
}

- (void)load
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    self.startAtLogin = [defaults boolForKey:kStartAtLoginKey];
    self.activateAtStart = [defaults boolForKey:kActivateAtStartKey];
    self.showPreferencesAtStart = [defaults boolForKey:kShowPreferencesAtStartKey];
    self.breakDuration = [defaults integerForKey:kBreakDurationKey];
    self.durationBetweenBreaks = [defaults integerForKey:kDurationBetweenBreaksKey];
}

- (void)save
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    [defaults setBool:self.startAtLogin forKey:kStartAtLoginKey];
    [defaults setBool:self.activateAtStart forKey:kActivateAtStartKey];
    [defaults setBool:self.showPreferencesAtStart forKey:kShowPreferencesAtStartKey];
    [defaults setInteger:self.breakDuration forKey:kBreakDurationKey];
    [defaults setInteger:self.durationBetweenBreaks forKey:kDurationBetweenBreaksKey];

    if (self.startAtLogin) {
        [self enableLoginItem];
    } else {
        [self disableLoginItem];
    }

    [defaults synchronize];
}

- (void)enableLoginItem
{
    SMLoginItemSetEnabled((__bridge CFStringRef)kLaunchHelperBundleID, true);
}

- (void)disableLoginItem
{
    SMLoginItemSetEnabled((__bridge CFStringRef)kLaunchHelperBundleID, false);
}

@end
