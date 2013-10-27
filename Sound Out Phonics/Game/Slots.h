//
//  Slots.h
//  Sound Out Phonics
//
//  Created by Oleg M on 2013-10-26.
//  Copyright (c) 2013 Team Redundant Team. All rights reserved.
//

#import "CCSprite.h"
#import "CCLabelTTF.h"
@interface Slots : CCSprite {
    CCLabelTTF *graphyme;
}
- (id) initWithPosition:(CGPoint)pos;
@property (retain) CCLabelTTF *graphyme;
@end
