//
//  SubmitButton.m
//  Sound Out Phonics
//
//  Created by Oleg M on 2013-10-26.
//  Copyright (c) 2013 Team Redundant Team. All rights reserved.
//

#import "SubmitButton.h"

@implementation SubmitButton

- (id)initWithPosition:(CGPoint)pos {
    if((self = [super initWithFile:@"SubmitButton.png"])) {
        self.position = pos;
        self.opacity = 80;
    }
    return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc {
    [super dealloc];
}

- (void) setState:(bool)input {
    if (input) {
        self.opacity = 255;
        state = true;
    }
    else {
        self.opacity = 80;
        state = false;
    }
}

- (bool) state {
    return state;
}
@end
