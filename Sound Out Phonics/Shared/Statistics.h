//
//  Statistics.h
//  Sound Out Phonics
//
//  Purpose: Object that stores information about player statistics on various levels such as the score received for a level, slowest completion time for alevel and fastest time to complete the level.
//
//  History: History of the file can be found here: https://github.com/TeamRedundantTeam/SoundOutPhonics/commits/master/Sound%20Out%20Phonics/Shared/Statistics.h
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

@interface Statistics : NSObject {
    int _accountId;
    int _level;
    int _score;
    double _minTime;
    double _maxTime;
}
- (id)initWithParameters:(int)accountId withLevel:(int)level withScore:(int)score withMinTime:(double)minTime withMaxTime:(double)maxTime;
@property (assign, nonatomic) int accountId;
@property (assign, nonatomic) int level;
@property (assign, nonatomic) int score;
@property (assign, nonatomic) double minTime;
@property (assign, nonatomic) double maxTime;
@end
