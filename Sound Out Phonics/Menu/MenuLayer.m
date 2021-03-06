//
//  MenuLayer.m
//  Sound Out Phonics
//
//  Purpose: Menu layer and scene that has verious menu items based on the user type.
//
//  History: History of the file can be found here: https://github.com/TeamRedundantTeam/SoundOutPhonics/commits/master/Sound%20Out%20Phonics/Menu/MenuLayer.m
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
//  Created on 2013-10-24.
//  Copyright (c) 2013 Team Redundant Team. All rights reserved.
//

// Import the interfaces
#import "MenuLayer.h"

#pragma mark - MenuLayer

// menu implementation
@implementation MenuLayer

// helper class method that creates a scene with the MenuLayer as the only child.
+ (CCScene *)scene {
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MenuLayer *layer = [MenuLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// Initialize the instance
- (id)init {
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if((self = [super init])) {
        
		_size = [[CCDirector sharedDirector] winSize]; // ask the director for the window size
        [self setTouchEnabled:YES];
        
        CCSprite *background = [CCSprite spriteWithFile:@"Background-Menu.png"];            // create and initialize the background sprite (png)
        background.position = ccp(_size.width/2, _size.height/2);                             // center background layer
        [self addChild: background];
        
        // Create the help Icon
        CCSprite *helpIcon = [CCSprite spriteWithFile:@"Help-Icon.png"];
        helpIcon.position = ccp(_size.width - 125, 50);
        [self addChild:helpIcon];
        
        // Create the help Icon
        _helpButton = [CCLabelTTF labelWithString:@"help" fontName:@"KBPlanetEarth" fontSize:24];
        _helpButton.position = ccp(_size.width - 75, 50);
        [self addChild:_helpButton];
        
        // Create the credits Icon
        CCSprite *creditsIcon = [CCSprite spriteWithFile:@"Credits-Icon.png"];
        creditsIcon.position = ccp(_size.width/2 - 75, 50);
        [self addChild:creditsIcon];
        
        // Create the credits button
        _creditsButton = [CCLabelTTF labelWithString:@"credits" fontName:@"KBPlanetEarth" fontSize:24];
        _creditsButton.position = ccp(_size.width/2, 50);
        [self addChild:_creditsButton];
        
        // Reference to the logged in account
        Account *loggedInAccount = [Singleton sharedSingleton].loggedInAccount;
        
        // Create the avatar
        [loggedInAccount createAvatar];
        loggedInAccount.avatar.scale = 0.5;
        loggedInAccount.avatar.position = ccp(_size.width/2, _size.height/2+175);
        [self addChild:loggedInAccount.avatar];
        
        // Create Name
        CCLabelTTF *portaitName = [CCLabelTTF labelWithString:loggedInAccount.name fontName:@"KBPlanetEarth" fontSize:24];
        portaitName.position = ccp(_size.width/2, _size.height-275);
        [self addChild:portaitName];
        

        // Determine which menu to initialize based on the account type
        if (loggedInAccount.type == 1) {
            // Create Admin Menu Items
            [self initAdminMenu];
        }
        else if (loggedInAccount.type == 0) {
            // Create Student Menu Items
            [self initStudentMenu];
        }
        else {
            // Create Guest Menu Items
            [self initGuestMenu];
        }
	}
	return self;
}

- (void)initAdminMenu {
    
    // Add the account type
    CCLabelTTF *accountType = [CCLabelTTF labelWithString:@"Teacher" fontName:@"KBPlanetEarth" fontSize:24];
    accountType.position = ccp(_size.width/2, _size.height/2+229);
    [self addChild:accountType];
    
    [CCMenuItemFont setFontName:@"KBPlanetEarth"]; // set the default CCMenuItemFont to our custom font, KBPlanetEarth
    [CCMenuItemFont setFontSize:50]; // set the default CCMenuItemFont size
    
    CCMenuItem *itemPlay = [CCMenuItemFont itemWithString:@"play" target:self selector:@selector(play)];
    CCMenuItem *itemStatistic = [CCMenuItemFont itemWithString:@"statistics" target:self selector:@selector(statistics)];
    CCMenuItem *itemManageAccount = [CCMenuItemFont itemWithString:@"accounts" target:self selector:@selector(accounts)];
    CCMenuItem *itemLogout = [CCMenuItemFont itemWithString:@"quit" target:self selector:@selector(quit)];
    
    // Align all items left
    itemPlay.anchorPoint = ccp(0, 0.5f);
    itemStatistic.anchorPoint = ccp(0, 0.5f);
    itemManageAccount.anchorPoint = ccp(0, 0.5f);
    itemLogout.anchorPoint = ccp(0, 0.5f);

    // Add all the items to the menu
    _menu = [CCMenu menuWithItems:itemPlay, itemStatistic,itemManageAccount, itemLogout, nil];
    _menu.position = ccp(_size.width/2 - 50, _size.height/2 - 50);
    
    // Align all items vertically
    [_menu alignItemsVertically];

    [self addChild:_menu];
    
    // Add the icons
    CCSprite *playIcon = [CCSprite spriteWithFile:@"Game-Icon.png"];               // create and initialize the playIcon sprite (png)
    CCSprite *statisticIcon = [CCSprite spriteWithFile:@"Statistic-Icon.png"];     // create and initialize the statisticIcon sprite (png)
    CCSprite *accountIcon = [CCSprite spriteWithFile:@"Manage-Icon.png"];          // create and initialize the accountIcon sprite (png)
    CCSprite *logoutIcon = [CCSprite spriteWithFile:@"Cancel-Icon.png"];           // create and initialize the logoutIcon sprite (png)

    
    playIcon.position = ccp(_size.width/2 - 88, _size.height/2 + 45);              // set playIcon screen position
    statisticIcon.position = ccp(_size.width/2 - 89, _size.height/2 - 15);         // set statisticIcon screen position
    accountIcon.position = ccp(_size.width/2 - 89, _size.height/2 - 75);           // set accountIcon screen position
    logoutIcon.position = ccp(_size.width/2 - 88, _size.height/2 - 140);           // set logoutIcon screen position
    
    [self addChild: playIcon];                                                     // add the playIcon to the scene
    [self addChild: statisticIcon];                                                // add the statisticIcon to the scene
    [self addChild: accountIcon];                                                  // add the accountIcon to the scene
    [self addChild: logoutIcon];                                                   // add the logoutIcon to the scene
    
}

- (void)initStudentMenu {
    
    // Add the account type
    CCLabelTTF *accountType = [CCLabelTTF labelWithString:@"Student" fontName:@"KBPlanetEarth" fontSize:24];
    accountType.position = ccp(_size.width/2, _size.height/2+229);
    [self addChild:accountType];
    
    [CCMenuItemFont setFontName:@"KBPlanetEarth"];                                 // set the default CCMenuItemFont to our custom font, KBPlanetEarth
    [CCMenuItemFont setFontSize:50];                                               // set the default CCMenuItemFont size
    
    CCMenuItem *itemPlay = [CCMenuItemFont itemWithString:@"play" target:self selector:@selector(play)];
    CCMenuItem *itemStatistic = [CCMenuItemFont itemWithString:@"statistics" target:self selector:@selector(statistics)];
    CCMenuItem *itemLogout = [CCMenuItemFont itemWithString:@"quit" target:self selector:@selector(quit)];
    
    // Align all items left
    itemPlay.anchorPoint = ccp(0, 0.5f);
    itemStatistic.anchorPoint = ccp(0, 0.5f);
    itemLogout.anchorPoint = ccp(0, 0.5f);
    
    // Add all the items to the menu
    _menu = [CCMenu menuWithItems:itemPlay, itemStatistic, itemLogout, nil];
    _menu.position = ccp(_size.width/2 - 50, _size.height/2 - 25);
    
    // Align all items vertically
    [_menu alignItemsVertically];
    
    [self addChild:_menu];
    
    // Add the icons
    CCSprite *playIcon = [CCSprite spriteWithFile:@"Game-Icon.png"];               // create and initialize the playIcon sprite (png)
    CCSprite *statisticIcon = [CCSprite spriteWithFile:@"Statistic-Icon.png"];     // create and initialize the statisticIcon sprite (png)
    CCSprite *logoutIcon = [CCSprite spriteWithFile:@"Cancel-Icon.png"];           // create and initialize the logoutIcon sprite (png)
    
    playIcon.position = ccp(_size.width/2 - 88, _size.height/2 + 40);              // set playIcon screen position
    statisticIcon.position = ccp(_size.width/2 - 89, _size.height/2 - 20);         // set statisticIcon screen position
    logoutIcon.position = ccp(_size.width/2 - 88, _size.height/2 - 87);            // set logoutIcon screen position
    
    [self addChild: playIcon];                                                     // add the playIcon to the scene
    [self addChild: statisticIcon];                                                // add the statisticIcon to the scene
    [self addChild: logoutIcon];                                                   // add the logoutIcon to the scene
}

- (void)initGuestMenu {
    
    [CCMenuItemFont setFontName:@"KBPlanetEarth"]; // set the default CCMenuItemFont to our custom font, KBPlanetEarth
    [CCMenuItemFont setFontSize:50]; // set the default CCMenuItemFont size
    
    CCMenuItem *itemPlay = [CCMenuItemFont itemWithString:@"play" target:self selector:@selector(play)];
    CCMenuItem *itemLogout = [CCMenuItemFont itemWithString:@"quit" target:self selector:@selector(quit)];
    
    // Align all items left
    itemPlay.anchorPoint = ccp(0, 0.5f);
    itemLogout.anchorPoint = ccp(0, 0.5f);
    
    // Add all the items to the menu
    _menu = [CCMenu menuWithItems:itemPlay, itemLogout, nil];
    _menu.position = ccp(_size.width/2 - 50, _size.height/2);
    
    // Align all items vertically
    [_menu alignItemsVertically];
    
    [self addChild:_menu];
    
    // Add the icons
    CCSprite *playIcon = [CCSprite spriteWithFile:@"Game-Icon.png"];               // create and initialize the playIcon sprite (png)
    CCSprite *logoutIcon = [CCSprite spriteWithFile:@"Cancel-Icon.png"];           // create and initialize the logoutIcon sprite (png)
    
    playIcon.position = ccp(_size.width/2 - 88, _size.height/2 + 40);                       // set playIcon screen position
    logoutIcon.position = ccp(_size.width/2 - 88, _size.height/2 - 25);                    // set logoutIcon screen position
    
    [self addChild: playIcon];                                                          // add the playIcon to the scene
    [self addChild: logoutIcon];

}

- (void)play {
    
    // Cleanup the layer
    [self.parent removeChild:self cleanup:YES];
    
    // Transition to the level select screen
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[LevelSelectLayer scene]]];
}

