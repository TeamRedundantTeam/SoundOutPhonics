//
//  MenuLayer.h
//  Sound Out Phonics
//
//  Purpose: Menu layer and scene that has verious menu items based on the user type.
//  History: History of the file can be found here: https://github.com/TeamRedundantTeam/SoundOutPhonics/commits/master/Sound%20Out%20Phonics/Menu/MenuLayer.h
//
//  Created by Oleg Matvejev on 2013-10-24.
//  Copyright (c) 2013 Team Redundant Team. All rights reserved.
//


#import "cocos2d.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "GameLayer.h"

@interface MenuLayer : CCLayer {

}

// returns a CCScene that contains the MenuLayer as the only child
+ (CCScene *)scene;

@end

