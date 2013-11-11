//
//  SOPDatabase.h
//  Sound Out Phonics
//
//  Purpose: Object that allows access to the sqlite3 database
//
//  History: History of the file can be found here: https://github.com/TeamRedundantTeam/SoundOutPhonics/commits/master/Sound%20Out%20Phonics/Shared/SOPDatabase.h
//
//  Style: The source code will follow the general apple coding standard described
//         here: https://tinyurl.com/n8jtvj3
//         Furthermore, the source code will be self descriptive and the formating
//         will be consistent through the project. Long methods will be broken down
//         and will have description of what the method does. The variable names and
//         methods will follow the lower camel style (ex: selectedGraphemePosition),
//         the classes will follow the upper camel style (ex: GameLayer) and the
//         files will use the Cocos2d-iphone file name convention (ex: Lvl1-Apple-
//         Sprite.png). Finally, the code will have comments throughout various non
//         trivial operations.
//
//  Created on 2013-11-5.
//  Copyright (c) 2013 Team Redundant Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Account.h"
#import "Statistics.h"

@interface SOPDatabase : NSObject {
    sqlite3 *_database;
}

// accessor to the static database object. This allows us to have one database active throught the application
+ (SOPDatabase *)database;

// pull account information from the SQLite database and generate the appropriate Account classes
- (NSArray *)loadAccounts;

// load account's statistics based on the input and create Statistic objects based on the data pulled from the database
- (NSArray *)loadAccountStatistics:(int)accountId;

// update a specific statistic in the Statistic table based on the input
- (void)updateStatistic:(int)accountId withLevel:(int)level withStatistic:(Statistics *)statistic;

// insert a new statistic into the Statistic table based on the input
- (void)createStatistic:(int)accountId withLevel:(int)level withScore:(int)score witTime:(double)time;
@end
