//
//  TTS.m
//  Sound Out Phonics
//
//  Purpose: Helper class that enables the text to speech functionality using
//           OpenEars library
//
//  History: History of the file can be found here: https://github.com/TeamRedundantTeam/SoundOutPhonics/commits/master/Sound%20Out%20Phonics/Helpers/TextToSpeech.m
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
//  Created on 2013-10-24.
//  Copyright (c) 2013 Team Redundant Team. All rights reserved.
//

#import "TextToSpeech.h"


// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "CCTouchDispatcher.h"

@implementation TextToSpeech
@synthesize fliteController;
@synthesize slt;

// on "init" you need to initialize your instance
- (id)init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if((self = [super init])) {
    }
	return self;
}

- (FliteController *)fliteController {
	if (fliteController == nil) {
		fliteController = [[FliteController alloc] init];
	}
	return fliteController;
}

- (Slt *)slt {
	if (slt == nil) {
		slt = [[Slt alloc] init];
	}
	return slt;
}

// on "dealloc" you need to release all your retained objects
- (void)dealloc
{
	[super dealloc];
}

- (void)playWord:(NSString*)input {
    [self.fliteController say:input withVoice:self.slt];
}
@end
