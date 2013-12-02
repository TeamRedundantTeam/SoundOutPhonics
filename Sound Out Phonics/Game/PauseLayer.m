//
//  PauseLayer.m
//  Sound Out Phonics
//
//  Purpose: Pause layer that is displayed when the user pauses the game
//
//  History: History of the file can be found here: https://github.com/TeamRedundantTeam/SoundOutPhonics/commits/master/Sound%20Out%20Phonics/Game/PauseLayer.m
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
//  Created on 2013-12-1.
//  Copyright (c) 2013 Team Redundant Team. All rights reserved.
//

#import "PauseLayer.h"

#pragma mark - PauseLayer

@implementation PauseLayer

- (id)initWithColor:(ccColor4B)color {
    if ((self = [super initWithColor:color])) {
        
        [self setTouchEnabled:YES];
        _size = [[CCDirector sharedDirector] winSize];
        
        // create and initialize a background
        CCSprite *background = [CCSprite spriteWithFile:@"Default-Background.png"];
        
        background.position = ccp(_size.width/2, _size.height/2);
        background.scale = 0.50;
        [self addChild:background];
        
        // add level select icon to victory layer
        CCSprite *levelSelect = [CCSprite spriteWithFile:@"Game-IconFinal.png"];
        levelSelect.position = ccp(_size.width/2-130, _size.height - 365);
        [self addChild: levelSelect];
        
        // add resume icon to victory layer
        CCSprite *resumeLevel = [CCSprite spriteWithFile:@"Forward-IconFinal.png"];
        resumeLevel.position = ccp(_size.width/2-130, _size.height - 445);
        [self addChild: resumeLevel];
        
        // create header text
        CCLabelTTF *layerName = [CCLabelTTF labelWithString:@"paused!" fontName:@"KBPlanetEarth" fontSize:64];
        layerName.position = ccp(_size.width/2, _size.height - 250);
        [self addChild:layerName];
        
        _levelSelectButton = [CCLabelTTF labelWithString:@"level select" fontName:@"KBPlanetEarth" fontSize:48];
        [_levelSelectButton setPosition:ccp(_size.width/2+30, _size.height - 375)];
        [self addChild:_levelSelectButton];
        
        _resumeButton = [CCLabelTTF labelWithString:@"resume" fontName:@"KBPlanetEarth" fontSize:48];
        [_resumeButton setPosition:ccp(_size.width/2-10, _size.height - 450)];
        [self addChild:_resumeButton];
    }
    return self;
}
// dispatcher to catch the touch events
- (void)registerWithTouchDispatcher {
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

// handles the events that happen when the release occurs at a specific location
- (void)tapReleaseAt:(CGPoint)releaseLocation {
    
    if (CGRectContainsPoint(_levelSelectButton.boundingBox, releaseLocation)) {
        
        // exit to the menu
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0
                                                                                     scene:[LevelSelectLayer scene]]];
        [self.parent removeChild:self cleanup:YES];
    }
    
    if (CGRectContainsPoint(_resumeButton.boundingBox, releaseLocation)) {
        
        [self.parent scheduleOnce:@selector(unpause) delay:0];
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

- (void)dealloc {
    [super dealloc];
}

@end
