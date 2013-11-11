//
//  Singleton.h
//  Sound Out Phonics
//
//  Purpose: Provide a singleton class that has information about the logged in account and the selected level that
//           can be accessed by various scenes throughout the game.
//
//  History: History of the file can be found here: https://github.com/TeamRedundantTeam/SoundOutPhonics/commits/master/Sound%20Out%20Phonics/Shared/Singleton.h
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

#import <Foundation/Foundation.h>
#import "Account.h"
#import "Level.h"

@interface Singleton : NSObject {
    Account *_loggedInAccount; // the reference to an account that is currently logged used to transition logged in account between scenes.
    Level *_selectedLevel; // the reference to the level that is currently selected. Used to replay levels and determine next level.
}

// create a shared accessor
+ (Singleton *)sharedSingleton;

// setter method that sets the logged in account based on the input. The previous logged in account is released from memory
- (void)setLoggedInAccount:(Account *)input;

// setter method that sets the selected level based on the input. The previous selected level is released from memory
- (void)setSelectedLevel:(Level *)input;

// getter method to the logged in account
- (Account *)loggedInAccount;

// getter method to the selected level
- (Level *)selectedLevel;
@end
