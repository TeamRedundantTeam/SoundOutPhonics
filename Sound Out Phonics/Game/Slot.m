//
//  Slots.m
//  Sound Out Phonics
//
//  Purpose: Helper class that handles the slots creation and keeping track of the graphemes that are associated to each of the slot
//  History: History of the file can be found here:
//           Version 0.1 - 0.5: https://github.com/TeamRedundantTeam/SoundOutPhonics/commits/master/Sound%20Out%20Phonics/Game/Slots.m
//           Version 0.6 + : https://github.com/TeamRedundantTeam/SoundOutPhonics/commits/master/Sound%20Out%20Phonics/Game/Slot.m
//
//  Created by Oleg Matvejev on 2013-10-26.
//  Copyright (c) 2013 Team Redundant Team. All rights reserved.
//

#import "Slot.h"

@implementation Slot
@synthesize grapheme;

- (id)initWithPosition:(CGPoint)pos {
    if ((self = [super initWithFile:@"Slot.png"])) {
        self.position = pos;
    }
    return self;
}

// on "dealloc" you need to release all your retained objects
- (void)dealloc{
    [super dealloc];
}

@end