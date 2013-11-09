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
@synthesize avatarNames = _avatarNames;
@synthesize accounts = _accounts;
@synthesize selectedAccount = _selectedAccount;
//@synthesize submitButton = _submitButton;
@synthesize avatars = _avatars;
// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+ (CCScene *)scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	LoginLayer *layer = [LoginLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// Dispatcher to catch the touch events
- (void)registerWithTouchDispatcher {
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

// on "init" you need to initialize your instance
- (id)init
{
	if((self = [super init])) {
        
        // ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        [self setTouchEnabled:YES];

        self.accounts = [[SOPDatabase database] accountsInfo];
        self.avatarNames = [NSMutableArray array];
        
        // Create the account avatars and names
        // TO-DO: Organize into rows and multiple pages
        
        int i = 0;
        for (Account *account in self.accounts) {
            
            // Add the avatar
            [account createAvatar];
            account.avatar.position = ccp(size.width/4 + i*140, size.height-200);
            [self addChild:account.avatar];
            
            // Create user name under the avatar
            CCLabelTTF *avatarName = [CCLabelTTF labelWithString:account.name
                                                      fontName:@"Marker Felt" fontSize:24];
            avatarName.position = ccp(size.width/4 + i*140, size.height-300);
            [self addChild:avatarName];
            i++;
        }
        
        // Create the selected avatar frame
        _selectedAvatarBorder = [CCSprite spriteWithFile:@"SelectedPortrait.png"];
        _selectedAvatarBorder.visible = false;
        [self addChild:_selectedAvatarBorder];
        
        // Create the password textbox
        self.passwordTextBox = [[UITextField alloc] initWithFrame:CGRectMake(size.width/2-100, size.height/2-25, 200, 50)];
        self.passwordTextBox.backgroundColor = [UIColor whiteColor];
        self.passwordTextBox.delegate = self;
        self.passwordTextBox.adjustsFontSizeToFitWidth = true;
        
        // Grey text inside the box
        NSAttributedString *userName = [[NSAttributedString alloc] initWithString:@"Password"];
        self.passwordTextBox.attributedPlaceholder = userName;
        
        self.passwordTextBox.enabled = false;
        
        // No spellchecker and make the input text display as ****
        self.passwordTextBox.spellCheckingType = UITextSpellCheckingTypeNo;
        self.passwordTextBox.secureTextEntry = true;
        [userName release];
        [[CCDirector sharedDirector].view addSubview:self.passwordTextBox];

        
        // Add Submit Button
        _submitButton = [[SubmitButton alloc] initWithPosition:ccp(size.width/2, size.height/2-100)];
        [_submitButton setState:false];
        //[self.submitButton release];
        [self addChild:_submitButton];
        
    }
    return self;
}

// Handles the events that happen when the release occurs at a specific location
- (void)tapReleaseAt:(CGPoint)releaseLocation {
    
    // Checks if one of the accounts has been selected
    for (Account *account in self.accounts) {
        if (CGRectContainsPoint(account.avatar.boundingBox, releaseLocation)) {
            self.selectedAccount = account;
            
            // Make the avatar box visible since we now have a selected account
            if (!_selectedAvatarBorder.visible)
                _selectedAvatarBorder.visible = true;
            
            _selectedAvatarBorder.position = ccp(self.selectedAccount.avatar.position.x, self.selectedAccount.avatar.position.y);
            self.passwordTextBox.enabled = true;
            break;
        }
    }
    
    // Occurs when the user presses the submit button
    if (self.selectedAccount && _submitButton.state && CGRectContainsPoint(_submitButton.boundingBox, releaseLocation)) {
        
        // The password was correct transition to the menu layer
        if ([self.selectedAccount.password isEqualToString:self.passwordTextBox.text]) {
            
            // Password TextBox transition. TO-DO: make it smooth to match the layer transition
            [self.passwordTextBox removeFromSuperview];
            
            // We now have a logged in account pass it onto the Singleton class
            [[Singleton sharedSingleton] setLoggedInAccount:self.selectedAccount];
            
            // Avatar object must be removed from the selected account since we are sharing this perticular account between layers and
            // CCSprite can only be attached to one layer. We are not removing the child from the layer because it makes the sprite dissapear
            // before the transition ends. This also assures that each sprite is assign to one layer.
            [self.selectedAccount removeAvatar];
            
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MenuLayer scene]]];
            
            // Cleanup after the transition
            [self.parent removeChild:self cleanup:YES];
        }
        // Password was incorrect display an error message
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid Password, try again!"
                                  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
    }
}

// Event that is called when the touch has ended
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint releaseLocation = [touch locationInView:[touch view]];
    releaseLocation = [[CCDirector sharedDirector] convertToGL:releaseLocation];
    [self tapReleaseAt:releaseLocation];
}

// Event that is called when the touch begins
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    return YES;
}

// Occurs when return is pressed on the keyboard
- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    //Terminate editing
    [textField resignFirstResponder];
    return YES;
}

// Occurs when the editin is ended on the text field
- (void)textFieldDidEndEditing:(UITextField*)textField {
    // If the input text is empty then disable the submit button
    if ([self.passwordTextBox.text isEqualToString:@""])
        _submitButton.state = false;
    else
        _submitButton.state = true;
}

// on "dealloc" you need to release all your retained objects
- (void)dealloc
{
    for (Account* account in self.accounts)
        [account release];
    
    [self.accounts release];
    [self.avatarNames release];
    [_submitButton release];
	[super dealloc];
}

#pragma mark LoginLayer delegate

@end
