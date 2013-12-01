//
//  EditAccountLayer.m
//  Sound Out Phonics
//
//  Created by Oleg M on 2013-11-28.
//  Copyright (c) 2013 Team Redundant Team. All rights reserved.
//

#import "EditAccountLayer.h"
#import "cocos2d.h"
#import "StateButton.h"

@implementation EditAccountLayer
@synthesize nameTextBox = _nameTextBox;
@synthesize passwordTextBox = _passwordTextBox;
@synthesize confirmPasswordTextBox = _confirmPasswordTextBox;

// on "init" you need to initialize your instance
- (id)initWithColor:(ccColor4B)color withAccount:(Account *)account {
	if((self = [super initWithColor:color])) {
        
        // enable touch for this layer
        [self setTouchEnabled:YES];
        
        // get the screen size of the device
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        self.account = account;
        
        // create and initialize a background
        CCSprite *background = [CCSprite spriteWithFile:@"Default-Background.png"];
        background.scale = 0.75;
        background.position = ccp(size.width/2, size.height/2);
        [self addChild:background];
        
        // create header text
        NSMutableString *name = [NSMutableString stringWithFormat:@"Editing: %@", account.name ];
        _layerName = [CCLabelTTF labelWithString:name fontName:@"KBPlanetEarth" fontSize:48];
        _layerName.position = ccp(size.width/2, size.height-150);
        [self addChild:_layerName];
        
        //
        // create the name textbox
        //
        self.nameTextBox = [[UITextField alloc] initWithFrame:CGRectMake(size.width/2-100, size.height/2-175, 200, 50)];
        self.nameTextBox.backgroundColor = [UIColor whiteColor];
        self.nameTextBox.delegate = self;
        self.nameTextBox.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.nameTextBox.adjustsFontSizeToFitWidth = true;
        
        // grey text inside the box
        NSAttributedString *nameText = [[NSAttributedString alloc] initWithString:@"Name"];
        self.nameTextBox.attributedPlaceholder = nameText;
        [nameText release];
        
        // Display the current account
        self.nameTextBox.text = self.account.name;
        
        // disable spellchecker
        self.nameTextBox.spellCheckingType = UITextSpellCheckingTypeNo;
        
        [[CCDirector sharedDirector].view addSubview:self.nameTextBox];
        
        //
        // create the password textbox
        //
        self.passwordTextBox = [[UITextField alloc] initWithFrame:CGRectMake(size.width/2-100, size.height/2-100, 200, 50)];
        self.passwordTextBox.backgroundColor = [UIColor whiteColor];
        self.passwordTextBox.delegate = self;
        self.passwordTextBox.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.passwordTextBox.adjustsFontSizeToFitWidth = true;
        
        // grey text inside the box
        NSAttributedString *passwordName = [[NSAttributedString alloc] initWithString:@"Password"];
        self.passwordTextBox.attributedPlaceholder = passwordName;
        [passwordName release];
        
        // Display the current password
        self.passwordTextBox.text = self.account.password;
        
        // no spellchecker and make the input text display as ****
        self.passwordTextBox.spellCheckingType = UITextSpellCheckingTypeNo;
        self.passwordTextBox.secureTextEntry = true;

        [[CCDirector sharedDirector].view addSubview:self.passwordTextBox];
        
        //
        // create the confirm password textbox
        //
        self.confirmPasswordTextBox = [[UITextField alloc] initWithFrame:CGRectMake(size.width/2-100, size.height/2-25, 200, 50)];
        self.confirmPasswordTextBox.backgroundColor = [UIColor whiteColor];
        self.confirmPasswordTextBox.delegate = self;
        self.confirmPasswordTextBox.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.confirmPasswordTextBox.adjustsFontSizeToFitWidth = true;
        
        // grey text inside the box
        NSAttributedString *confirmPasswordName = [[NSAttributedString alloc] initWithString:@"Confirm Password"];
        self.confirmPasswordTextBox.attributedPlaceholder = confirmPasswordName;
        [confirmPasswordName release];
        
        // Display the current password
        self.confirmPasswordTextBox.text = self.account.password;
        
        // no spellchecker and make the input text display as ****
        self.confirmPasswordTextBox.spellCheckingType = UITextSpellCheckingTypeNo;
        self.confirmPasswordTextBox.secureTextEntry = true;

        [[CCDirector sharedDirector].view addSubview:self.confirmPasswordTextBox];
        
        // Add Update Account Button
        _updateAccountButton = [[StateText alloc] initWithString:@"Update" fontName:@"KBPlanetEarth" fontSize:48
                                                  position:ccp(size.width/2, size.height/2 - 125)];
        [self addChild:_updateAccountButton];
        
        // error message which used to display any errors that might of occured
        _errorMessage = [CCLabelTTF labelWithString:@"" fontName:@"KBPlanetEarth" fontSize:24];
        _errorMessage.position = ccp(size.width/2, size.height/2 + 195);
        ccColor3B c = {255, 0, 0}; // red color
        _errorMessage.color = c;
        _errorMessage.visible = false;
        [self addChild:_errorMessage];
        
        _exitButton = [CCSprite spriteWithFile:@"Exit-Button.png"];
        _exitButton.position = ccp(size.width/2 + 375, size.height/2 + 290);
        [self addChild:_exitButton];
    }
    return self;
}

