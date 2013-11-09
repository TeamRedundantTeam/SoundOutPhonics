//
//  Singleton.h
//  Sound Out Phonics
//
//  Created by Oleg M on 2013-11-06.
//  Copyright (c) 2013 Team Redundant Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"
#import "Level.h"

@interface Singleton : NSObject {
    Account *_loggedInAccount;
    Level *_selectedLevel;
}
+(Singleton *)sharedSingleton;
@property (retain, nonatomic) Account *loggedInAccount;
@property (retain, nonatomic) Level *selectedLevel;
@end
