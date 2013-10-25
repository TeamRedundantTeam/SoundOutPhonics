//
//  SpritePicture.m
//  Sound Out Phonics
//
//  Created by Oleg M on 2013-10-24.
//  Copyright (c) 2013 Team Redundant Team. All rights reserved.
//

#import "SpritePicture.h"

@implementation SpritePicture

- (id)initWithPosition:(CGPoint)pos {
    if((self = [super initWithFile:@"Lvl1-Apple-Sprite.png"])) {
        self.position = pos;
    }
    return self;
}

@end
