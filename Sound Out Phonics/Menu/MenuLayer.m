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

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
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

// on "init" you need to initialize your instance
- (id)init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if((self = [super init])) {
		
		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        
        // create and initialize a background
        CCSprite *background = [CCSprite spriteWithFile:@"Main-Menu.png"];

        background.position = ccp(size.width/2, size.height/2);

		// add the background as a child to this layer
        [self addChild: background];
        
        // Play Options
        [CCMenuItemFont setFontSize:28];
        
        
        CCMenuItem *itemPlay = [CCMenuItemFont itemWithString:@"Play" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade
                                                       transitionWithDuration:1.0
                                                       scene:[GameLayer sceneWithParamaters:@"Apple" withGraphemes:@"A-pp-le"] ]];
        }];
        
        
		CCMenu *menu = [CCMenu menuWithItems:itemPlay, nil];
		
		[menu alignItemsVerticallyWithPadding:20];
		[menu setPosition:ccp( size.width/2, size.height/2 - 50)];
		
		// Add the menu to the layer
		[self addChild:menu];
        
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
