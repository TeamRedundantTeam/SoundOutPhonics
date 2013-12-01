//
//  VictoryLayer.m
//  Sound Out Phonics
//
//  Purpose: Victory scene and layer that is displayed when the user gets all the
//           graphemes in the correct slot
//
//  History: History of the file can be found here: https://github.com/TeamRedundantTeam/SoundOutPhonics/commits/master/Sound%20Out%20Phonics/Game/VictoryLayer.m
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
//  Created on 2013-10-27.
//  Copyright (c) 2013 Team Redundant Team. All rights reserved.
//

#import "VictoryLayer.h"

#pragma mark - VictoryLayer

@implementation VictoryLayer

- (id)initWithColor:(ccColor4B)color withScore:(NSString *)score {
    if ((self = [super initWithColor:color])) {
        
        [self setTouchEnabled:YES];
        _size = [[CCDirector sharedDirector] winSize];
        
        // create and initialize a background
        CCSprite *background = [CCSprite spriteWithFile:@"Default-Background.png"];
        
        background.position = ccp(_size.width/2, _size.height/2);
        background.scale = 0.75;
        [self addChild:background];
        
        // create header text
        CCLabelTTF *layerName = [CCLabelTTF labelWithString:@"YOU WIN!" fontName:@"KBPlanetEarth" fontSize:48];
        layerName.position = ccp(_size.width/2, _size.height - 150);
        [self addChild:layerName];
        
        CCLabelTTF *scoreMessage = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Score: %@", score] fontName:@"KBPlanetEarth" fontSize:48];
        [scoreMessage setPosition:ccp(_size.width/2, _size.height - 225)];
        [self addChild:scoreMessage];
        
        _playAgainButton = [CCLabelTTF labelWithString:@"Play Again?" fontName:@"KBPlanetEarth" fontSize:48];
        [_playAgainButton setPosition:ccp(_size.width/2, _size.height - 325)];
        [self addChild:_playAgainButton];
        
        _nextLevelButton = [StateText labelWithString:@"Next Level" fontName:@"KBPlanetEarth" fontSize:48];
        [_nextLevelButton setPosition:ccp(_size.width/2, _size.height - 400)];
        
        // Check if there is a next level and set the next level button accordingly
        if ([Singleton sharedSingleton].selectedLevel.nextLevel)
            [_nextLevelButton setState:true];
        else
            [_nextLevelButton setState:false];
        [self addChild:_nextLevelButton];
        
        _levelSelectButton = [CCLabelTTF labelWithString:@"Level Select" fontName:@"KBPlanetEarth" fontSize:48];
        [_levelSelectButton setPosition:ccp(_size.width/2, _size.height - 475)];
        [self addChild:_levelSelectButton];
        
    }
    return self;
}

// dispatcher to catch the touch events
- (void)registerWithTouchDispatcher {
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

// handles the events that happen when the release occurs at a specific location
- (void)tapReleaseAt:(CGPoint)releaseLocation {

    if (CGRectContainsPoint(_playAgainButton.boundingBox, releaseLocation)) {
        
        // create the new game scene
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0
                                     scene:[GameLayer sceneWithLevel:[Singleton sharedSingleton].selectedLevel withAttempts:0]]];

        [self.parent removeChild:self cleanup:YES];
    }
    
    if (_nextLevelButton.state && CGRectContainsPoint(_nextLevelButton.boundingBox, releaseLocation)) {
        
        // create the new game scene
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0
                                     scene:[GameLayer sceneWithLevel:[Singleton sharedSingleton].selectedLevel.nextLevel withAttempts:0]]];
        
        [self.parent removeChild:self cleanup:YES];
    }
    
    if (CGRectContainsPoint(_levelSelectButton.boundingBox, releaseLocation)) {
        
        // exit to the menu
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0
                                     scene:[LevelSelectLayer scene]]];
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
