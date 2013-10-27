//
//  Slots.m
//  Sound Out Phonics
//
//  Created by Oleg M on 2013-10-26.
//  Copyright (c) 2013 Team Redundant Team. All rights reserved.
//

#import "Slots.h"

@implementation Slots
@synthesize graphyme;

- (id)initWithPosition:(CGPoint)pos {
    if((self = [super initWithFile:@"Slots.png"])) {
        self.position = pos;
    }
    return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc{
    [super dealloc];
}

@end