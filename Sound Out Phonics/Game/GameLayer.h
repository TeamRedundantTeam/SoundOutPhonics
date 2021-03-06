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
#import "TextToSpeech.h"
#import "Slot.h"
#import "StateButton.h"
#import "VictoryLayer.h"
#import "Level.h"
#import "Statistics.h"
#import "SOPDatabase.h"
#import "PauseLayer.h"

@interface GameLayer : CCLayer {
    
    // Information about the current level such as the level number, level name, level graphemes,
    // location of level's image and level's sprite reference.
    Level *_level;
    
    CGSize _size; // Used to store the screen size
    bool _pause; // Determins if the game is paused
    TextToSpeech *_tts; // Reference to TTS Library
    
    // Game variable declaration
    NSMutableArray *_graphemes; // Graphemes that the player will move around in the game layer
    CCLabelTTF *_selectedGrapheme; // Currently selected grapheme by players touch
    CGPoint _selectedGraphemeLastPosition; // The location of the selected grapheme
    NSMutableArray *_slots; // Slots array in which the user will be putting the graphemes in
    StateButton *_submitButton; // Submit button that will become enabled when all the slots are filled in
    CCSprite *_resetButton; // Reset button that resets the level
    CCSprite *_pauseButton; // Pause button that pauses the level
    CCLayerColor * _wrongAnswerLayer; // Layer that will display when the player doesn't spell the word correctly
    
    // Statistic Variables
    int _attempts; // Stores number of times the user wasn't able to get the word correctly. Will be used to determine level Score.
    CCLabelTTF *_levelScore; // text display of the level score
    double _elapsedTime; // how long the user has attempted to play the level
}

// returns a CCScene that contains the GameBoard as the only child and takes paramater level which has information about
// the level and number of tries the user attempted to play this level. The attempts are used when the player decides to
// refresh the level before completing it.

+ (CCScene *)sceneWithLevel:(Level *)level withAttempts:(int)attempts;
- (void)unpause;

@end
