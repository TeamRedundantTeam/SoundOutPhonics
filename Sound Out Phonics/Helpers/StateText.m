//
//  StateText.m
//  Sound Out Phonics
//
//  Purpose: Helper class that handles the text creation that has states
//           which indicate if the text is enabled or not
//
//  History: History of the file can be found here: https://github.com/TeamRedundantTeam/SoundOutPhonics/commits/master/Sound%20Out%20Phonics/Helpers/StateText.m
//
//  Style: The source code will follow the general apple coding standard described
//         here: https://tinyurl.com/n8jtvj3
//         Furthermore, the source code will be self descriptive and the formating
//         will be consistent through the project. Long methods will be broken down
//         and will have description of what the method does. The variable names and
//         methods will follow the lower camel style (ex: selectedGraphemePosition),
//         the classes will follow the upper camel style (ex: GameLayer) and the
//         files will use the Cocos2d-iphone file name convention (ex: Lvl1-Apple-
//         Sprite.png). Finally, the code will have comments throughout various non
//         trivial operations.
//
//  Created on 2013-11-23.
//  Copyright (c) 2013 Team Redundant Team. All rights reserved.
//

#import "StateText.h"

@implementation StateText

// Intialized the text sprite with a specified string, fontName, fontSize and position
- (id)initWithString:(NSString *)string fontName:(NSString *)name fontSize:(CGFloat)size position:(CGPoint) pos {
    if ((self = [super initWithString:string fontName:name fontSize:size])) {
        self.position = pos;
        self.opacity = 80;
    }
    return self;
}
- (id)initWithFile:(NSString *)filename withPosition:(CGPoint)pos {
    if ((self = [super initWithFile:filename])) {
        self.position = pos;
        self.opacity = 80;
    }
    return self;
}

// on "dealloc" you need to release all your retained objects
- (void)dealloc {
    [super dealloc];
}

// the button will become greyed out depending on the state
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