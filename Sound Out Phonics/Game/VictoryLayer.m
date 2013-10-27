//
//  VictoryLayer.m
//  Sound Out Phonics
//
//  Purpose: Victory scene and layer that is displayed when the user gets all the graphemes in the correct slot
//  History: History of the file can be found here: https://github.com/TeamRedundantTeam/SoundOutPhonics/commits/master/Sound%20Out%20Phonics/Game/VictoryLayer.m
//
//  Created by Oleg Matvejev on 2013-10-27.
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
