//
//  LevelSelect.h
//  Sound Out Phonics
//
//  Purpose: Level select layer and scene that allows player to choose which level they want to play
//
//  History: History of the file can be found here:
//           https://github.com/TeamRedundantTeam/SoundOutPhonics/commits/master/Sound%20Out%20Phonics/Menu/LevelLayer.h
//           https://github.com/TeamRedundantTeam/SoundOutPhonics/commits/master/Sound%20Out%20Phonics/Menu/LevelSelectLayer.h
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
#import "MenuLayer.h"

@interface LevelSelectLayer : CCLayer {
    NSArray *_levels; // Reference to all the loaded levels
    CGSize _size; // Used to store the screen size
    int _currentLevelsPage; // Keeps track of the current levels page
    CCSprite *_nextLevelsPage; // Reference to the next level page arrow sprite
    CCSprite *_lastLevelsPage; // Reference to the previous level page arrow sprite
}

// returns a CCScene that contains the LevelLayer as the only child
+ (CCScene *)scene;

@end
