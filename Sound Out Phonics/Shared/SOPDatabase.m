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

// create database if it doesn't exist
+ (SOPDatabase*) database {
    if (_database == nil) {
        _database = [[SOPDatabase alloc] init];
    }
    return _database;
}

- (id)init {
    if ((self = [super init])) {
        
        // initialize file manager to create a file if necessarry
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        
        // search the Documents folder of the app. Writable folder on the device.
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        // append the database file at the end of the path
        NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:@"sop.sqlite3"];
        
        // add the database to the Documents folder if it doesn't exist there
        if ([fileManager fileExistsAtPath:databasePath] == NO) {
            NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"sop" ofType:@"sqlite3"];
            [fileManager copyItemAtPath:resourcePath toPath:databasePath error:&error];
        }
        
        // try to open the database connection
        if (sqlite3_open([databasePath UTF8String], &_database) != SQLITE_OK) {
            NSLog(@"Failed to open database!");
        }
    }
    return self;
}

// pull account information from the SQLite database and generate the appropriate Account classes
- (NSArray *)loadAccounts {
    NSMutableArray *retrievedValue = [[[NSMutableArray alloc] init] autorelease];
    NSString *query = @"SELECT accountId, name, password, type, profile_image FROM Accounts ORDER BY accountId ASC";
    
    sqlite3_stmt *statement;
    
    // check if the query executed
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        
        // continue while there is a result
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int accountId = sqlite3_column_int(statement, 0);
            char *nameChar = (char *) sqlite3_column_text(statement, 1);
            char *passwordChar = (char *) sqlite3_column_text(statement, 2);
            int type = sqlite3_column_int(statement, 3);
            char *imageChar = (char *) sqlite3_column_text(statement, 4);
            NSArray *statistics = [self loadAccountStatistics:accountId];
            
            NSString *name = [[NSString alloc] initWithUTF8String:nameChar];
            NSString *password = [[NSString alloc] initWithUTF8String:passwordChar];
            NSString *image = [[NSString alloc] initWithUTF8String:imageChar];
            
            Account *account = [[Account alloc] initWithId:accountId withName:name withPassword:password withType:type withImage:image
                                                withStatistics:statistics];
            [retrievedValue addObject:account];
            [name release];
            [password release];
            [image release];
        }
        sqlite3_finalize(statement);
    }
    return retrievedValue;
}

// load account's statistics based on the input and create Statistic objects based on the data pulled from the database
- (NSArray *)loadAccountStatistics:(int)accountId {
    NSMutableArray *retrievedValue = [[[NSMutableArray alloc] init] autorelease];
    NSString *query = [NSString stringWithFormat: @"SELECT accountId, level, score, min_victory_time, max_victory_time FROM Statistics WHERE accountId = '%d' ORDER BY level ASC;", accountId];
    
    sqlite3_stmt *statement;
    
    // check if the query executed
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        
        // continue while there is a result
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int accountId = sqlite3_column_int(statement, 0);
            int level = sqlite3_column_int(statement, 1);
            int score = sqlite3_column_int(statement, 2);
            double minTime = sqlite3_column_double(statement, 3);
            double maxTime = sqlite3_column_double(statement, 4);
            
            Statistics *statistic = [[Statistics alloc] initWithParameters:accountId withLevel:level withScore:score withMinTime:minTime withMaxTime:maxTime];
            [retrievedValue addObject:statistic];
        }
        sqlite3_finalize(statement);
    }
    return retrievedValue;
}

// create a new account
- (BOOL)createAccount:(int)accountId withName:(NSString*)name withPassword:(NSString*)password withLevel:(int)type {
    
    NSString *query = [NSString stringWithFormat: @"INSERT INTO Accounts (accountId, name, password, type, profile_image) VALUES (?,?,?,?,?);"];
    
    sqlite3_stmt *statement;
    
    // check if the query executed
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        sqlite3_bind_int(statement, 1, accountId);
        sqlite3_bind_text(statement, 2, [name UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3, [password UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(statement, 4, type);
        sqlite3_bind_text(statement, 5, "", -1, SQLITE_TRANSIENT);
        
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"error: %s", sqlite3_errmsg(_database));
            sqlite3_reset(statement);
            return false;
        }
        
        sqlite3_finalize(statement);
    }
    return true;
}

