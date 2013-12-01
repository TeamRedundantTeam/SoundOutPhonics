//
//  ManageAccountLayer.m
//  Sound Out Phonics
//
//  Purpose: A layer that allows administrators to edit and add new accounts
//
//  History: History of the file can be found here: https://github.com/TeamRedundantTeam/SoundOutPhonics/commits/master/Sound%20Out%20Phonics/Menu/ManageAccountLayer.m
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

#import "ManageAccountLayer.h"

#pragma mark - ManageAccountLayer

@implementation ManageAccountLayer
@synthesize accounts = _accounts;
@synthesize selectedAccount = _selectedAccount;

// helper class method that creates a Scene with the LoginLayer as the only child.
+ (CCScene *)scene {
    // 'scene' is an autorelease object.
    CCScene *scene = [CCScene node];
        
    // 'layer' is an autorelease object.
    ManageAccountLayer *layer = [ManageAccountLayer node];

        
    // add layer as a child to scene
    [scene addChild:layer z: 1 tag:1];
        
    // return the scene
    return scene;
}

- (id)init {
	if((self = [super init])) {
        
		// ask director for the window size
		_size = [[CCDirector sharedDirector] winSize];
        
        [self setTouchEnabled:YES];
        
        // Initialize and add the background sprites
        CCSprite *background = [CCSprite spriteWithFile:@"Default-Background.png"]; // create and initialize the background sprite (png)
        CCLabelTTF *titleName = [CCLabelTTF labelWithString:@"MANAGE ACCOUNTS" fontName:@"KBPlanetEarth" fontSize:48];
        
        background.position = ccp(_size.width/2, _size.height/2);
        titleName.position = ccp(_size.width/2, _size.height-75);
        
        [self addChild:background];
        [self addChild:titleName];
        
        // add the HOME icon to the screen which returns the user to the main menu on press
        CCMenuItemImage *itemHome = [CCMenuItemImage itemWithNormalImage:@"Home-IconFinal.png" selectedImage:@"Home-IconFinal.png" target:self selector:@selector(goHome:)];
        CCMenu *menu = [CCMenu menuWithItems:itemHome, nil];
        [menu setPosition:ccp(_size.width - 100, _size.height - _size.height + 40)];
		[self addChild:menu];
        
        // load the accounts from the database
        self.accounts = [[SOPDatabase database] loadAccounts];
        
        _currentAccountPage = 1;
        
        // create the selected avatar frame
        _selectedAvatarBorder = [CCSprite spriteWithFile:@"Selected-Portrait.png"];
        _selectedAvatarBorder.visible = false;
        [self addChild:_selectedAvatarBorder];
        
        // Initialize and add the paging button sprites
        _lastAccountsPage = [CCSprite spriteWithFile:@"Arrow.png"];
        _nextAccountsPage = [CCSprite spriteWithFile:@"Arrow.png"];
        
        _lastAccountsPage.position = ccp(_size.width/2 - 375, _size.height - 250);
        _nextAccountsPage.position = ccp(_size.width/2 + 375, _size.height - 250);
        
        // Rotate the sprite by 180 degrees CW
        _nextAccountsPage.rotation = 180;
        
        // In some cases paging might not be needed so the sprites are invisible by default and enabled later on
        _lastAccountsPage.visible = false;
        _nextAccountsPage.visible = false;
        
        [self addChild:_lastAccountsPage];
        [self addChild:_nextAccountsPage];
        
        [self displayAccounts];
        
        // Add edit account button.
        _editAccountButton = [[StateText alloc] initWithString:@"Edit Account" fontName:@"KBPlanetEarth" fontSize:48 position:ccp(_size.width/2, _size.height/2 - 50)];
        [_editAccountButton setState:false];
        [self addChild:_editAccountButton];
        
        // Add delete account button
        _deleteAccountButton = [[StateText alloc] initWithString:@"Delete Account" fontName:@"KBPlanetEarth" fontSize:48
                                                        position:ccp(_size.width/2, _size.height/2 - 125)];
        [_deleteAccountButton setState:false];
        [self addChild:_deleteAccountButton];
        
        // add create account button
        _createAccountButton = [CCLabelTTF labelWithString:@"Create Account" fontName:@"KBPlanetEarth" fontSize:48];
        _createAccountButton.position = ccp(_size.width/2, _size.height/2 - 200);
        [self addChild:_createAccountButton];
    }
    return self;
}

