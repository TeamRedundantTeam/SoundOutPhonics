//
//  Singleton.m
//  Sound Out Phonics
//
//  Purpose: Provide a singleton class that has information about the logged in account and the selected level that
//           can be accessed by various scenes throughout the game.
//
//  History: History of the file can be found here: https://github.com/TeamRedundantTeam/SoundOutPhonics/commits/master/Sound%20Out%20Phonics/Shared/Singleton.m
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
//  Created on 2013-11-6.
//  Copyright (c) 2013 Team Redundant Team. All rights reserved.
//

#import "Singleton.h"

@implementation Singleton
static Singleton *_sigleton = nil;

// Create a shared accessor
+ (Singleton *)sharedSingleton {
	@synchronized([Singleton class]) {
		if (!_sigleton)
			[[self alloc] init];
        
		return _sigleton;
	}
	return nil;
}

// Allow only one instance of singleton to be allocated at a time
+ (id)alloc {
	@synchronized([Singleton class]) {
		NSAssert(_sigleton == nil, @"Attempted to allocate a second instance of a singleton.");
		_sigleton = [super alloc];
		return _sigleton;
	}
	return nil;
}

// Initialization of the class
-(id)init {
	self = [super init];
	if (self != nil) {
		// initialize stuff here
	}
	return self;
}

// Setter method that sets the logged in account based on the input. The previous logged in account is released from memory
- (void)setLoggedInAccount:(Account *) input {
    [_loggedInAccount release];
    _loggedInAccount = input;
}

// Setter method that sets the selected level based on the input. The previous selected level is released from memory
- (void)setSelectedLevel:(Level *) input {
    [_selectedLevel release];
    _selectedLevel = input;
}

// Getter method to the logged in account
- (Account *)loggedInAccount {
    return _loggedInAccount;
}

// Getter method to the selected level
- (Level *)selectedLevel {
    return _selectedLevel;
}

- (void)dealloc {
    [_loggedInAccount release];
    [_selectedLevel release];
    [super dealloc];
}
@end
