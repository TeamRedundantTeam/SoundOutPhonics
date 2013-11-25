//
//  CreateAccountLayer.m
//  Sound Out Phonics
//
//  Purpose: Create account layer that allows to create an account based on the user inputs
//
//  History: History of the file can be found here: https://github.com/TeamRedundantTeam/SoundOutPhonics/commits/master/Sound%20Out%20Phonics/Menu/CreateAccountLevel.m
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

#import "CreateAccountLayer.h"

#pragma mark - CreateAccountLayer

@implementation CreateAccountLayer
@synthesize nameTextBox = _nameTextBox;
@synthesize passwordTextBox = _passwordTextBox;
@synthesize confirmPasswordTextBox = _confirmPasswordTextBox;

// Returns a CCScene that contains the CreateAccountLayer as the only child and takes paramater accountLevel that determines what account level
// will the new create account have
+ (CCScene *)sceneWithAccountLevel:(int)accountLevel {
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	CreateAccountLayer *layer = [CreateAccountLayer nodeWithParamaters:accountLevel];
	
	// add layer as a child to scene
	[scene addChild:layer];
	
	// return the scene
	return scene;
}

// creates the node of the level with the paramaters and then calles initWithParamaters to initialize the layer
+ (id)nodeWithParamaters:(int)accountLevel {
    return [[[self alloc] initWithAccountLevel:accountLevel] autorelease];
}


