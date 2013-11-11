//
//  LevelSelect.m
//  Sound Out Phonics
//
//  Purpose: Level select layer and scene that allows player to choose which level they want to play
//
//  History: History of the file can be found here: https://github.com/TeamRedundantTeam/SoundOutPhonics/commits/master/Sound%20Out%20Phonics/Menu/LevelSelect.m
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
//  Created on 2013-11-09.
//  Copyright (c) 2013 Team Redundant Team. All rights reserved.
//

#import "LevelLayer.h"

@implementation LevelLayer

@synthesize levels = _levels;

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+ (CCScene *)scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	LevelLayer *layer = [LevelLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id)init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if((self = [super init])) {
		
		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        [self setTouchEnabled:YES];
        
        // create and initialize a background
        CCSprite *background = [CCSprite spriteWithFile:@"background_no_gradient.png"];
        
        background.position = ccp(size.width/2, size.height/2);
        
		// add the background as a child to this layer
        [self addChild: background];
        
        // Play Options
        [CCMenuItemFont setFontName:@"KBPlanetEarth"];
        [CCMenuItemFont setFontSize:28];
        
        //Create our URL to the xml file and parse it
        NSURL *xmlURL = [[NSBundle mainBundle] URLForResource:@"Levels" withExtension:@"xml"];
        self.levels = [[LevelParser alloc] loadLevels:xmlURL];
        
        int column = 0;
        int row = 0;
        int levelNumber = 0;
        //For each level create an image to display to select
        for (Level *level in self.levels) {
            
            // Keeps track of what level number this object is at
            levelNumber++;
            
            CCLabelTTF *levelName = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Level: %d",levelNumber] fontName:@"KBPlanetEarth" fontSize:24];
            levelName.position = ccp(size.width/10 + column*140, size.height-140 + row*(-140));
            [self addChild:levelName];
            
            [level createSprite];
            level.sprite.position = ccp(size.width/10 + column*140, size.height-200 + row*(-140));
            //Scale to 100x100px just for the selection screen
            level.sprite.scaleX = 100 / level.sprite.contentSize.width;
            level.sprite.scaleY = 100 / level.sprite.contentSize.height;
            [self addChild:level.sprite];
            
            column++;
            
            // Move to the next row every 7 items
            if (column % 7 == 0) {
                // Move to new row
                row++;
                // Reset the column
                column = 0;
            }
        }
        [xmlURL release];
        
        // Add the back button sprite
        CCSprite *backButton = [CCSprite spriteWithFile:@"logout_icon.png"]; // create and initialize the back button sprite (png)
        backButton.position = ccp(size.width - 180, size.height - size.height + 50);
        backButton.tag = 1;
        [self addChild:backButton];
        
        // Add the back text which will make the user go back to the menu when pressed
        [CCMenuItemFont setFontName:@"KBPlanetEarth"]; // set the default CCMenuItemFont to our custom font, KBPlanetEarth
        [CCMenuItemFont setFontSize:48]; // set the default CCMenuItemFont size
        
        CCMenuItem *itemBack = [CCMenuItemFont itemWithString:@"back" block:^(id sender) {
            
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade
                                                       transitionWithDuration:1.0
                                                       scene:[MenuLayer scene]]];
        }];
        
        CCMenu *menu = [CCMenu menuWithItems:itemBack, nil];
		[menu setPosition:ccp(size.width - 100, size.height - size.height + 40)];
		menu.tag = 1;
		// Add the menu to the layer
		[self addChild:menu];
    
	}
	return self;
}

// Dispatcher to catch the touch events
- (void)registerWithTouchDispatcher {
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
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

- (void)tapReleaseAt:(CGPoint)releaseLocation {
    // Checks if one of the Levels has been selected
    
    for (Level *level in self.levels) {
        if (CGRectContainsPoint(level.sprite.boundingBox, releaseLocation)) {
            [Singleton sharedSingleton].selectedLevel = level;
            
            // Create the level scene
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade
                                                       transitionWithDuration:1.0
                                                       scene:[GameLayer sceneWithLevel:level withAttempts:0]]];

        }
    }
}


// on "dealloc" you need to release all your retained objects
- (void)dealloc
{
    for (Level *level in self.levels) {
        if (level != [Singleton sharedSingleton].selectedLevel) {
            [level release];
        }
    }
    [self.levels release];
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}



@end
