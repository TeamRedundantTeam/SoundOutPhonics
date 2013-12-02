//
//  StatisticLayer.m
//  Sound Out Phonics
//
//  Purpose: Statistic layer and scene that will display various account statistics depending on if the logged in account is a student or a teacher
//
//  History: History of the file can be found here: https://github.com/TeamRedundantTeam/SoundOutPhonics/commits/master/Sound%20Out%20Phonics/Menu/StatisticLayer.m
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
//  Created on 2013-11-10.
//  Copyright (c) 2013 Team Redundant Team. All rights reserved.
//

#import "StatisticLayer.h"

@implementation StatisticLayer

@synthesize accounts = _accounts;
@synthesize statistics = _statistics;

// helper class method that creates a Scene with the StatistcLayer as the only child.
+ (CCScene *)scene {
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	StatisticLayer *layer = [StatisticLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// initialize the instance
- (id)init
{
	// Apple recommends to re-assign "self" with the "super's" return value
	if((self = [super init])) {
        
        // ask the director for the window size
        _size = [[CCDirector sharedDirector] winSize];
        
        // enable touch for this layer
        [self setTouchEnabled:YES];
        
        // set the account to the logged in account
        _loggedInAccount = [Singleton sharedSingleton].loggedInAccount;
        
        // both accounts and statistics start at the first page
        _currentAccountsPage = 1;
        _currentStatisticsPage = 1;
        
        // Initialize and add the background sprites
        CCSprite *background = [CCSprite spriteWithFile:@"Default-Background.png"]; // create and initialize the background sprite (png)
        CCLabelTTF *titleName = [CCLabelTTF labelWithString:@"STATISTICS" fontName:@"KBPlanetEarth" fontSize:48];
        
        background.position = ccp(_size.width/2, _size.height/2); // center background layer
        titleName.position = ccp(_size.width/2, _size.height-75);

        [self addChild:background];
        [self addChild:titleName];

        // Initialize and add the paging button sprites
        _lastStatisticsPage = [CCSprite spriteWithFile:@"Backward-IconFinal.png"];
        _nextStatisticsPage = [CCSprite spriteWithFile:@"Backward-IconFinal.png"];
        _lastAccountsPage = [CCSprite spriteWithFile:@"Backward-IconFinal.png"];
        _nextAccountsPage = [CCSprite spriteWithFile:@"Backward-IconFinal.png"];
        
        _lastStatisticsPage.position = ccp(_size.width/4 + 225, _size.height/3 - 200);
        _nextStatisticsPage.position = ccp(_size.width/4 + 325, _size.height/3 - 200);
        _lastAccountsPage.position = ccp(_size.width/2 - 375, _size.height-230);
        _nextAccountsPage.position = ccp(_size.width/2 + 375, _size.height-230);
        
        // Rotate the sprite by 180 degrees CW
        _nextStatisticsPage.rotation = 180;
        _nextAccountsPage.rotation = 180;
        
        // In some cases paging might not be needed so the sprites are invisible by default and enabled later on
        _lastStatisticsPage.visible = false;
        _nextStatisticsPage.visible = false;
        _lastAccountsPage.visible = false;
        _nextAccountsPage.visible = false;
        
        [self addChild:_lastAccountsPage];
        [self addChild:_nextAccountsPage];
        [self addChild:_lastStatisticsPage];
        [self addChild:_nextStatisticsPage];
        
        // add the back text which will make the user go back to the menu when pressed
        [CCMenuItemFont setFontName:@"KBPlanetEarth"]; // set the default CCMenuItemFont to our custom font, KBPlanetEarth
        [CCMenuItemFont setFontSize:48]; // set the default CCMenuItemFont size
        
        CCMenuItemImage *itemHome = [CCMenuItemImage itemWithNormalImage:@"Home-IconFinal.png" selectedImage:@"Home-IconFinal.png" target:self selector:@selector(goHome:)];
        
        CCMenu *menu = [CCMenu menuWithItems:itemHome, nil];
		
        [menu setPosition:ccp(_size.width - 100, _size.height - _size.height + 40)];
        
		// add the menu to the layer
		[self addChild:menu];
        
        
        // Load the accounts based on the currently logged in account level. If the account level is an administrator
        // then load all the students from the database. Otherwise, only add the student itself.
        if (_loggedInAccount.type == 1)
            self.accounts = [[SOPDatabase database] loadAccounts];
        
        else
            self.accounts = [NSArray arrayWithObject:_loggedInAccount];
        
        // display all the student profiles
        [self displayAccounts:_currentAccountsPage];
    }
    return self;
}

// function called by pressing HOME button to return to main menu
- (void)goHome:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MenuLayer scene]]];
}

