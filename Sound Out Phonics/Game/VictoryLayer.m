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

- (id)initWithColor:(ccColor4B)color
{
    if ((self = [super initWithColor:color]))
    {
        [self setTouchEnabled:YES];
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        
        // Messages
        CCLabelTTF * victoryMessage = [CCLabelTTF labelWithString:@"YOU WIN!" fontName:@"KBPlanetEarth" fontSize:64];
        _playAgainMessage = [CCLabelTTF labelWithString:@"PLAY AGAIN?" fontName:@"KBPlanetEarth" fontSize:48];
        _mainMenuMessage = [CCLabelTTF labelWithString:@"QUIT" fontName:@"KBPlanetEarth" fontSize:48];
        [victoryMessage setPosition:ccp(screenSize.width/2, screenSize.height/2 + 75)];
        [_playAgainMessage setPosition:ccp(screenSize.width/2, screenSize.height/2)];
        [_mainMenuMessage setPosition:ccp(screenSize.width/2, screenSize.height/2 - 75)];
        [self addChild:victoryMessage];
        [self addChild:_playAgainMessage];
        [self addChild:_mainMenuMessage];
    }
    return self;
}

// Dispatcher to catch the touch events
- (void)registerWithTouchDispatcher {
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

// Handles the events that happen when the release occurs at a specific location
- (void)tapReleaseAt:(CGPoint)releaseLocation {

    if (CGRectContainsPoint(_playAgainMessage.boundingBox, releaseLocation)) {
        
        // Create the new game scene
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade
                                                   transitionWithDuration:1.0
                                                   scene:[GameLayer sceneWithLevel:[Singleton sharedSingleton].selectedLevel withAttempts:0]]];

        [self.parent removeChild:self cleanup:YES];
    }
    
    if (CGRectContainsPoint(_mainMenuMessage.boundingBox, releaseLocation)) {
        
        // Create the new game scene
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade
                                                   transitionWithDuration:1.0
                                                   scene:[MenuLayer scene]]];
        [self.parent removeChild:self cleanup:YES];
    }
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

- (void)dealloc {
    [super dealloc];
}

@end
