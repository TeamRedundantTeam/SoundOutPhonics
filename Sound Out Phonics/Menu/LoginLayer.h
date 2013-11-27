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
#import <UIKit/UIKit.h>
// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#import "MenuLayer.h"
#import "SOPDatabase.h"
#import "Account.h"
#import "StateButton.h"
#import "Singleton.h"

@interface LoginLayer : CCLayer <UITextFieldDelegate> {
    CGSize _size; // Used to store the screen size
    UITextField *_passwordTextBox; // password textbox input field
    NSArray *_accounts; // all accounts from the database
    Account *_selectedAccount; // account that is currently selected by the user
    StateButton *_loginButton; // login button
    CCSprite *_selectedAvatarBorder; // a border for avatar to indicate that it is selected
    int _currentAccountPage; // The account page that the user has currently selected
    CCSprite *_lastAccountsPage; // Sprite that allows users to move to the previous account page
    CCSprite *_nextAccountsPage; // Sprite that allows users to move to the next account page
}

@property (retain, nonatomic) UITextField *passwordTextBox;
@property (retain, nonatomic) NSMutableArray *avatarNames;
@property (retain, nonatomic) NSArray *accounts;
@property (retain, nonatomic) Account *selectedAccount;

// returns a CCScene that contains the LoginLayer as the only child
+ (CCScene *)scene;

@end