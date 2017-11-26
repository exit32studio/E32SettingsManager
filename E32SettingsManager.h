//
// E32SettingsManager.h
//
// Created by Joseph Bobula on 11/24/17
//  Copyright © 2017 Exit32. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface E32SettingsManager : NSObject <UITableViewDataSource>

@property (readonly, strong, nonatomic) NSDictionary *settings;
+(id)initWithName:(NSString *)name;
-(bool)changeSettingNamed:(NSString *)name toValue:(NSObject *)value;
-(bool)saveSettings;

@end

