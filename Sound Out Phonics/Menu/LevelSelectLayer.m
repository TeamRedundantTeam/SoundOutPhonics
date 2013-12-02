//
//  LevelSelect.m
//  Sound Out Phonics
//
//  Purpose: Level select layer and scene that allows player to choose which level they want to play
//
//  History: History of the file can be found here:
//           https://github.com/TeamRedundantTeam/SoundOutPhonics/commits/master/Sound%20Out%20Phonics/Menu/LevelLayer.m
//           https://github.com/TeamRedundantTeam/SoundOutPhonics/commits/master/Sound%20Out%20Phonics/Menu/LevelSelectLayer.m
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

#import "LevelSelectLayer.h"

@implementation LevelSelectLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+ (CCScene *)scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	LevelSelectLayer *layer = [LevelSelectLayer node];
	
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
		_size = [[CCDirector sharedDirector] winSize];
        
        [self setTouchEnabled:YES];
        
        // Initialize and add the background sprites
        CCSprite *background = [CCSprite spriteWithFile:@"Default-Background.png"];
        CCLabelTTF *titleName = [CCLabelTTF labelWithString:@"LEVEL SELECT" fontName:@"KBPlanetEarth" fontSize:48];
        
        background.position = ccp(_size.width/2, _size.height/2);
        titleName.position = ccp(_size.width/2, _size.height-75);
        
        [self addChild:background];
        [self addChild:titleName];
        
        // add the back text which will make the user go back to the menu when pressed
        [CCMenuItemFont setFontName:@"KBPlanetEarth"];                                      // set the default CCMenuItemFont to our custom font, KBPlanetEarth
        [CCMenuItemFont setFontSize:48];                                                    // set the default CCMenuItemFont size
         
        CCMenuItemImage *itemHome = [CCMenuItemImage itemWithNormalImage:@"Home-Icon.png" selectedImage:@"Home-Icon.png" target:self selector:@selector(goHome:)];
             
        CCMenu *menu = [CCMenu menuWithItems:itemHome, nil];
		[menu setPosition:ccp(_size.width - 100, _size.height - _size.height + 40)];
        
		// add the menu to the layer
		[self addChild:menu];
        
        _lastLevelsPage = [CCSprite spriteWithFile:@"Backward-Icon.png"];
        _nextLevelsPage = [CCSprite spriteWithFile:@"Backward-Icon.png"];
        
        _lastLevelsPage.position = ccp(_size.width/4 + 225, _size.height/3 - 200);
        _nextLevelsPage.position = ccp(_size.width/4 + 325, _size.height/3 - 200);
        // Rotate the sprite by 180 degrees CW
        _nextLevelsPage.rotation = 180;
        
        // In some cases paging might not be needed so the sprites are invisible by default and enabled later on
        _lastLevelsPage.visible = false;
        _nextLevelsPage.visible = false;
        
        [self addChild:_lastLevelsPage];
        [self addChild:_nextLevelsPage];
        
        if (![Singleton sharedSingleton].levels) {
            // create the URL to the XML file and parse it
            NSURL *xmlURL = [[NSBundle mainBundle] URLForResource:@"Levels" withExtension:@"xml"];
            _levels = [[LevelParser alloc] loadLevels:xmlURL];
            [xmlURL release];
            
            Level *previousLevel = nil;
            for (Level *level in _levels) {
                
                if (previousLevel)
                    previousLevel.nextLevel = level;
                
                previousLevel = level;
            }
            
            [Singleton sharedSingleton].levels = _levels;
        }
        else
            _levels = [Singleton sharedSingleton].levels;
        
        _currentLevelsPage = 1;
        [self displayLevels];
	}
	return self;
}

// function called by pressing HOME button to return to main menu
- (void)goHome:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MenuLayer scene]]];
}

- (void) displayLevels {


    int resultsPerRow = 6;
    int maxNumOfRows = 3;
    
    // Make the next and last page arrow visible
    if ([_levels count] > resultsPerRow * maxNumOfRows) {
        if (_currentLevelsPage != 1)
            _lastLevelsPage.visible = true;
        if (_currentLevelsPage * resultsPerRow * maxNumOfRows < [_levels count])
            _nextLevelsPage.visible = true;
    
        // display of what page it is
        CCLabelTTF *pageLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",_currentLevelsPage] fontName:@"KBPlanetEarth" fontSize:24];
        pageLabel.position = ccp(_size.width/4 + 275, _size.height/3 - 200);
        pageLabel.tag = 0;
        [self addChild:pageLabel];
    }
    
    // create and initialize variables to organize level sprites
    int i = 0; // iterator
    int column = 0;
    int row = 0;
    
    // for each level create an image to display to select
    for (Level *level in _levels) {
        if (i >= (_currentLevelsPage - 1) * resultsPerRow * maxNumOfRows && i < _currentLevelsPage * resultsPerRow * maxNumOfRows) {
            // display the level name and set its position
            CCLabelTTF *levelName = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"level: %d",level.levelId] fontName:@"KBPlanetEarth" fontSize:24];
            levelName.position = ccp(_size.width/7 + column * 140, _size.height - 160 + row * -180);
            levelName.tag = 0;
            [self addChild:levelName];
        
            [level createSprite];
            level.sprite.position = ccp(_size.width/7 + column * 140, _size.height - 230 + row * -180);
            // scale sprite to 100x100px for only the selection screen
            level.sprite.scaleX = 100 / level.sprite.contentSize.width;
            level.sprite.scaleY = 100 / level.sprite.contentSize.height;
            level.sprite.visible = true;
            [self addChild:level.sprite];
            // increment column
            column++;
        
            // move to the next row every 7 items
            if (column % resultsPerRow == 0) {
                // move to new row
                row++;
                // reset the column
                column = 0;
            }
        }
        i++;
    }
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
    
    for (Level *level in _levels) {
        if (level.sprite.visible && CGRectContainsPoint(level.sprite.boundingBox, releaseLocation)) {
            
            // Create the level scene
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade
                                                       transitionWithDuration:1.0
                                                       scene:[GameLayer sceneWithLevel:level withAttempts:0]]];

        }
    }
    
    // check if the user has pressed the next page sprite.
    if (_nextLevelsPage.visible && CGRectContainsPoint(_nextLevelsPage.boundingBox, releaseLocation)) {
        _currentLevelsPage++;
        
        // cleanup all temporary objects before proceeding to the next stage
        [self cleanupAccountsSprites];
        
        // display the levels on the new page
        [self displayLevels];
    }
    
    // check if the user has pressed the last page sprite.
    if (_lastLevelsPage.visible && CGRectContainsPoint(_lastLevelsPage.boundingBox, releaseLocation)) {
        
        // The first page is always 1. Make sure that the current page doesn't go out of those bounds
        if (_currentLevelsPage > 1) {
            _currentLevelsPage--;
            
            // cleanup all temporary objects before proceeding to the next stage
            [self cleanupAccountsSprites];
            
            // display the levels on the new page
            [self displayLevels];
        }
    }
    
}

// removes all the temporary objects from the scene
- (void)cleanupAccountsSprites {
    
    // Remove all children that were tagged as 0
    while ([self getChildByTag:0])
        [self removeChildByTag:0 cleanup:true];
    
    _lastLevelsPage.visible = false;
    _nextLevelsPage.visible = false;
    
    for (Level *level in _levels)
        level.sprite.visible = false;
}

// on "dealloc" you need to release all your retained objects
- (void)dealloc {
	[super dealloc];
}

@end
