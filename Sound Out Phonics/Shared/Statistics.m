//
//  Statistics.m
//  Sound Out Phonics
//
//  Purpose: Object that stores information about player statistics on various levels such as the score received for a level, fastest completion time and average time it takes for the player to complete the level.
//
//  History: History of the file can be found here: https://github.com/TeamRedundantTeam/SoundOutPhonics/commits/master/Sound%20Out%20Phonics/Shared/Statistics.m
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

#import "Statistics.h"

@implementation Statistics
@synthesize accountId = _accountId;
@synthesize level = _level;
@synthesize score = _score;
@synthesize minTime = _minTime;
@synthesize maxTime = _maxTime;

// Initializes the object with parameters received from the SQLite database
- (id)initWithParameters:(int)accountId withLevel:(int)level withScore:(int)score withMinTime:(double)minTime withMaxTime:(double)maxTime {
    if ((self = [super init])) {
        self.accountId = accountId;
        self.level = level;
        self.score = score;
        self.minTime = minTime;
        self.maxTime = maxTime;
    }
    return self;
}

- (void) dealloc {
    [super dealloc];
}
@end
