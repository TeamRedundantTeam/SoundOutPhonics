//
//  LoginLayer.h
//  Sound Out Phonics
//
//  Purpose: Login layer and scene that asks user for login information
//
//  History: History of the file can be found here: https://github.com/TeamRedundantTeam/SoundOutPhonics/commits/master/Sound%20Out%20Phonics/Menu/LoginLayer.h
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
//  Created on 2013-11-5.
//  Copyright (c) 2013 Team Redundant Team. All rights reserved.
//


#import "cocos2d.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "MenuLayer.h"
#import "SOPDatabase.h"
#import "Account.h"
#import "LoginButton.h"
#import <UIKit/UIKit.h>
#import "Singleton.h"

@interface LoginLayer : CCLayer <UITextFieldDelegate> {
    UITextField *_passwordTextBox; // Password textbox input field
    NSMutableArray *_avatarNames; // The names that are displayed under the avatars
    NSArray *_accounts; // All accounts from the database
    Account *_selectedAccount; // Account that is currently selected by the user
    LoginButton *_loginButton; // login button
    CCSprite *_selectedAvatarBorder; // A border for avatar to indicate that it is selected
    NSMutableArray *_avatars;
}

@property (retain, nonatomic) UITextField *passwordTextBox;
@property (retain, nonatomic) NSMutableArray *avatarNames;
@property (retain, nonatomic) NSArray *accounts;
@property (retain, nonatomic) Account *selectedAccount;
//@property (retain, nonatomic) SubmitButton *submitButton;
@property (retain, nonatomic) NSMutableArray *avatars;
// returns a CCScene that contains the MenuLayer as the only child
+ (CCScene *)scene;

@end