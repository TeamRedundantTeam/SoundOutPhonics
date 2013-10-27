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
#import "Slots.h"
#import "SubmitButton.h"

@interface GameBoardLayer : CCLayer {
    SpritePicture *picture; // Image of the word the user is trying to spell
    TextToSpeech *tts; // Text To Speech library
    NSString *level; // The word that the players are trying to spell
    NSMutableArray *graphymes; // Graphymes that the player will move around in the gameboard layer
    CCLabelTTF *selectedLabel;
    CGPoint selectedLabelLastPosition;
    NSMutableArray *slots;
    SubmitButton *submitButton;
}

// returns a CCScene that contains the GameBoardLayer as the only child and takes paramater gameLevel
+(CCScene *) sceneWithParamaters:(NSString*) gameLevel :(NSString*)levelGraphymes;

@property (retain) SpritePicture *picture;
@property (retain) TextToSpeech *tts;
@property (retain) NSString *level;
@property (retain) NSMutableArray *graphymes;
@property (retain) CCLabelTTF *selectedLabel;
@property (retain) NSMutableArray *slots;
@property (retain) SubmitButton *submitButton;
@end