// dispatcher to catch the touch events
- (void)registerWithTouchDispatcher {
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

// occurs when return is pressed on the keyboard
- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    // terminate editing
    [textField resignFirstResponder];
    return YES;
}

// occurs when the editin is ended on the text field
- (void)textFieldDidEndEditing:(UITextField*)textField {
    // If the input text is empty then disable the submit button
    if ([self validateTextBoxes])
        _updateAccountButton.state = true;
    else
        _updateAccountButton.state = false;
}

// Handles the events that happen when the release occurs at a specific location
- (void)tapReleaseAt:(CGPoint)releaseLocation {
    
    // Occurs when the user presses the update account button
    if (_updateAccountButton.state && CGRectContainsPoint(_updateAccountButton.boundingBox, releaseLocation)) {
        
        if ([[SOPDatabase database] updateAccount:self.account.accountId withName:self.nameTextBox.text withPassword:self.passwordTextBox.text]) {
            
            // Update the account with the new information
            self.account.name = self.nameTextBox.text;
            self.account.password = self.passwordTextBox.text;
            
            // Update the loggedInAccount in-case it was logged in
            Account * loggedInAccount = [Singleton sharedSingleton].loggedInAccount;
            if (loggedInAccount.accountId == self.account.accountId) {
                loggedInAccount.name = self.nameTextBox.text;
                loggedInAccount.name = self.passwordTextBox.text;
            }
            
            // Update the layer title
            NSMutableString *name = [NSMutableString stringWithFormat:@"Editing: %@", self.account.name];
            _layerName.string = name;
            
            // Send an alert indicating that the update was successful
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Account has been updated"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
        else {
            // Send an alert indicating that the update didn't go throug
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not update the account at this time!"
                                                           delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
    }
    if (CGRectContainsPoint(_exitButton.boundingBox, releaseLocation)) {
        
        // remove all the text boxes
        [self.nameTextBox removeFromSuperview];
        [self.passwordTextBox removeFromSuperview];
        [self.confirmPasswordTextBox removeFromSuperview];
        
        [self.parent scheduleOnce:@selector(updateAccountsSprites) delay:0];
        [self.parent removeChild:self cleanup:YES];
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

// Check if the input in the text boxes is valid
- (BOOL) validateTextBoxes {
    _errorMessage.visible = false;
    
    int validTextBoxes = 0;
    // make sure that the name input box has a value in there
    if (![self.nameTextBox.text isEqualToString:@""] && self.nameTextBox.text != nil) {
        validTextBoxes++;
    }
    
    // make sure that the password input box has a value in there
    if (![self.passwordTextBox.text isEqualToString:@""] && self.passwordTextBox.text != nil)
        validTextBoxes++;
    
    // make sure that the confirm password input box has a value in there
    if (![self.confirmPasswordTextBox.text isEqualToString:@""] && self.confirmPasswordTextBox.text != nil) {
        // check that both password box and confirm box are equal
        if ([self.confirmPasswordTextBox.text isEqualToString:self.passwordTextBox.text]) {
            validTextBoxes++;
            _errorMessage.visible = false;
        }
        else {
            [_errorMessage setString:@"Error passwords do not match!"];
            _errorMessage.visible = true;
        }
    }
    
    // If all 3 textboxes are valid then validation was successful
    if (validTextBoxes == 3)
        return true;
    else
        return false;
}

- (void)dealloc {
    [self.account release];
    [_updateAccountButton release];
    [super dealloc];
}

#pragma mark CreateAccountLayer delegate
@end