// on "init" you need to initialize your instance
- (id)initWithAccountLevel:(int)accountLevel {
	if((self = [super init])) {
        
        // store the account level into the class
        _accountLevel = accountLevel;
        
        // enable touch for this layer
        [self setTouchEnabled:YES];
        
        // get the screen size of the device
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        // create and initialize a background
        CCSprite *background = [CCSprite spriteWithFile:@"Default-Background.png"];
        background.position = ccp(size.width/2, size.height/2);
        [self addChild:background];
        
        // create header text
        CCLabelTTF *layerName;
        if (accountLevel == 1)
            layerName = [CCLabelTTF labelWithString:@"Create Admin Account" fontName:@"KBPlanetEarth" fontSize:48];
        else
            layerName = [CCLabelTTF labelWithString:@"Create Player Account" fontName:@"KBPlanetEarth" fontSize:48];
        layerName.position = ccp(size.width/2, size.height-75);
        [self addChild:layerName];
        
        //
        // create the name textbox
        //
        self.nameTextBox = [[UITextField alloc] initWithFrame:CGRectMake(size.width/2-100, size.height/2-200, 200, 50)];
        self.nameTextBox.backgroundColor = [UIColor whiteColor];
        self.nameTextBox.delegate = self;
        self.nameTextBox.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.nameTextBox.adjustsFontSizeToFitWidth = true;
        
        // grey text inside the box
        NSAttributedString *nameText = [[NSAttributedString alloc] initWithString:@"Name"];
        self.nameTextBox.attributedPlaceholder = nameText;
    
        // disable spellchecker
        self.nameTextBox.spellCheckingType = UITextSpellCheckingTypeNo;
        
        [nameText release];
        [[CCDirector sharedDirector].view addSubview:self.nameTextBox];
        
        //
        // create the password textbox
        //
        self.passwordTextBox = [[UITextField alloc] initWithFrame:CGRectMake(size.width/2-100, size.height/2-125, 200, 50)];
        self.passwordTextBox.backgroundColor = [UIColor whiteColor];
        self.passwordTextBox.delegate = self;
        self.passwordTextBox.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.passwordTextBox.adjustsFontSizeToFitWidth = true;
        
        // grey text inside the box
        NSAttributedString *passwordName = [[NSAttributedString alloc] initWithString:@"Password"];
        self.passwordTextBox.attributedPlaceholder = passwordName;
        
        // no spellchecker and make the input text display as ****
        self.passwordTextBox.spellCheckingType = UITextSpellCheckingTypeNo;
        self.passwordTextBox.secureTextEntry = true;
        [passwordName release];
        [[CCDirector sharedDirector].view addSubview:self.passwordTextBox];
        
        //
        // create the confirm password textbox
        //
        self.confirmPasswordTextBox = [[UITextField alloc] initWithFrame:CGRectMake(size.width/2-100, size.height/2-50, 200, 50)];
        self.confirmPasswordTextBox.backgroundColor = [UIColor whiteColor];
        self.confirmPasswordTextBox.delegate = self;
        self.confirmPasswordTextBox.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.confirmPasswordTextBox.adjustsFontSizeToFitWidth = true;

        // grey text inside the box
        NSAttributedString *confirmPasswordName = [[NSAttributedString alloc] initWithString:@"Confirm Password"];
        self.confirmPasswordTextBox.attributedPlaceholder = confirmPasswordName;
        
        // no spellchecker and make the input text display as ****
        self.confirmPasswordTextBox.spellCheckingType = UITextSpellCheckingTypeNo;
        self.confirmPasswordTextBox.secureTextEntry = true;
        [confirmPasswordName release];
        [[CCDirector sharedDirector].view addSubview:self.confirmPasswordTextBox];
        
        // add create account button. TO-DO add the sprite for this button
        _createAccountButton = [[StateButton alloc] initWithFile:@"Login-Button.png" withPosition:ccp(size.width/2, size.height/2-125)];
        [_createAccountButton setState:false];
        [self addChild:_createAccountButton];
        
        // add the back text which will make the user go back to the menu when pressed
        [CCMenuItemFont setFontName:@"KBPlanetEarth"]; // set the default CCMenuItemFont to our custom font, KBPlanetEarth
        [CCMenuItemFont setFontSize:48]; // set the default CCMenuItemFont size
        
        CCMenuItem *itemBack = [CCMenuItemFont itemWithString:@"back" block:^(id sender) {
            
            // remove all the text boxes
            [self.nameTextBox removeFromSuperview];
            [self.passwordTextBox removeFromSuperview];
            [self.confirmPasswordTextBox removeFromSuperview];
            
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade
                                                       transitionWithDuration:1.0
                                                       scene:[MenuLayer scene]]];
        }];
        
        CCMenu *menu = [CCMenu menuWithItems:itemBack, nil];
		[menu setPosition:ccp(size.width - 100, size.height - size.height + 40)];
        [self addChild:menu];
        
        // error message which used to display any errors that might of occured
        _errorMessage = [CCLabelTTF labelWithString:@"" fontName:@"KBPlanetEarth" fontSize:24];
        _errorMessage.position = ccp(size.width/2, size.height/2 + 225);
        ccColor3B c = {255, 0, 0}; // red color
        _errorMessage.color = c;
        _errorMessage.visible = false;
        [self addChild:_errorMessage];
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
    // if the input text is empty then disable the submit button
    if ([self validateTextBoxes])
        _createAccountButton.state = true;
    else
        _createAccountButton.state = false;
}

// handles the events that happen when the release occurs at a specific location
- (void)tapReleaseAt:(CGPoint)releaseLocation {
    
    // occurs when the user presses the createe account button
    if (_createAccountButton.state && CGRectContainsPoint(_createAccountButton.boundingBox, releaseLocation)) {
        
        int accountId = [[SOPDatabase database] getLastAccountId] + 1;
        if ([[SOPDatabase database] createAccount:accountId withName:self.nameTextBox.text withPassword:self.passwordTextBox.text withLevel:_accountLevel]) {
            Account *account = [[Account alloc] initWithId:accountId withName:self.nameTextBox.text withPassword:self.passwordTextBox.text withType:_accountLevel withImage:@"" withStatistics:nil];
            
            // we now have a logged in account pass it onto the Singleton class
            [[Singleton sharedSingleton] setLoggedInAccount:account];
            
            // remove all the text boxes. TO-DO make transition more smooth
            [self.nameTextBox removeFromSuperview];
            [self.passwordTextBox removeFromSuperview];
            [self.confirmPasswordTextBox removeFromSuperview];
            
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MenuLayer scene]]];
            
            // cleanup after the transition
            [self.parent removeChild:self cleanup:YES];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not create the account at this time!"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
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
    [_createAccountButton release];
    [super dealloc];
}

#pragma mark CreateAccountLayer delegate
@end
