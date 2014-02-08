//
//  Preferences.h
//  Healthy Habits
//
//  Created by Patrick DeSantis on 8/29/13.
//  Copyright (c) 2013 Patrick DeSantis. All rights reserved.
//

#import <Foundation/Foundation.h>

// Preferences keys
extern NSString * const kStartAtLoginKey;
extern NSString * const kActivateAtStartKey;
extern NSString * const kShowPreferencesAtStartKey;
extern NSString * const kBreakDurationKey;
extern NSString * const kDurationBetweenBreaksKey;

// Default Preference values
extern const BOOL kDefaultStartAtLogin;
extern const BOOL kDefaultActivateAtStart;
extern const BOOL kDefaultShowPreferencesAtStart;
extern const NSInteger kDefaultTimeDurationBetweenBreaks;
extern const NSInteger kDefaultTimeDurationOfBreak;

@interface Preferences : NSObject

@property   (nonatomic) BOOL    startAtLogin;
@property   (nonatomic) BOOL    activateAtStart;
@property   (nonatomic) BOOL    showPreferencesAtStart;
@property   (nonatomic) BOOL    shouldSpeak;
@property   (nonatomic) NSInteger   breakDuration;
@property   (nonatomic) NSInteger   durationBetweenBreaks;

+ (instancetype)sharedPreferences;
- (void)save;

@end
