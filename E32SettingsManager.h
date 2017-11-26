//
// E32SettingsManager.h
//
// Created by Joseph Bobula on 11/24/17
//  Copyright © 2017 Exit32. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*
 */

@interface E32SettingsManager : NSObject <UITableViewDataSource>

//The settings themselves are housed in a dictionary.  Note that the dictionary is readonly.  You must use the changeSettingNamed:toValue method to change settings
@property (readonly, strong, nonatomic) NSDictionary *settings;

/*
 *** DESIGNATED INITIALIZER ***
 */
+(id)initWithName:(NSString *)name;

//The following methods will return a boolean value to let consumers know if the method was successful
-(bool)changeSettingNamed:(NSString *)name toValue:(NSObject *)value;
-(bool)saveSettings;

@end

