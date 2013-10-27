//
//  IntroLayer.h
//  Sound Out Phonics
//
//  Purpose: Intro layer and scene that is played when the application just starts. The layer then creates the menu scene
//  History: History of the file can be found here: https://github.com/TeamRedundantTeam/SoundOutPhonics/commits/master/Sound%20Out%20Phonics/Intro/IntroLayer.h
//
//  Created by Oleg Matvejev on 2013-10-24.
//  Copyright (c) 2013 Team Redundant Team. All rights reserved.
//

#import "cocos2d.h"
#import "MenuLayer.h"

@interface IntroLayer : CCLayer {
}

// returns a CCScene that contains the IntroLayer as the only child
+ (CCScene *)scene;

@end