// function called by pressing HOME button to return to main menu
- (void)goHome:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MenuLayer scene]]];
}

// create the account avatars and names
- (void) displayAccounts {

    // Number of results that will be displayed per page
    int results = 5;
    
    // Calculate the difference to determine if there are more accounts than results.
    int difference = _currentAccountPage * results - [self.accounts count];
    int accountsOnPage;
    
    if (difference > 0)
        accountsOnPage = results - difference;
    else
        accountsOnPage = results;
    
    if (_currentAccountPage != 1)
        _lastAccountsPage.visible = true;
    if (_currentAccountPage * results < [self.accounts count])
        _nextAccountsPage.visible = true;
    
    // In the case when there are no accounts on page then move to the last page and display
    // accounts with the new page
    if (_currentAccountPage != 1 && accountsOnPage == 0) {
        _currentAccountPage--;
        [self displayAccounts];
    }
        
    int i = 0;
    for (Account *account in self.accounts) {
        
        if (i >= (_currentAccountPage - 1) * results && i < _currentAccountPage * results) {
            // display what type of account it is.
            CCLabelTTF *accountType;
            
            // determine which string should be displayed based on the account type
            if (account.type == 1)
                accountType = [CCLabelTTF labelWithString:@"Teacher" fontName:@"KBPlanetEarth" fontSize:24];
            else
                accountType = [CCLabelTTF labelWithString:@"Student" fontName:@"KBPlanetEarth" fontSize:24];
            
            // determine the position dynamicly based on how many objects are present in the array
            if (_currentAccountPage == 1)
                accountType.position = ccp(_size.width/2 - (accountsOnPage - 1) * 70 + i % results * 140, _size.height-135);
            else
                accountType.position = ccp(_size.width/2 - (results - 1) * 70 + i % results * 140, _size.height-135);
            
            accountType.tag = 0;
            [self addChild:accountType];
            
            // add the avatar for a specific account
            [account createAvatar];
            if (_currentAccountPage == 1)
                account.avatar.position = ccp(_size.width/2 - (accountsOnPage - 1) * 70 + i % results * 140, _size.height-230);
            else
                account.avatar.position = ccp(_size.width/2 - (results - 1) * 70 + i % results * 140, _size.height-230);

            account.avatar.visible = true;
            [self addChild:account.avatar];
            
            // create user name under the avatar
            CCLabelTTF *avatarName = [CCLabelTTF labelWithString:account.name fontName:@"KBPlanetEarth" fontSize:24];
            if (_currentAccountPage == 1)
                avatarName.position = ccp(_size.width/2 - (accountsOnPage - 1) * 70 + i % results * 140, _size.height-330);
            else
                avatarName.position = ccp(_size.width/2 - (results - 1) * 70 + i % results * 140, _size.height-330);
            avatarName.tag = 0;
            [self addChild:avatarName];
        }
        i++;
    }
}

