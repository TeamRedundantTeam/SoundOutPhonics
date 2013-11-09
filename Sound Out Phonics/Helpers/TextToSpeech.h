//
//  TTS.h
//  Sound Out Phonics
//
//  Purpose: Helper class that enables the text to speech functionality using
//           OpenEars library
//
//  History: History of the file can be found here: https://github.com/TeamRedundantTeam/SoundOutPhonics/commits/master/Sound%20Out%20Phonics/Helpers/TextToSpeech.h
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
//  Created on 2013-10-24.
//  Copyright (c) 2013 Team Redundant Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Slt/Slt.h>
#import <OpenEars/FliteController.h>

@interface TextToSpeech : NSObject {
    // TTS related classes
    FliteController *fliteController;
    Slt *slt;
}

// Plays the word using the the OpenEars library based on the input
- (void)playWord:(NSString*)input;
@property (strong, nonatomic) FliteController *fliteController;
@property (strong, nonatomic) Slt *slt;
@end
