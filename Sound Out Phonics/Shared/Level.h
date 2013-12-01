//
//  Level.h
//  Sound Out Phonics
//
//  Purpose: Object that stores level information from the parser
//
//  History: History of the file can be found here: https://github.com/TeamRedundantTeam/SoundOutPhonics/commits/master/Sound%20Out%20Phonics/Shared/Level.m
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
#import "cocos2d.h"

@interface Level : NSObject {
    int _levelId;
    NSString *_name;
    NSString *_graphemes;
    NSString *_spriteLocation;
    CCSprite *_sprite;
    Level *_nextLevel;
}

@property (nonatomic, assign) int levelId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *graphemes;
@property (nonatomic, copy) NSString *spriteLocation;
@property (nonatomic, retain) Level *nextLevel;

- (id)initWithParameters:(int)levelId withName:(NSString *)name withGraphemes:(NSString *)graphemes withImageLocation:(NSString *)imageLocation;
- (void)createSprite;
- (CCSprite *)sprite;
- (void)removeSprite;
- (NSString *) description;

@end
