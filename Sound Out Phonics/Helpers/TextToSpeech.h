//
//  TTS.h
//  Sound Out Phonics
//
//  Created by Oleg M on 2013-10-24.
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

- (void) playWord : (NSString*)input;
@property (strong, nonatomic) FliteController *fliteController;
@property (strong, nonatomic) Slt *slt;
@end
