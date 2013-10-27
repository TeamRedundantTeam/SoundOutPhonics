//
//  SubmitButton.m
//  Sound Out Phonics
//
//  Purpose: Helper class that handles the submit button creation and various states of the button to indicate if the button is enabled or not
//  History: History of the file can be found here: https://github.com/TeamRedundantTeam/SoundOutPhonics/commits/master/Sound%20Out%20Phonics/Game/SubmitButton.m
//
//  Created by Oleg Matvejev on 2013-10-26.
//  Copyright (c) 2013 Team Redundant Team. All rights reserved.
//

#import "SubmitButton.h"

@implementation SubmitButton

- (id)initWithPosition:(CGPoint)pos {
    if ((self = [super initWithFile:@"SubmitButton.png"])) {
        self.position = pos;
        self.opacity = 80;
    }
    return self;
}

// on "dealloc" you need to release all your retained objects
- (void)dealloc {
    [super dealloc];
}

// The button will become greyed out depending on the state
- (void)setState:(bool)input {
    if (input) {
        self.opacity = 255;
        state = true;
    }
    else {
        self.opacity = 80;
        state = false;
    }
}

- (bool)state {
    return state;
}
@end
