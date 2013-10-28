//
//  GameBoardLayer.h
//  Sound Out Phonics
//
//  Purpose: This is the main game class scene and layer that handles all the game
//           logic, displays sprites and performs touch events
//
//  History: History of the file can be found here:
//           Version 0.1 - 0.5: https://github.com/TeamRedundantTeam/SoundOutPhonics/commits/master/Sound%20Out%20Phonics/Game/GameBoardLayer.m
//           Version 0.6 + : https://github.com/TeamRedundantTeam/SoundOutPhonics/commits/master/Sound%20Out%20Phonics/Game/GameLayer.m
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
//  Created on 2013-10-23.
//  Copyright (c) 2013 Team Redundant Team. All rights reserved.
//


#import "cocos2d.h"
#import "SpritePicture.h"
#import "TextToSpeech.h"
#import "Slot.h"
#import "SubmitButton.h"
#import "VictoryLayer.h"

@interface GameLayer : CCLayer {
    SpritePicture *picture; // Image of the word the user is trying to spell
    TextToSpeech *tts; // Text To Speech library
    NSString *level; // The word that the players are trying to spell
    NSMutableArray *graphemes; // Graphemes that the player will move around in the game layer
    CCLabelTTF *selectedGrapheme; // Currently selected grapheme by players touch
    CGPoint selectedGraphemeLastPosition; // The location of the selected grapheme
    NSMutableArray *slots; // Slots array in which the user will be putting the graphemes in
    SubmitButton *submitButton; // Submit button that will become enabled when all the slots are filled in

}

// returns a CCScene that contains the GameBoardLayer as the only child and takes paramater gameLevel
+(CCScene *)sceneWithParamaters:(NSString *)gameLevel withGraphemes:(NSString *)levelGraphemes;

@property (retain, nonatomic) SpritePicture *picture;
@property (retain, nonatomic) TextToSpeech *tts;
@property (retain, nonatomic) NSString *level;
@property (retain, nonatomic) NSMutableArray *graphemes;
@property (retain, nonatomic) CCLabelTTF *selectedGrapheme;
@property (retain, nonatomic) NSMutableArray *slots;
@property (retain, nonatomic) SubmitButton *submitButton;
@end
