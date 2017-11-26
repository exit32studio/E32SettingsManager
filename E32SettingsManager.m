//
//  E32SettingsManager.m
//  E32SettingsManager
//
//  Created by Joseph Bobula on 11/23/17.
//  Copyright © 2017 Exit32. All rights reserved.
//

#import "E32SettingsManager.h"

#define DEFAULT_PLIST_NAME @"DEFAULT_SETTINGS"
#define SETTING_FILE_TYPE @".plist"
#define SETTINGS_TABLEVIEW_CELL_IDENTIFIER @"SettingsTableviewCellIdentifier"

@interface E32SettingsManager ()

//Make settings read / write in the implementation file
@property (readwrite, strong, nonatomic) NSDictionary *settings;
//path to plist
@property (strong, nonatomic) NSString *path;
//filename for plist
@property (strong, nonatomic) NSString *filename;

@end

@implementation E32SettingsManager

#pragma mark - Properties
- (NSDictionary*)settings {
    if (!_settings) {
        _settings = [NSDictionary dictionary];
    }
    return _settings;
}

- (NSString*)filename {
    if (!_filename) {
        _filename = [NSString stringWithFormat:DEFAULT_PLIST_NAME];
    }
    return _filename;
}

- (NSString*)path {
    if (!_path) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //If the path to the documents directory succeeded, grab it as the base path.  If it fails, return nil
        NSString *basePath = (paths.count > 0) ? [paths objectAtIndex:0] : nil;
        _path = [[basePath stringByAppendingString:self.filename] stringByAppendingString:SETTING_FILE_TYPE];
    }
    return _path;
}

#pragma mark - Lifecycle

-(id)initWithName:(NSString*)name {
    if (self = [super init]) {
        self.filename = name;
        //Check if a file already exists at the designated path
        if ([[NSFileManager defaultManager] fileExistsAtPath:self.path]) {
            self.settings = [NSDictionary dictionaryWithContentsOfFile:self.path];
        } else {
            //File doesn't exist.  Build and empty dictionary and try to write it to file
            self.settings = [NSDictionary dictionary];
            if (![self.settings writeToFile:self.path atomically:YES]) {
                return nil;
            }
        }
    }
    return self;
}

+(id)initWithName:(NSString *)name {
    E32SettingsManager *manager = [[E32SettingsManager alloc] initWithName:name];
    return manager;
}

//Override generic initializer to use plist name "default"
+(id)init {
    return [[self class] initWithName:DEFAULT_PLIST_NAME];
}

-(id)init {
    return [[self class] init];
}

-(void)dealloc {
    //Before leaving memory, write self to disc
    [self.settings writeToFile:self.path atomically:YES];
}

#pragma mark - Adjusting Settings

-(bool)changeSettingNamed:(NSString *)name toValue:(NSObject *)value {
    //Only allow strings, dates, and numbers into settings
    if ( ([value isKindOfClass:[NSString class]]) ||
         ([value isKindOfClass:[NSDate class]]) ||
         ([value isKindOfClass:[NSNumber class]])
        ) {
        //Make a mutable copy of the settings dictionary to play with
        NSMutableDictionary *mySettings = [self.settings mutableCopy];
        //If the value already exists, delete it.
        if ([mySettings objectForKey:name]) [mySettings removeObjectForKey:name];
        //Write the setting to the dictionary
        [mySettings setObject:value forKey:name];
        //Pass local settings into the class instance variable
        self.settings = [NSDictionary dictionaryWithDictionary:mySettings];
        //check for successful change of setting and return yes or no
        return ([[self.settings objectForKey:name] isEqual:value]) ? YES: NO;
    } else {
        return false;
    }
}

-(bool)saveSettings {
    return [self.settings writeToFile:self.path atomically:YES];
}

#pragma mark - UITableViewDataSource

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //Make an array of keys to use for determining what entry to use for each cell
    NSArray *keys = [self.settings allKeys];
    NSString *indexedKey = [keys objectAtIndex:indexPath.row];
    
    //grab a cell to populate
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SETTINGS_TABLEVIEW_CELL_IDENTIFIER];
    //Fill the cell with the keys and values from the settings object
    cell.textLabel.text = indexedKey;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [self.settings objectForKey:indexedKey]];
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 1;};

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.settings count];
}

@end

