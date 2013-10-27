//
//  SubmitButton.h
//  Sound Out Phonics
//
//  Purpose: Helper class that handles the submit button creation and various states of the button to indicate if the button is enabled or not
//  History: History of the file can be found here: https://github.com/TeamRedundantTeam/SoundOutPhonics/commits/master/Sound%20Out%20Phonics/Game/SubmitButton.h
//
//  Created by Oleg Matvejev on 2013-10-26.
//  Copyright (c) 2013 Team Redundant Team. All rights reserved.
//

#import "CCSprite.h"

@interface SubmitButton : CCSprite {
    bool state;
}
- (id)initWithPosition:(CGPoint)pos;
- (bool)state;
- (void)setState:(bool)input;
@end