// display all the students profile which is either pulled from the database or the student itself
- (void)displayAccounts:(int)page {
    
    // create the selected avatar frame
    _selectedAvatarBorder = [CCSprite spriteWithFile:@"Selected-Portrait.png"];
    _selectedAvatarBorder.visible = false;
    //_selectedAvatarBorder.tag = 1;
    [self addChild:_selectedAvatarBorder];
    

    // Number of results that will be displayed
    int results = 5;
    
    int accountsOnPage = 0;
    if ([self.accounts count] <= results) {
        accountsOnPage = [self.accounts count] - 1;
    }
    else {
        accountsOnPage = results - 1;
        
        // Do not show last page sprite if the current active page is 1
        if (page != 1)
            _lastAccountsPage.visible = true;
        if (page * results < [self.accounts count])
            _nextAccountsPage.visible = true;
    }
    
    // create the account avatars and names
    int i = 0;
    for (Account *account in self.accounts) {
        
        if (i >= (page - 1) * results && i < page * results)
        {
            // Display what type of account it is.
            CCLabelTTF *accountType;
            
            // Determine which string should be displayed based on the account type
            if (account.type == 1)
                accountType = [CCLabelTTF labelWithString:@"Teacher" fontName:@"KBPlanetEarth" fontSize:24];
            else
                accountType = [CCLabelTTF labelWithString:@"Student" fontName:@"KBPlanetEarth" fontSize:24];
            
            // Determine the position dynamicly based on how many objects are present in the array
            accountType.position = ccp(_size.width/2 - accountsOnPage * 70 + i % results * 140, _size.height - 135);
            accountType.tag = 1;
            [self addChild:accountType];
            
            // Add the avatar for a specific account
            [account createAvatar];
            account.avatar.position = ccp(_size.width/2 - accountsOnPage * 70 + i % results * 140, _size.height - 230);
            account.avatar.visible = true;
            [self addChild:account.avatar];
            
            // Create user name under the avatar
            CCLabelTTF *avatarName = [CCLabelTTF labelWithString:account.name fontName:@"KBPlanetEarth" fontSize:24];
            avatarName.position = ccp(_size.width/2 - accountsOnPage * 70 + i % results * 140, _size.height - 330);
            avatarName.tag = 1;
            [self addChild:avatarName];
        }
        i++;
    }}

// dispatcher to catch the touch events
- (void)registerWithTouchDispatcher {
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

// Handles the events that happen when the release occurs at a specific location
- (void)tapReleaseAt:(CGPoint)releaseLocation {
    
    // Checks if one of the accounts has been selected
    for (Account *account in self.accounts) {
        if (account.avatar.visible && CGRectContainsPoint(account.avatar.boundingBox, releaseLocation)) {
            _selectedAccount = account;
        
            // A new student is selected and we must remove the individual statistic from previously selected student.
            [self cleanupStatisticsSprites];
            
            // release all the accounts in the array
            for (Statistics* statistic in self.statistics)
                [statistic release];
            
            // Pull statistics from the database
            self.statistics = [[SOPDatabase database] loadAccountStatistics:_selectedAccount.accountId];
            
            // Display the statistic of a selected account
            [self displayAccountStatistic:_selectedAccount.accountId withPage:1];
            
            // Mke the avatar box visible since we now have a selected account
            if (!_selectedAvatarBorder.visible)
                _selectedAvatarBorder.visible = true;
            
            // Move the border to the new selected avatar
            _selectedAvatarBorder.position = ccp(_selectedAccount.avatar.position.x, _selectedAccount.avatar.position.y);
            break;
        }
    }
    
    // check if the user has pressed the next page sprite.
    if (_nextStatisticsPage.visible && CGRectContainsPoint(_nextStatisticsPage.boundingBox, releaseLocation)) {
        _currentStatisticsPage++;
        
        [self cleanupStatisticsSprites];
        // display the statistic of a selected account
        [self displayAccountStatistic:_selectedAccount.accountId withPage:_currentStatisticsPage];
    }
    
    // check if the user has pressed the last page sprite.
    if (_lastStatisticsPage.visible && CGRectContainsPoint(_lastStatisticsPage.boundingBox, releaseLocation)) {
        
        // The first page is always 1. Make sure that the current page doesn't go out of those bounds
        if (_currentStatisticsPage > 1) {
            _currentStatisticsPage--;
            
            // cleanup all temporary objects before proceeding to the next stage
            [self cleanupStatisticsSprites];
            
            // display the statistic of a selected account
            [self displayAccountStatistic:_selectedAccount.accountId withPage:_currentStatisticsPage];
        }
    }
    
    // check if the user has pressed the next account page sprite.
    if (_nextAccountsPage.visible && CGRectContainsPoint(_nextAccountsPage.boundingBox, releaseLocation)) {
        _currentAccountsPage++;
        
        [self cleanupAccountsSprites];
        [self cleanupStatisticsSprites];
        
        // display the new account page
        [self displayAccounts:_currentAccountsPage];
    }
    
    // check if the user has pressed the last account page sprite.
    if (_lastAccountsPage.visible && CGRectContainsPoint(_lastAccountsPage.boundingBox, releaseLocation)) {
        
        // The first page is always 1. Make sure that the current page doesn't go out of those bounds
        if (_currentAccountsPage > 1) {
            _currentAccountsPage--;
            
            // cleanup all temporary objects before proceeding to the next stage
            [self cleanupAccountsSprites];
            [self cleanupStatisticsSprites];
            
            // display the new account page
            [self displayAccounts:_currentAccountsPage];
        }
    }
}

// event that is called when the touch has ended
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint releaseLocation = [touch locationInView:[touch view]];
    releaseLocation = [[CCDirector sharedDirector] convertToGL:releaseLocation];
    [self tapReleaseAt:releaseLocation];
}

