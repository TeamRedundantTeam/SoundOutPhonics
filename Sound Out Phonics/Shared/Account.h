//
//  Account.h
//  Sound Out Phonics
//
//  Purpose: Object that stores account information
//
//  History: History of the file can be found here: https://github.com/TeamRedundantTeam/SoundOutPhonics/commits/master/Sound%20Out%20Phonics/Shared/Account.h
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
//  Created on 2013-11-5.
//  Copyright (c) 2013 Team Redundant Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Account : NSObject {
    int _accountId;
    NSString *_name;
    NSString *_password;
    int _type;
    NSString *_image;
    CCSprite *_avatar;
}

@property (nonatomic, assign) int accountId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, assign) int type;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, retain) CCSprite *avatar;

- (id)initWithId:(int)accountId name:(NSString *)name password:(NSString *)password type:(int)type image:(NSString *)image;

@end
