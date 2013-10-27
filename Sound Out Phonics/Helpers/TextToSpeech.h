//
//  TTS.h
//  Sound Out Phonics
//
//  Purpose: Helper class that enables the text to speech functionality using OpenEars library
//  History: History of the file can be found here: https://github.com/TeamRedundantTeam/SoundOutPhonics/commits/master/Sound%20Out%20Phonics/Helpers/TextToSpeech.h
//
//  Created by Oleg Matvejev on 2013-10-24.
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

- (void)playWord:(NSString*)input;
@property (strong, nonatomic) FliteController *fliteController;
@property (strong, nonatomic) Slt *slt;
@end