// event that is called when the touch begins
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    return YES;
}

// display account statistic based on the input account id, the starting height and page that is being displayed.
// Each sprite has a special tag which allows us to remove those sprites later if another account or page is selected.
- (void)displayAccountStatistic:(int)accountId withPage:(int)page {
    
    // print 10 results per page
    static int results = 10;
    
    CCLabelTTF *levelCategory = [CCLabelTTF labelWithString:@"Level" fontName:@"KBPlanetEarth" fontSize:24];
    CCLabelTTF *scoreCategory = [CCLabelTTF labelWithString:@"Score" fontName:@"KBPlanetEarth" fontSize:24];
    CCLabelTTF *minTimeCategory = [CCLabelTTF labelWithString:@"Fastest Time" fontName:@"KBPlanetEarth" fontSize:24];
    CCLabelTTF *maxTimeCategory = [CCLabelTTF labelWithString:@"Slowest Time" fontName:@"KBPlanetEarth" fontSize:24];
    levelCategory.position = ccp(_size.width/4, _size.height/3 + 130);
    scoreCategory.position = ccp(_size.width/4 + 100, _size.height/3 + 130);
    minTimeCategory.position = ccp(_size.width/4 + 275, _size.height/3 + 130);
    maxTimeCategory.position = ccp(_size.width/4 + 450, _size.height/3 + 130);
    
    // indicate that these lables might be deleted in the future
    levelCategory.tag = 0;
    scoreCategory.tag = 0;
    minTimeCategory.tag = 0;
    maxTimeCategory.tag = 0;
    [self addChild:levelCategory];
    [self addChild:scoreCategory];
    [self addChild:minTimeCategory];
    [self addChild:maxTimeCategory];
    
    // Occurs when there are more statistics than can be fit per page
    if ([self.statistics count] >= results) {
        
        // Do not show last page sprite if the current active page is 1
        if (page != 1)
            _lastStatisticsPage.visible = true;
        if (page * results < [self.statistics count])
            _nextStatisticsPage.visible = true;
        
        // display of what page it is
        CCLabelTTF *pageLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",page] fontName:@"KBPlanetEarth" fontSize:24];
        pageLabel.position = ccp(_size.width/4 + 275, _size.height/3 - 200);
        pageLabel.tag = 0;
        [self addChild:pageLabel];
    }
    
    int i = 0;
    // loop through the loaded statistics
    for (Statistics *statistic in self.statistics) {
        if (i >= (page - 1) * results && i < page * results) {
            
            CCLabelTTF *level = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",statistic.level] fontName:@"KBPlanetEarth" fontSize:24];
            CCLabelTTF *score = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",statistic.score] fontName:@"KBPlanetEarth" fontSize:24];
            CCLabelTTF *minTime = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%f",statistic.minTime] fontName:@"KBPlanetEarth" fontSize:24];
            CCLabelTTF *maxTime = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%f",statistic.maxTime] fontName:@"KBPlanetEarth" fontSize:24];
            
            level.position = ccp(_size.width/4, (_size.height/3 + 90) - 25 * (i % results));
            score.position = ccp(_size.width/4 + 100, (_size.height/3 + 90) - 25 * (i % results));
            minTime.position = ccp(_size.width/4 + 275, (_size.height/3 + 90) - 25 * (i % results));
            maxTime.position = ccp(_size.width/4 + 450, (_size.height/3 + 90) - 25 * (i % results));
            
            // Label objects with a tag allowing them to be removed from layer in the later stages
            level.tag = 0;
            score.tag = 0;
            minTime.tag = 0;
            maxTime.tag = 0;
            
            [self addChild:level];
            [self addChild:score];
            [self addChild:minTime];
            [self addChild:maxTime];
        }
        i++;
    }
}

// removes all the temporary objects from the scene
- (void)cleanupStatisticsSprites {
    
    // Remove all children that were tagged as 0
    while ([self getChildByTag:0])
        [self removeChildByTag:0 cleanup:true];
    
    _lastStatisticsPage.visible = false;
    _nextStatisticsPage.visible = false;
}

// Removes all the temporary objects from the scene
- (void)cleanupAccountsSprites {
    
    for (Account *account in self.accounts) {
        account.avatar.visible = false;
    }
    
    // Remove all children that were tagged as 1
    while ([self getChildByTag:1]) {
        [self removeChildByTag:1 cleanup:true];
    }
    
    _nextAccountsPage.visible = false;
    _lastAccountsPage.visible = false;
    
    _selectedAvatarBorder.visible = false;
    _selectedAccount = nil;
}

- (void) dealloc {
    
    // Release all the accounts in the array
    for (Account* account in self.accounts)
        [account release];
    
    [self.accounts release];
    
    // Release all the statistics in the array
    for (Statistics *statistic in self.statistics)
        [statistic release];
    
    [self.statistics release];
    
    [super dealloc];
}
@end
