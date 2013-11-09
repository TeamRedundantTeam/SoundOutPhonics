//
//  Level.m
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

#import "Level.h"

@implementation Level

@synthesize levelId = _levelId;
@synthesize name = _name;
@synthesize graphemes = _graphemes;
@synthesize spriteLocation = _spriteLocation;

// Initializes the object with parameters received from the XML parser
- (id)initWithParameters:(int)levelId withName:(NSString *)name withGraphemes:(NSString *)graphemes withImageLocation:(NSString *)imageLocation {
    if ((self = [super init])) {
        self.levelId = levelId;
        self.name = name;
        self.graphemes = graphemes;
        self.spriteLocation = imageLocation;
    }
    return self;
}

// Creates the sprite based on the specified spriteLocation
- (void)createSprite {
    _sprite = [CCSprite spriteWithFile:self.spriteLocation];
}

// Returns reference to the sprite
- (CCSprite *)sprite {
    return _sprite;
}

// Removes the referenced sprite. The cleanup for this object should be done within the layer.
- (void)removeSprite {
    _sprite = nil;
}

- (void)dealloc {
    self.name = nil;
    self.graphemes = nil;
    [super dealloc];
}
@end
