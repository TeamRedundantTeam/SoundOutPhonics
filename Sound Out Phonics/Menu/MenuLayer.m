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

// Menu implementation
@implementation MenuLayer

// Helper class method that creates a Scene with the MenuLayer as the only child.
+ (CCScene *)scene
{
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
- (id)init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if((self = [super init])) {
		CGSize size = [[CCDirector sharedDirector] winSize]; // ask the director for the window size
        
        CCSprite *background = [CCSprite spriteWithFile:@"background_no_gradient.png"]; // create and initialize the background sprite (png)
        CCSprite *playIcon = [CCSprite spriteWithFile:@"play_icon.png"]; // create and initialize the playIcon sprite (png)
        CCSprite *statisticIcon = [CCSprite spriteWithFile:@"trophy_icon.png"]; // create and initialize the statistic sprite (png)
        CCSprite *logoutIcon = [CCSprite spriteWithFile:@"logout_icon.png"]; // create and initialize the logoutIcon sprite (png)
        
        background.position = ccp(size.width/2, size.height/2); // center background layer
        playIcon.position = ccp((size.width/2)-75, size.height/2+50); // set playIcon screen position
        statisticIcon.position = ccp((size.width/2)-135, size.height/2-20); // set playIcon screen position
        logoutIcon.position = ccp((size.width/2)-75, size.height/2-100); // set logoutIcon screen position

        [self addChild: background]; // add the background to the scene
        [self addChild: playIcon]; // add the playIcon to the scene
        [self addChild: statisticIcon]; // add the playIcon to the scene
        [self addChild: logoutIcon]; // add the logoutIcon to the scene
        
        [CCMenuItemFont setFontName:@"KBPlanetEarth"]; // set the default CCMenuItemFont to our custom font, KBPlanetEarth
        [CCMenuItemFont setFontSize:50]; // set the default CCMenuItemFont size
        
        CCMenuItem *itemPlay = [CCMenuItemFont itemWithString:@"play." block:^(id sender) {

            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade
                                                       transitionWithDuration:1.0
                                                       scene:[LevelLayer scene]]];
        }];
        
        CCMenuItem *itemStatistic = [CCMenuItemFont itemWithString:@"statistics." block:^(id sender) {
            
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade
                                                       transitionWithDuration:1.0
                                                       scene:[StatisticLayer scene]]];
        }];
        
        CCMenuItem *itemLogout = [CCMenuItemFont itemWithString:@"quit." block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade
                                                       transitionWithDuration:1.0
                                                       scene:[LoginLayer scene]]];
        }];
        
		CCMenu *menu = [CCMenu menuWithItems:itemPlay, itemStatistic, itemLogout, nil];
		
		[menu alignItemsVerticallyWithPadding:15];
		[menu setPosition:ccp(size.width/2+10, size.height/2 - 25)];
		
		// Add the menu to the layer
		[self addChild:menu];
        
        // Add the avatar to the menu
        Account *loggedInAccount = [Singleton sharedSingleton].loggedInAccount;
        if (loggedInAccount != nil) {
            
            // Display what type of account it is.
            CCLabelTTF *accountType;
            
            // Determine which string should be displayed based on the account type
            if (loggedInAccount.type == 1)
                accountType = [CCLabelTTF labelWithString:@"Teacher" fontName:@"KBPlanetEarth" fontSize:24];
            else
                accountType = [CCLabelTTF labelWithString:@"Student" fontName:@"KBPlanetEarth" fontSize:24];
            
            accountType.position = ccp(size.width/2, size.height/2+225);
            [self addChild:accountType];
            
            // Create the avatar
            [loggedInAccount createAvatar];
            loggedInAccount.avatar.scale = 0.5;
            loggedInAccount.avatar.position = ccp(size.width/2, size.height/2+175);
            
            // Create Name
            CCLabelTTF *portaitName = [CCLabelTTF labelWithString:loggedInAccount.name
                                                         fontName:@"KBPlanetEarth" fontSize:24];
            portaitName.position = ccp(size.width/2, size.height-275);
            [self addChild:portaitName];
            
            [self addChild:loggedInAccount.avatar];
        }
	}
	return self;
}



// on "dealloc" you need to release all your retained objects
- (void)dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark GameKit delegate

@end
