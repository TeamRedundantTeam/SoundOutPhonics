//
//  VictoryLayer.m
//  Sound Out Phonics
//
//  Created by Oleg M on 2013-10-27.
//  Copyright (c) 2013 Team Redundant Team. All rights reserved.
//

#import "VictoryLayer.h"

@implementation VictoryLayer

- (id) initWithColor:(ccColor4B)color
{
    if ((self = [super initWithColor:color]))
    {
        
        [self setTouchEnabled:YES];
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        
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
    for( UITouch *touch in touches )
    {
        CGPoint location = [touch locationInView: [touch view]];
        
        location = [[CCDirector sharedDirector] convertToGL: location];

        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade
                                                   transitionWithDuration:1.0
                                                   scene:[GameBoardLayer sceneWithParamaters:@"Apple":@"A-pp-le"] ]];
        [self.parent removeChild:self cleanup:YES];
    }
}

- (void) dealloc
{
    [super dealloc];
}

@end
