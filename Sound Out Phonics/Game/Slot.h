//
//  Slots.h
//  Sound Out Phonics
//
//  Purpose: Helper class that handles the slots creation and keeping track of the graphemes that are associated to each of the slot
//  History: History of the file can be found here: https://github.com/TeamRedundantTeam/SoundOutPhonics/commits/master/Sound%20Out%20Phonics/Game/Slot.h
//
//  Created by Oleg Matvejev on 2013-10-26.
//  Copyright (c) 2013 Team Redundant Team. All rights reserved.
//

#import "CCSprite.h"
#import "CCLabelTTF.h"

@interface Slot : CCSprite {
    CCLabelTTF *grapheme; // Grapheme that is associated with this slot
}
- (id)initWithPosition:(CGPoint)pos;

@property (retain, nonatomic) CCLabelTTF *grapheme;

@end
