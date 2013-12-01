//
//  LoginLayer.m
//  Sound Out Phonics
//
//  Purpose: Login layer and scene that asks user for login information
//
//  History: History of the file can be found here: https://github.com/TeamRedundantTeam/SoundOutPhonics/commits/master/Sound%20Out%20Phonics/Menu/LoginLayer.m
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


#import "LoginLayer.h"

#pragma mark - LoginLayer

@implementation LoginLayer

@synthesize passwordTextBox = _passwordTextBox;
@synthesize accounts = _accounts;
@synthesize selectedAccount = _selectedAccount;

// helper class method that creates a Scene with the LoginLayer as the only child.
+ (CCScene *)scene {
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	LoginLayer *layer = [LoginLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
- (id)init {
	if((self = [super init])) {
        
        // ask director for the window size
		_size = [[CCDirector sharedDirector] winSize];
        
        [self setTouchEnabled:YES];
        
        // Create and initialize a background sprite
        CCSprite *background = [CCSprite spriteWithFile:@"Background-Menu.png"];
        background.position = ccp(_size.width/2, _size.height/2);
        [self addChild: background];


            
        // load the accounts from the database
        self.accounts = [[SOPDatabase database] loadAccounts];
        
        _currentAccountPage = 1;

        // create the selected avatar frame
        _selectedAvatarBorder = [CCSprite spriteWithFile:@"Selected-Portrait.png"];
        _selectedAvatarBorder.visible = false;
        [self addChild:_selectedAvatarBorder];
        
        // create the password textbox
        self.passwordTextBox = [[UITextField alloc] initWithFrame:CGRectMake(_size.width/2-100, _size.height/2 - 25, 200, 50)];
        self.passwordTextBox.backgroundColor = [UIColor whiteColor];
        self.passwordTextBox.delegate = self;
        self.passwordTextBox.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.passwordTextBox.adjustsFontSizeToFitWidth = true;
        
        // grey text inside the box
        NSAttributedString *password = [[NSAttributedString alloc] initWithString:@"Password"];
        self.passwordTextBox.attributedPlaceholder = password;
        self.passwordTextBox.enabled = false;
        
        // no spellchecker and make the input text display as ****
        self.passwordTextBox.spellCheckingType = UITextSpellCheckingTypeNo;
        self.passwordTextBox.secureTextEntry = true;
        [password release];
        [[CCDirector sharedDirector].view addSubview:self.passwordTextBox];

        
        // Initialize and add the login button
        _loginButton = [[StateButton alloc] initWithFile:@"Login-Button.png" withPosition:ccp(_size.width/2, _size.height/2 - 75)];
        [_loginButton setState:false];
        [self addChild:_loginButton];
            
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
        
        // No accounts found and new account needs to be created
        if ([[SOPDatabase database] getAdminAccountId] == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Administrator Account found!"
                                                      message:@"No administrator account found. Would you like to create a new account or play as guest?"
                                                      delegate:self cancelButtonTitle:nil otherButtonTitles:@"Create Account", @"Guest Account", nil];
            [alert show];
            [alert release];
        }
    }
    return self;
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


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        
        ccColor4B color = {100,100,0,100};
        CreateAccountLayer *layer = [[[CreateAccountLayer alloc] initWithColor:color withLevel:1] autorelease];
        [self addChild:layer];
    }
    else {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MenuLayer scene]]];
        
        // cleanup after the transition
        [self.parent removeChild:self cleanup:YES];
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
            self.passwordTextBox.enabled = true;
            break;
        }
    }
    
    // occurs when the user presses the submit button
    if (self.selectedAccount && _loginButton.state && CGRectContainsPoint(_loginButton.boundingBox, releaseLocation)) {
        
        // the password was correct transition to the menu layer
        if ([self.selectedAccount.password isEqualToString:self.passwordTextBox.text]) {
            
            // password TextBox transition. TO-DO: make it smooth to match the layer transition
            [self.passwordTextBox removeFromSuperview];
            
            // we now have a logged in account pass it onto the Singleton class
            [[Singleton sharedSingleton] setLoggedInAccount:self.selectedAccount];
            
            // avatar object must be removed from the selected account since we are sharing this perticular account between layers and
            // CCSprite can only be attached to one layer. We are not removing the child from the layer because it makes the sprite dissapear
            // before the transition ends. This also assures that each sprite is assign to one layer.
            [self.selectedAccount removeAvatar];
            
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MenuLayer scene]]];
            
            // cleanup after the transition
            [self.parent removeChild:self cleanup:YES];
        }
        // password was incorrect display an error message
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid Password, try again!\n"
                                  delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
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

// occurs when return is pressed on the keyboard
- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    // terminate editing
    [textField resignFirstResponder];
    return YES;
}

// occurs when the editin is ended on the text field
- (void)textFieldDidEndEditing:(UITextField*)textField {
    // if the input text is empty then disable the submit button
    if ([self.passwordTextBox.text isEqualToString:@""])
        _loginButton.state = false;
    else
        _loginButton.state = true;
}

// Updates current accounts sprites
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
    
    self.passwordTextBox.enabled = false;
    _loginButton.state = false;
}

// on "dealloc" you need to release all your retained objects
- (void)dealloc
{
    // release all the accounts in the array
    for (Account* account in self.accounts)
        [account release];
    
    [self.accounts release];
    [_loginButton release];
	[super dealloc];
}

#pragma mark LoginLayer delegate

@end
