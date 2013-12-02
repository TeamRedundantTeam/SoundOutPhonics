//
//  ClassStatisticLayer.m
//  Sound Out Phonics
//
//  Purpose: A layer that displays all the students statistics as a whole including graph which show how many % of
//           students were able to complete a perticular level.
//
//  History: History of the file can be found here: https://github.com/TeamRedundantTeam/SoundOutPhonics/commits/master/Sound%20Out%20Phonics/Menu/ClassStatisticLayer.m
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
//  Created on 2013-12-2.
//  Copyright (c) 2013 Team Redundant Team. All rights reserved.
//

#import "ClassStatisticsLayer.h"

@implementation ClassStatisticsLayer

// helper class method that creates a Scene with the StatistcLayer as the only child.
+ (CCScene *)scene {
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ClassStatisticsLayer *layer = [ClassStatisticsLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// initialize the instance
- (id)init {
	// Apple recommends to re-assign "self" with the "super's" return value
	if((self = [super init])) {
        
        // ask the director for the window size
        _size = [[CCDirector sharedDirector] winSize];
        
        // enable touch for this layer
        [self setTouchEnabled:YES];
        
        // Initialize and add the background sprites
        CCSprite *background = [CCSprite spriteWithFile:@"Default-Background.png"]; // create and initialize the background sprite (png)
        CCLabelTTF *titleName = [CCLabelTTF labelWithString:@"CLASS STATISTICS" fontName:@"KBPlanetEarth" fontSize:48];
        
        background.position = ccp(_size.width/2, _size.height/2); // center background layer
        titleName.position = ccp(_size.width/2, _size.height-75);
        
        [self addChild:background];
        [self addChild:titleName];
        
        // add the back text which will make the user go back to the menu when pressed
        [CCMenuItemFont setFontName:@"KBPlanetEarth"]; // set the default CCMenuItemFont to our custom font, KBPlanetEarth
        [CCMenuItemFont setFontSize:48]; // set the default CCMenuItemFont size
        
        CCMenuItemImage *itemHome = [CCMenuItemImage itemWithNormalImage:@"Home-Icon.png" selectedImage:@"Home-Icon.png" target:self selector:@selector(goHome:)];
        
        CCMenu *menu = [CCMenu menuWithItems:itemHome, nil];
		
        [menu setPosition:ccp(_size.width - 100, _size.height - _size.height + 40)];
        
		// add the menu to the layer
		[self addChild:menu];
        
        // Display the class statistics
        [self drawClassStatistics];
    }
    return self;
}

// function called by pressing HOME button to return to main menu
- (void)goHome:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[StatisticLayer scene]]];
}

// Creates a rectangle with a specified size and colors
- (CCSprite *) rectangleOfSize:(CGSize)size withRed:(uint8_t)red green:(uint8_t)green blue:(uint8_t)blue andAlpha:(uint8_t)alpha {
    
    // Sprite reference
    CCSprite *sprite = [CCSprite node];
    
    // Initialize the color buffer
    GLubyte *buffer = (GLubyte *) malloc(sizeof(GLubyte)*4);
    
    buffer[0] = red;
    buffer[1] = green;
    buffer[2] = blue;
    buffer[3] = alpha;
    
    // Create new solid texture with the specified size and color
    CCTexture2D *texture = [[CCTexture2D alloc] initWithData:buffer pixelFormat:kCCTexture2DPixelFormat_Default pixelsWide:1 pixelsHigh:1 contentSize:size];
    
    // Add rectangular texture to the sprite
    [sprite setTexture:texture];
    [sprite setTextureRect:CGRectMake(0, 0, size.width, size.height)];
    
    // release memory
    [texture release];
    free(buffer);
    return sprite;
}

// Draws the class statistcs graph with the data pulled from the database
-(void)drawClassStatistics {
    
    CCLabelTTF *graphName = [CCLabelTTF labelWithString:@"Completed Level vs. % Students" fontName:@"KBPlanetEarth" fontSize:32];
    graphName.position = ccp(_size.width/2, _size.height/2 + 225);
    [self addChild:graphName];
    
    CCSprite *overlay = [CCSprite spriteWithFile:@"Graph-Overlay.png"];
    overlay.anchorPoint = ccp(0, 0);
    overlay.position = ccp(200, _size.height/2 - 9);
    [self addChild:overlay];
    
    CCLabelTTF *labelx = [CCLabelTTF labelWithString:@"Completed Level" fontName:@"KBPlanetEarth" fontSize:24];
    labelx.position = ccp(_size.width/2, _size.height/2 - 30);
    [self addChild:labelx];

    
    CCLabelTTF *labely = [CCLabelTTF labelWithString:@"% Students" fontName:@"KBPlanetEarth" fontSize:24];
    labely.position = ccp(190, _size.height/2 + 85);
    labely.rotation = -90;
    [self addChild:labely];
    
    // Pull the data from the database
    NSArray *studentLevelStatistics = [[SOPDatabase database] getCompletedLevelStatistics];
    
    // Loop through everysingle level (this value should be pulled from the XML file due to time
    // constraint we will use a magic number instead)
    for (int i = 1; i <= 50; i ++) {
        
        // Loop through the statistics
        for (int j = 0; j < [studentLevelStatistics count]; j++) {
            
            // Levels are stored at every second value
            if (j % 2 == 0) {
                NSNumber *level = [studentLevelStatistics objectAtIndex:j];
                if ([level integerValue] == i) {
                    
                    // Percent is stored in the next field
                    NSNumber *percent = [studentLevelStatistics objectAtIndex:j+1];
                    
                    // Create the graph object background with with the size based on percent of students completing the level
                    CCSprite *objectBackground = [self rectangleOfSize:CGSizeMake(8, (150 * [percent doubleValue]) + 1)
                                                               withRed:0 green:0 blue:0 andAlpha:255];
                    objectBackground.anchorPoint = ccp(0,0);
                    objectBackground.position = ccp(214 + (i - 1) * 12, _size.height/2);
                    
                    [self addChild:objectBackground];
                    
                    // Create the graph object background with with the size based on percent of students completing the level
                    CCSprite *object = [self rectangleOfSize:CGSizeMake(6, 150 * [percent doubleValue])
                                                     withRed:255 green:255 blue:255 andAlpha:255];
                    
                    object.anchorPoint = ccp(0,0);
                    object.position = ccp(215 + (i - 1) * 12, _size.height/2);
                    [self addChild:object];
                    break;
                }
            }
        }
    }
}

- (void) dealloc {
    [super dealloc];
}
@end
