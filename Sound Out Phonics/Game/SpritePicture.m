//
//  SpritePicture.m
//  Sound Out Phonics
//
//  Purpose: Helper class that handles the picture sprite creation
//  History: History of the file can be found here: https://github.com/TeamRedundantTeam/SoundOutPhonics/commits/master/Sound%20Out%20Phonics/Game/SpritePicture.m
//
//  Created by Oleg Matvejev on 2013-10-24.
//  Copyright (c) 2013 Team Redundant Team. All rights reserved.
//

#import "SpritePicture.h"

@implementation SpritePicture

- (id)initWithPosition:(CGPoint)pos {
    if ((self = [super initWithFile:@"Lvl1-Apple-Sprite.png"])) {
        self.position = pos;
    }
    return self;
}

// on "dealloc" you need to release all your retained objects
- (void)dealloc{
    [super dealloc];
}
@end
