//
//  SOPDatabase.m
//  Sound Out Phonics
//
//  Purpose: Object that allows access to the sqlite3 database
//
//  History: History of the file can be found here: https://github.com/TeamRedundantTeam/SoundOutPhonics/commits/master/Sound%20Out%20Phonics/Shared/SOPDatabase.m
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

#import "SOPDatabase.h"

@implementation SOPDatabase

static SOPDatabase *_database;

// Create database if it doesn't exist
+ (SOPDatabase*) database {
    if (_database == nil) {
        _database = [[SOPDatabase alloc] init];
    }
    return _database;
}

- (id)init {
    if ((self = [super init])) {
        NSString *sqliteDatabase = [[NSBundle mainBundle] pathForResource:@"sop"
                                                             ofType:@"sqlite3"];
        
        if (sqlite3_open([sqliteDatabase UTF8String], &_database) != SQLITE_OK) {
            NSLog(@"Failed to open database!");
        }
    }
    return self;
}

// releasing all retained objects
- (void)dealloc {
    sqlite3_close(_database);
    [super dealloc];
}

//Pull account information
- (NSArray*) accountsInfo {
    NSMutableArray *retrievedValue = [[[NSMutableArray alloc] init] autorelease];
    NSString *query = @"SELECT accountId, name, password, type, profile_image FROM Accounts ORDER BY accountId ASC";
    
    sqlite3_stmt *statement;
    
    // check if the query executed
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        
        // Continue while there is a result
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int accountId = sqlite3_column_int(statement, 0);
            char *nameChar = (char *) sqlite3_column_text(statement, 1);
            char *passwordChar = (char *) sqlite3_column_text(statement, 2);
            int type = sqlite3_column_int(statement, 3);
            char *imageChar = (char *) sqlite3_column_text(statement, 4);
            
            NSString *name = [[NSString alloc] initWithUTF8String:nameChar];
            NSString *password = [[NSString alloc] initWithUTF8String:passwordChar];
            NSString *image = [[NSString alloc] initWithUTF8String:imageChar];
            
            Account *account = [[Account alloc] initWithId:accountId name:name password:password type:type image:image];
            [retrievedValue addObject:account];
            [name release];
            [password release];
            [image release];
        }
        sqlite3_finalize(statement);
    }
    return retrievedValue;
}
@end
