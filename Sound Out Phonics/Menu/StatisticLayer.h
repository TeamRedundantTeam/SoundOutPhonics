//
//  StatisticLayer.h
//  Sound Out Phonics
//
//  Created by Oleg M on 2013-11-10.
//  Copyright (c) 2013 Team Redundant Team. All rights reserved.
//

#import "cocos2d.h"
#import "Account.h"
#import "Singleton.h"
#import "SOPDatabase.h"
#import "MenuLayer.h"
#import "ClassStatisticsLayer.h"

@interface StatisticLayer : CCLayer {
    CGSize _size; // Used to store the screen size
    Account *_loggedInAccount; // Used to access the logged in account
    CCSprite *_backText; // Used to store the go back text that will allow user to go back to the menu
    NSArray *_accounts; // Stores reference to the accounts that are pulled from the database
    NSArray *_statistics;
    CCSprite *_selectedAvatarBorder; // A border for avatar to indicate that it is selected
    Account *_selectedAccount; // Account that is currently selected by the user
    CCSprite *_nextStatisticsPage; // Sprite that allows users to move to the next page
    CCSprite *_lastStatisticsPage; // Sprite that allows users to move to the last page
    int _currentStatisticsPage; // Keeps track of the current statistic page
    int _currentAccountsPage; // Keeps track of the current statistic page
    CCSprite *_lastAccountsPage; // Sprite that allows users to move to the previous account page
    CCSprite *_nextAccountsPage; // Sprite that allows users to move to the next account page
    CCLabelTTF *_viewClassStatisticButton; // A button that takes the user to class statistics when pressed
}

// returns a CCScene that contains the StatisticLayer as the only child
+ (CCScene *)scene;

@property (retain, nonatomic) NSArray *accounts;
@property (retain, nonatomic) NSArray *statistics;
@end