- (void)statistics {
    
    // Cleanup the layer
    [self.parent removeChild:self cleanup:YES];
    
    // Transition to the statistics screen
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[StatisticLayer scene]]];
}

- (void)accounts {
    
    // Cleanup the layer
    [self.parent removeChild:self cleanup:YES];
    
    // Transition to the manage account screen
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[ManageAccountLayer scene]]];
}

- (void)quit {
    
    // Cleanup the layer
    [self.parent removeChild:self cleanup:YES];
    
    // Transition to the log-in screen
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[LoginLayer scene]]];
}

// dispatcher to catch the touch events
- (void)registerWithTouchDispatcher {
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

// Handles the events that happen when the release occurs at a specific location
- (void)tapReleaseAt:(CGPoint)releaseLocation {
    if (CGRectContainsPoint(_helpButton.boundingBox, releaseLocation)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://teamredundant.com/tutorial/"]];
    }
    
    if (CGRectContainsPoint(_creditsButton.boundingBox, releaseLocation)) {
        // Disable touch for the menu
        _menu.touchEnabled = false;
        ccColor4B color = {100,100,0,100};
        CreditLayer *layer = [[[CreditLayer alloc] initWithColor:color] autorelease];
        [self addChild:layer];
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

// Enables touch on the CCMenu
- (void)menuEnableTouch {
    _menu.touchEnabled = true;
}

// on "dealloc" you need to release all your retained objects
- (void)dealloc {
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark GameKit delegate

@end
