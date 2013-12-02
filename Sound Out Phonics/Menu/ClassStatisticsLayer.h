//
//  ClassStatisticLayer.m
//  Sound Out Phonics
//
//  Purpose: A layer that displays all the students statistics as a whole including graph which show how many % of
//           students were able to complete a perticular level.
//
//  History: History of the file can be found here: https://github.com/TeamRedundantTeam/SoundOutPhonics/commits/master/Sound%20Out%20Phonics/Menu/ClassStatisticLayer.m
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
//  Created on 2013-12-2.
//  Copyright (c) 2013 Team Redundant Team. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "StatisticLayer.h"

@interface ClassStatisticsLayer : CCLayer {
    CGSize _size; // Used to store the screen size
}

// returns a CCScene that contains the StatisticLayer as the only child
+ (CCScene *)scene;

@end