- (int)getLastAccountId {
    NSString *query = @"SELECT accountID FROM Accounts ORDER BY accountID DESC LIMIT 1;";
    sqlite3_stmt *statement = nil;
    int lastAccountId = 0;
    
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        // continue while there is a result
        while (sqlite3_step(statement) == SQLITE_ROW) {
            lastAccountId = sqlite3_column_int(statement, 0);
        }
        sqlite3_finalize(statement);
    }
    return lastAccountId;
}

- (int)getAdminAccountId {
    NSString *query = @"SELECT accountID FROM Accounts WHERE (type = 1) LIMIT 1;";
    sqlite3_stmt *statement = nil;
    int lastAccountId = 0;
    
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        // continue while there is a result
        while (sqlite3_step(statement) == SQLITE_ROW) {
            lastAccountId = sqlite3_column_int(statement, 0);
        }
        sqlite3_finalize(statement);
    }
    return lastAccountId;
}

// Update a specific account with the new provided information
- (BOOL)updateAccount:(int)accountId withName:(NSString *)name withPassword:(NSString *)password {
    NSString *query = @"UPDATE Accounts SET name = ?, password = ? WHERE (accountId = ?);";
    
    sqlite3_stmt *statement = nil;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [name UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [password UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(statement, 3, accountId);
        
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"error: %s", sqlite3_errmsg(_database));
            sqlite3_reset(statement);
            return false;
        }
        
        sqlite3_finalize(statement);
    }
    return true;
}

// Delete a specific account from the database
- (BOOL)deleteAccount:(int)accountId {
    NSString *query = @"DELETE FROM Accounts WHERE (accountId = ?);";
    
    sqlite3_stmt *statement = nil;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        sqlite3_bind_int(statement, 1, accountId);
        
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"error: %s", sqlite3_errmsg(_database));
            sqlite3_reset(statement);
            return false;
        }
        
        sqlite3_finalize(statement);
    }
    return true;
}

// update a specific statistic in the Statistic table based on the input
- (void)updateStatistic:(int)accountId withLevel:(int)level withStatistic:(Statistics *)statistic {
    NSString *query = @"UPDATE Statistics SET score = ?, min_victory_time = ?, max_victory_time = ? WHERE (accountId = ? AND level = ?);";
    
    sqlite3_stmt *statement = nil;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        sqlite3_bind_int(statement, 1, statistic.score);
        sqlite3_bind_double(statement, 2, statistic.minTime);
        sqlite3_bind_double(statement, 3, statistic.maxTime);
        sqlite3_bind_int(statement, 4, accountId);
        sqlite3_bind_int(statement, 5, level);
        
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"error: %s", sqlite3_errmsg(_database));
            sqlite3_reset(statement);
        }
        
        sqlite3_finalize(statement);
    }
}

// insert a new statistic into the Statistic table based on the input
- (void)createStatistic:(int)accountId withLevel:(int)level withScore:(int)score witTime:(double)time {
    
    NSString *query = @"INSERT INTO Statistics (accountId, level, score, min_victory_time, max_victory_time) VALUES (?,?,?,?,?);";

    sqlite3_stmt *statement = nil;
    
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        sqlite3_bind_int(statement, 1, accountId);
        sqlite3_bind_int(statement, 2, level);
        sqlite3_bind_int(statement, 3, score);
        sqlite3_bind_double(statement, 4, time);
        sqlite3_bind_double(statement, 5, time);

        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"error: %s", sqlite3_errmsg(_database));
            sqlite3_reset(statement);
        }
        
        sqlite3_finalize(statement);
    }
}



// releasing all retained objects
- (void)dealloc {
    sqlite3_close(_database);
    [super dealloc];
}

@end
