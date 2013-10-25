//
//  GameBoardLayer.h
//  Sound Out Phonics
//
//  Created by Oleg M on 2013-10-23.
//  Copyright (c) 2013 Team Redundant Team. All rights reserved.
//

// When you import this file, you import all the cocos2d classes

#import "cocos2d.h"
#import "SpritePicture.h"
#import "TextToSpeech.h"

@interface GameBoardLayer : CCLayer {
    SpritePicture *picture; // Image of the word the user is trying to spell
    //TextToSpeech *tts; // Text To Speech library
    NSString *level; // The word that the players are trying to spell
}

// returns a CCScene that contains the GameBoardLayer as the only child and takes paramater gameLevel
+(CCScene *) sceneWithParamaters:(NSString*) gameLevel;

@property (retain) SpritePicture *picture;
@property (retain) TextToSpeech *tts;
@property (retain) NSString *level;
@end
