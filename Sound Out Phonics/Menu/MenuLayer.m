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
		CGSize size = [[CCDirector sharedDirector] winSize]; // ask the director for the window size
        
        CCSprite *background = [CCSprite spriteWithFile:@"Background-No-Gradient.png"];     // create and initialize the background sprite (png)
        background.position = ccp(size.width/2, size.height/2);                             // center background layer
        [self addChild: background];
        
        CCSprite *playIcon = [CCSprite spriteWithFile:@"Game-IconFinal.png"];               // create and initialize the playIcon sprite (png)
        CCSprite *statisticIcon = [CCSprite spriteWithFile:@"Statistic-IconFinal.png"];     // create and initialize the statisticIcon sprite (png)
        CCSprite *logoutIcon = [CCSprite spriteWithFile:@"Cancel-IconFinal.png"];           // create and initialize the logoutIcon sprite (png)
        CCSprite *manageIcon = [CCSprite spriteWithFile:@"Manage-IconFinal.png"];           // create and initialize the manageIcon sprite (png)
        
        playIcon.position = ccp((size.width/2)-88, size.height/2+52);                       // set playIcon screen position
        statisticIcon.position = ccp((size.width/2)-89, size.height/2-23);                  // set statisticIcon screen position
        logoutIcon.position = ccp((size.width/2)-88, size.height/2-100);                    // set logoutIcon screen position
        manageIcon.position = ccp((size.width/2)-89, size.height/2-175);                    // set manageIcon screen position

        [self addChild: playIcon];                                                          // add the playIcon to the scene
        [self addChild: statisticIcon];                                                     // add the statisticIcon to the scene
        [self addChild: logoutIcon];                                                        // add the logoutIcon to the scene
        
        // add the avatar to the menu
        Account *loggedInAccount = [Singleton sharedSingleton].loggedInAccount;
        if (loggedInAccount != nil) {
            
            // display what type of account it is.
            CCLabelTTF *accountType;
            
            // determine which string should be displayed based on the account type
            if (loggedInAccount.type == 1){
                accountType = [CCLabelTTF labelWithString:@"Teacher" fontName:@"KBPlanetEarth" fontSize:24];
            }
            else {
                accountType = [CCLabelTTF labelWithString:@"Student" fontName:@"KBPlanetEarth" fontSize:24];
            }
            
            accountType.position = ccp(size.width/2, size.height/2+225);
            
            [self addChild:accountType];
            
            // create the avatar
            [loggedInAccount createAvatar];
            loggedInAccount.avatar.scale = 0.5;
            loggedInAccount.avatar.position = ccp(size.width/2, size.height/2+175);
            
            // create Name
            CCLabelTTF *portaitName = [CCLabelTTF labelWithString:loggedInAccount.name fontName:@"KBPlanetEarth" fontSize:24];
            portaitName.position = ccp(size.width/2, size.height-275);
            [self addChild:portaitName];
            
            [self addChild:loggedInAccount.avatar];
        }
        
        // create Menu
        [CCMenuItemFont setFontName:@"KBPlanetEarth"]; // set the default CCMenuItemFont to our custom font, KBPlanetEarth
        [CCMenuItemFont setFontSize:50]; // set the default CCMenuItemFont size
        
        CCMenuItem *itemPlay = [CCMenuItemFont itemWithString:@"play." block:^(id sender) {

            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade
                                                       transitionWithDuration:1.0
                                                       scene:[LevelSelectLayer scene]]];
            
        }]; // add the 'play' CCMenuItem
        
        CCMenuItem *itemStatistic = [CCMenuItemFont itemWithString:@"statistics." block:^(id sender) {
            
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade
                                                       transitionWithDuration:1.0
                                                       scene:[StatisticLayer scene]]];
        }]; // add the 'statistics' CCMenuItem
        
        CCMenuItem *itemManageAccount = [CCMenuItemFont itemWithString:@"manage accounts." block:^(id sender) {
                [[CCDirector sharedDirector] replaceScene:[CCTransitionFade
                                                       transitionWithDuration:1.0
                                                       scene:[CreateAccountLayer sceneWithAccountLevel:0]]];
        }]; // add the 'create account' CCMenuItem
        
        CCMenuItem *itemLogout = [CCMenuItemFont itemWithString:@"quit." block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade
                                                       transitionWithDuration:1.0
                                                       scene:[LoginLayer scene]]];
        }]; // add the 'quit' CCMenuItem
        
        CCMenu *menu;
        // admin menu has different options from the student menus
        if (loggedInAccount.type == 1) {
            menu = [CCMenu menuWithItems:itemPlay, itemStatistic, itemManageAccount, itemLogout, nil];
            [self addChild: manageIcon];
        }
        else {
            menu = [CCMenu menuWithItems:itemPlay, itemStatistic, itemLogout, nil];
        }
        
        itemPlay.position = ccp(size.width/2-500, size.height/2-335);
        itemStatistic.position = ccp(size.width/2-450, size.height/2-413);
        itemLogout.position = ccp(size.width/2-507, size.height/2-485);
        itemManageAccount.position = ccp(size.width/2-357, size.height/2-560);
		
		// add the menu to the layer
		[self addChild:menu];
	}
	return self;
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
