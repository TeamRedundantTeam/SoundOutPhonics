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
        CCLabelTTF * victoryMessage = [CCLabelTTF labelWithString:@"You win!" fontName:@"Marker Felt" fontSize:64];
        CCLabelTTF * tapMessage = [CCLabelTTF labelWithString:@"Tap anywhere to play again!" fontName:@"Marker Felt" fontSize:48];
        [victoryMessage setPosition:ccp(screenSize.width/2, screenSize.height/2 + 75)];
        [tapMessage setPosition:ccp(screenSize.width/2, screenSize.height/2)];
        [self addChild:victoryMessage];
        [self addChild:tapMessage];
    }
    return self;
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Check if any touch has occured
    for (UITouch *touch in touches)
    {
        CGPoint location = [touch locationInView: [touch view]];
        location = [[CCDirector sharedDirector] convertToGL: location];
        
        // Create the new game scene
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade
                                                   transitionWithDuration:1.0
                                                   scene:[GameLayer sceneWithParamaters:@"Apple" withGraphemes:@"A-pp-le"]]];
        [self.parent removeChild:self cleanup:YES];
    }
}

- (void)dealloc
{
    [super dealloc];
}

@end
