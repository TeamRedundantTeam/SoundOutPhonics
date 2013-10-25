//
//  TTS.m
//  Sound Out Phonics
//
//  Created by Oleg M on 2013-10-24.
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
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
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
- (void) dealloc
{
	[super dealloc];
}

- (void) playWord : (NSString*) input {
    [self.fliteController say:input withVoice:self.slt];
}
@end
