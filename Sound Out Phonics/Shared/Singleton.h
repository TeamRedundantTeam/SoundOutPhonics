//
//  Singleton.h
//  Sound Out Phonics
//
//  Created by Oleg M on 2013-11-06.
//  Copyright (c) 2013 Team Redundant Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"

@interface Singleton : NSObject {
    Account *_loggedInAccount;
}
+(Singleton *)sharedSingleton;
@property (retain, nonatomic) Account *loggedInAccount;
@end
