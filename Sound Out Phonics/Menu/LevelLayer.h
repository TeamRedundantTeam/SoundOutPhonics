//
//  LevelSelect.h
//  Sound Out Phonics
//
//  Purpose: Menu layer and scene that has verious menu items based on the user type.
//
//  History: History of the file can be found here: https://github.com/TeamRedundantTeam/SoundOutPhonics/commits/master/Sound%20Out%20Phonics/Menu/LevelSelect.h
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
//  Created on 2013-11-09.
//  Copyright (c) 2013 Team Redundant Team. All rights reserved.
//


#import "cocos2d.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "LevelParser.h"
#import "Level.h"
#import "Singleton.h"
#import "GameLayer.h"

@interface LevelLayer : CCLayer {
    NSArray *_levels;
}

@property (retain, nonatomic) NSArray *levels;
// returns a CCScene that contains the MenuLayer as the only child
+ (CCScene *)scene;

@end
