//
//  Account.m
//  Sound Out Phonics
//
//  Purpose: Object that stores account information
//
//  History: History of the file can be found here: https://github.com/TeamRedundantTeam/SoundOutPhonics/commits/master/Sound%20Out%20Phonics/Shared/Account.m
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

#import "Account.h"

@implementation Account

@synthesize accountId = _accountId;
@synthesize name = _name;
@synthesize password = _password;
@synthesize type = _type;
@synthesize image = _image;
@synthesize avatar = _avatar;

- (id)initWithId:(int)accountId name:(NSString *)name password:(NSString *)password type:(int)type image:(NSString *) image {
    if ((self = [super init])) {
        self.accountId = accountId;
        self.name = name;
        self.password = password;
        self.type = type;
        self.image = image;
        
        // Sets the avatar based on the input.
        if ([self.image isEqualToString:@""])
            self.avatar = [CCSprite spriteWithFile:@"EmptyPortrait.png"];
        else
            self.avatar = [CCSprite spriteWithFile:self.image];
    }
    return self;
}

// Updates the avatar to the new image
- (void) updateAvatar:(NSString *)image {
    self.image = image;
    if ([self.image isEqualToString:@""])
        self.avatar = [CCSprite spriteWithFile:@"EmptyPortrait.png"];
    else
        self.avatar = [CCSprite spriteWithFile:self.image];
}

- (void) dealloc {
    self.name = nil;
    self.password = nil;
    [super dealloc];
}
@end
