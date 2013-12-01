//
//  ManageAccountLayer.h
//  Sound Out Phonics
//
//  Purpose: A layer that allows administrators to edit and add new accounts
//
//  History: History of the file can be found here: https://github.com/TeamRedundantTeam/SoundOutPhonics/commits/master/Sound%20Out%20Phonics/Menu/ManageAccountLayer.h
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

#import "CCLayer.h"
#import "cocos2d.h"
#import "Account.h"
#import "SOPDatabase.h"
#import "StateText.h"
#import "MenuLayer.h"
#import "EditAccountLayer.h"

@interface ManageAccountLayer : CCLayer <UITextFieldDelegate> {
    CGSize _size;
    NSArray *_accounts; // stores reference to all the accounts from the database
    Account *_selectedAccount; // account that is currently selected by the user
    CCSprite *_selectedAvatarBorder; // a border for avatar to indicate that it is selected
    int _currentAccountPage; // The account page that the user has currently selected
    CCSprite *_lastAccountsPage; // Sprite that allows users to move to the previous account page
    CCSprite *_nextAccountsPage; // Sprite that allows users to move to the next account page
    StateText *_editAccountButton;
    CCLabelTTF *_createAccountButton;
    StateText *_deleteAccountButton;
    CCSprite *_homeButton;
}

// returns a CCScene that contains the ManageAccountLayer as the only child
+ (CCScene *)scene;

// Pulls new accounts from the database
- (void)updateAccounts;

// Updates the account sprites
- (void)updateAccountsSprites;

@property (retain, nonatomic) NSArray *accounts;
@property (retain, nonatomic) Account *selectedAccount;

@end
