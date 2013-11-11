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
@synthesize statistics = _statistics;

// initializes the object with parameters received from the database
- (id)initWithId:(int)accountId withName:(NSString *)name withPassword:(NSString *)password withType:(int)type withImage:(NSString *) image withStatistics:(NSArray *)statistics {
    if ((self = [super init])) {
        self.accountId = accountId;
        self.name = name;
        self.password = password;
        self.type = type;
        self.image = image;
        self.statistics = statistics;
    }
    return self;
}

// creates the avatar based of the current image set in the class
- (void) createAvatar {
    if ([self.image isEqualToString:@""])
        _avatar = [CCSprite spriteWithFile:@"Empty-Portrait.png"];
    else
        _avatar = [CCSprite spriteWithFile:self.image];
}

// returns the reference of the avatar
- (CCSprite *) avatar {
    return _avatar;
}

// removes the reference to the currently used avatar. The cleanup for this object should be done within the layer
- (void) removeAvatar {
    _avatar = nil;
}

- (void) dealloc {
    self.name = nil;
    self.password = nil;
    [self.statistics release];
    [super dealloc];
}
@end
