//
//  LevelSelect.m
//  Sound Out Phonics
//
//  Created by Jordan on 2013-11-10.
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
        CCSprite *background = [CCSprite spriteWithFile:@"mainmenu-no_gradient.png"];
        
        background.position = ccp(size.width/2, size.height/2);
        
		// add the background as a child to this layer
        [self addChild: background];
        
        // Play Options
        [CCMenuItemFont setFontName:@"KBPlanetEarth"];
        [CCMenuItemFont setFontSize:28];
        
        //Create our URL to the xml file and parse it
        NSURL *xmlURL = [[NSBundle mainBundle] URLForResource:@"Levels" withExtension:@"xml"];
        self.levels = [[LevelParser alloc] loadLevels:xmlURL];
        
        int i = 0;
        //For each level create an image to display to select
        for (Level *level in self.levels) {
            [level createSprite];
            level.sprite.position = ccp(size.width/4 + i*140, size.height-200);
            //Scale to 100x100px just for the selection screen
            level.sprite.scaleX = 100 / level.sprite.contentSize.width;
            level.sprite.scaleY = 100 / level.sprite.contentSize.height;
            [self addChild:level.sprite];
            
            CCLabelTTF *levelName = [CCLabelTTF labelWithString:level.name
                                                        fontName:@"KBPlanetEarth" fontSize:24];
            levelName.position = ccp(size.width/4 + i*140, size.height-280);
            [self addChild:levelName];
            i++;
        }
    [xmlURL release];
    
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
