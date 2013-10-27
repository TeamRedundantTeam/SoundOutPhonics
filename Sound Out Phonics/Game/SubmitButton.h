//
//  SubmitButton.h
//  Sound Out Phonics
//
//  Created by Oleg M on 2013-10-26.
//  Copyright (c) 2013 Team Redundant Team. All rights reserved.
//

#import "CCSprite.h"

@interface SubmitButton : CCSprite {
    bool state;
}
- (id) initWithPosition:(CGPoint)pos;
- (bool) state;
- (void) setState: (bool)input;
@end