// dispatcher to catch the touch events
- (void)registerWithTouchDispatcher {
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

// handles the events that happen when the release occurs at a specific location
- (void)tapReleaseAt:(CGPoint)releaseLocation {
    
    // check if the user has pressed the next account page sprite.
    if (_nextAccountsPage.visible && CGRectContainsPoint(_nextAccountsPage.boundingBox, releaseLocation)) {
        _currentAccountPage++;
        
        [self cleanupSprites];
        
        // display the new account page
        [self displayAccounts];
    }
    
    // check if the user has pressed the last account page sprite.
    if (_lastAccountsPage.visible && CGRectContainsPoint(_lastAccountsPage.boundingBox, releaseLocation)) {
        
        // The first page is always 1. Make sure that the current page doesn't go out of those bounds
        if (_currentAccountPage > 1) {
            _currentAccountPage--;
            
            // cleanup all temporary objects before proceeding to the next stage
            [self cleanupSprites];
            
            // display the new account page
            [self displayAccounts];
        }
    }
    
    // checks if one of the accounts has been selected
    for (Account *account in self.accounts) {
        if (account.avatar.visible && CGRectContainsPoint(account.avatar.boundingBox, releaseLocation)) {
            self.selectedAccount = account;
            
            // make the avatar box visible since we now have a selected account
            if (!_selectedAvatarBorder.visible)
                _selectedAvatarBorder.visible = true;
            
            // move the border to the new selected avatar
            _selectedAvatarBorder.position = ccp(self.selectedAccount.avatar.position.x, self.selectedAccount.avatar.position.y);
    
            _editAccountButton.state = true;
            if (self.selectedAccount.accountId != [Singleton sharedSingleton].loggedInAccount.accountId)
                _deleteAccountButton.state = true;
            else
                _deleteAccountButton.state = false;
            break;
        }
    }
    
    if (self.selectedAccount && _editAccountButton.state && CGRectContainsPoint(_editAccountButton.boundingBox, releaseLocation)) {
        ccColor4B color = {100,100,0,100};
        EditAccountLayer *layer = [[[EditAccountLayer alloc] initWithColor:color withAccount:self.selectedAccount] autorelease];
        [self addChild:layer];
    }
    
    if (CGRectContainsPoint(_createAccountButton.boundingBox, releaseLocation)) {
        ccColor4B color = {100,100,0,100};
        CreateAccountLayer *layer = [[[CreateAccountLayer alloc] initWithColor:color withLevel:0] autorelease];
        [self addChild:layer];
    }
    
    if (CGRectContainsPoint(_backButton.boundingBox, releaseLocation)) {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MenuLayer scene]]];
    }
    
    if (self.selectedAccount && _deleteAccountButton.state && CGRectContainsPoint(_deleteAccountButton.boundingBox, releaseLocation)) {
        if (self.selectedAccount.accountId != [Singleton sharedSingleton].loggedInAccount.accountId)
        {
            if ([[SOPDatabase database] deleteAccount:self.selectedAccount.accountId]) {
                [self updateAccounts];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Selected account has been deleted!"
                                                               delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
                [alert release];
            }
            else {
                // Send an alert indicating that you cannot delete your own account
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Cannot delete your own account!"
                                                               delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
                [alert release];
            }
        }
        else {
            // Send an alert indicating that an error occured
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to delete the selected account!"
                                                           delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }

    }
}

// event that is called when the touch has ended
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint releaseLocation = [touch locationInView:[touch view]];
    releaseLocation = [[CCDirector sharedDirector] convertToGL:releaseLocation];
    [self tapReleaseAt:releaseLocation];
}

// event that is called when the touch begins
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    return YES;
}

// Updates the accounts sprites only
- (void)updateAccountsSprites {
    
    // cleanup all temporary objects before proceeding to the next stage
    [self cleanupSprites];
    
    // display the new account page
    [self displayAccounts];
}

// Pulls new accounts from the database
- (void)updateAccounts {
    
    [self.selectedAccount release];
    
    [self cleanupSprites];
    
    // Release all the accounts in the array
    for (Account* account in self.accounts)
        [account release];
    
    // load the accounts from the database
    self.accounts = [[SOPDatabase database] loadAccounts];
    
    [self updateAccountsSprites];
}

// removes all the temporary objects from the scene
- (void)cleanupSprites {
    
    for (Account *account in self.accounts) {
        account.avatar.visible = false;
    }
    
    // Remove all children that were tagged as 0
    while ([self getChildByTag:0]) {
        [self removeChildByTag:0 cleanup:true];
    }
    
    _nextAccountsPage.visible = false;
    _lastAccountsPage.visible = false;
    
    _selectedAvatarBorder.visible = false;
    _selectedAccount = nil;
    
    _editAccountButton.state = false;
    _deleteAccountButton.state = false;
}

// Release all the retained objects
- (void)dealloc {
    [self.selectedAccount release];
    [_editAccountButton release];
    [_deleteAccountButton release];

    // Release all the accounts in the array
    for (Account* account in self.accounts)
        [account release];
    
    [self.accounts release];
    
    [super dealloc];
}
    

#pragma mark ManageAccountLayer delegate
@end
