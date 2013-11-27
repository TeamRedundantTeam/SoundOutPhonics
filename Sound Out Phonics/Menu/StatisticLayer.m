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
@synthesize selectedAccount = _selectedAccount;
@synthesize loggedInAccount = _loggedInAccount;

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
        
        CGSize size = [[CCDirector sharedDirector] winSize]; // ask the director for the window size
        
        // enable touch for this layer
        [self setTouchEnabled:YES];
        
        // add the background sprite
        CCSprite *background = [CCSprite spriteWithFile:@"Default-Background.png"]; // create and initialize the background sprite (png)
        background.position = ccp(size.width/2, size.height/2); // center background layer
        [self addChild:background];

        // title name
        CCLabelTTF *titleName = [CCLabelTTF labelWithString:@"Statistics" fontName:@"KBPlanetEarth" fontSize:48];
        titleName.position = ccp(size.width/2, size.height-75);
        [self addChild:titleName];
        
        // create and initialize the back button sprite (png)
        CCSprite *backButton = [CCSprite spriteWithFile:@"Back-Icon.png"];
        backButton.position = ccp(size.width - 180, size.height - size.height + 50);
        [self addChild:backButton];

        
        // add the back text which will make the user go back to the menu when pressed
        [CCMenuItemFont setFontName:@"KBPlanetEarth"]; // set the default CCMenuItemFont to our custom font, KBPlanetEarth
        [CCMenuItemFont setFontSize:48]; // set the default CCMenuItemFont size
        
        CCMenuItem *itemBack = [CCMenuItemFont itemWithString:@"back" block:^(id sender) {
            
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade
                                                       transitionWithDuration:1.0
                                                       scene:[MenuLayer scene]]];
        }];

        CCMenu *menu = [CCMenu menuWithItems:itemBack, nil];
		[menu setPosition:ccp(size.width - 100, size.height - size.height + 40)];
        
		// add the menu to the layer
		[self addChild:menu];
        
        // set the account to the logged in account
        self.loggedInAccount = [Singleton sharedSingleton].loggedInAccount;
        
        // display all the student profiles
        [self displayStudents];
        
        // start from the first page
        _currentPage = 1;

    }
    return self;
}


// display all the students profile which is either pulled from the database or the student itself
- (void)displayStudents {
    
    CGSize size = [[CCDirector sharedDirector] winSize]; // ask the director for the window size
    
    // create the selected avatar frame
    _selectedAvatarBorder = [CCSprite spriteWithFile:@"Selected-Portrait.png"];
    _selectedAvatarBorder.visible = false;
    _selectedAvatarBorder.tag = 1;
    [self addChild:_selectedAvatarBorder];
    
    if (self.loggedInAccount.type == 1)
        // load the accounts from the database
        self.accounts = [[SOPDatabase database] loadAccounts];

    else
        // Only add itself to the array
        self.accounts = [NSArray arrayWithObject:self.loggedInAccount];
    
    // create the account avatars and names
    // TO-DO: Organize into rows and multiple pages
    
    int i = 0;
    for (Account *account in self.accounts) {
        
        // display what type of account it is.
        CCLabelTTF *accountType;
        
        // determine which string should be displayed based on the account type
        if (account.type == 1)
            accountType = [CCLabelTTF labelWithString:@"Teacher" fontName:@"KBPlanetEarth" fontSize:24];
        else
            accountType = [CCLabelTTF labelWithString:@"Student" fontName:@"KBPlanetEarth" fontSize:24];

        accountType.position = ccp(size.width/4 + i*140, size.height-115);
        [self addChild:accountType];
        
        // add the avatar
        [account createAvatar];
        account.avatar.position = ccp(size.width/4 + i*140, size.height-200);
        [self addChild:account.avatar];
        
        // create user name under the avatar
        CCLabelTTF *avatarName = [CCLabelTTF labelWithString:account.name fontName:@"KBPlanetEarth" fontSize:24];
        avatarName.position = ccp(size.width/4 + i*140, size.height-300);
        [self addChild:avatarName];
        i++;
    }
}

// dispatcher to catch the touch events
- (void)registerWithTouchDispatcher {
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

// handles the events that happen when the release occurs at a specific location
- (void)tapReleaseAt:(CGPoint)releaseLocation {
    
    CGSize size = [[CCDirector sharedDirector] winSize]; // ask the director for the window size
    
    // checks if one of the accounts has been selected
    for (Account *account in self.accounts) {
        if (CGRectContainsPoint(account.avatar.boundingBox, releaseLocation)) {
            self.selectedAccount = account;
        
            // a new student is selected and we must remove the individual statistic from previously selected student.
            [self cleanup];
            
            // display the statistic of a selected account
            [self displayAccountStatistic:_selectedAccount.accountId withStartingHeight:size.height/3 withPage:1];
            
            // make the avatar box visible since we now have a selected account
            if (!_selectedAvatarBorder.visible)
                _selectedAvatarBorder.visible = true;
            
            // move the border to the new selected avatar
            _selectedAvatarBorder.position = ccp(_selectedAccount.avatar.position.x, _selectedAccount.avatar.position.y);
            break;
        }
    }
    
    // check if the user has pressed the next page sprite.
    if (_nextPage && CGRectContainsPoint(_nextPage.boundingBox, releaseLocation)) {
        _currentPage++;
        
        [self cleanup];
        // display the statistic of a selected account
        [self displayAccountStatistic:_selectedAccount.accountId withStartingHeight:size.height/3 withPage:_currentPage];
    }
    
    // check if the user has pressed the last page sprite.
    if (_lastPage && CGRectContainsPoint(_lastPage.boundingBox, releaseLocation)) {
        
        // The first page is always 1. Make sure that the current page doesn't go out of those bounds
        if (_currentPage > 1) {
            _currentPage--;
            
            // cleanup all temporary objects before proceeding to the next stage
            [self cleanup];
            
            // display the statistic of a selected account
            [self displayAccountStatistic:_selectedAccount.accountId withStartingHeight:size.height/3 withPage:_currentPage];
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
- (void)displayAccountStatistic:(int)accountId withStartingHeight:(int)height withPage:(int)page {
    
    // print 10 results per page
    static int results = 10;
    
    CGSize size = [[CCDirector sharedDirector] winSize]; // ask the director for the window size
    
    CCLabelTTF *levelCategory = [CCLabelTTF labelWithString:@"Level" fontName:@"KBPlanetEarth" fontSize:24];
    CCLabelTTF *scoreCategory = [CCLabelTTF labelWithString:@"Score" fontName:@"KBPlanetEarth" fontSize:24];
    CCLabelTTF *minTimeCategory = [CCLabelTTF labelWithString:@"Fastest Time" fontName:@"KBPlanetEarth" fontSize:24];
    CCLabelTTF *maxTimeCategory = [CCLabelTTF labelWithString:@"Slowest Time" fontName:@"KBPlanetEarth" fontSize:24];
    levelCategory.position = ccp(size.width/4, height + 150);
    scoreCategory.position = ccp(size.width/4 + 100, height + 150);
    minTimeCategory.position = ccp(size.width/4 + 275, height + 150);
    maxTimeCategory.position = ccp(size.width/4 + 450, height + 150);
    
    // indicate that these lables might be deleted in the future
    levelCategory.tag = 0;
    scoreCategory.tag = 0;
    minTimeCategory.tag = 0;
    maxTimeCategory.tag = 0;
    [self addChild:levelCategory];
    [self addChild:scoreCategory];
    [self addChild:minTimeCategory];
    [self addChild:maxTimeCategory];
    
    // pull statistics from the database. Better design choice would be to pull statistics only once from the database
    NSArray *statistics = [[SOPDatabase database] loadAccountStatistics:accountId];
    
    // Occurs when there are more statistics than can be fit per page
    if ([statistics count] >= results) {
        // add the next page arrow sprites
        _lastPage = [CCSprite spriteWithFile:@"Arrow.png"]; // create and initialize the arrow
        _lastPage.position = ccp(size.width/4 + 225, size.height/3 - 160);
        _lastPage.tag = 0;
        [self addChild:_lastPage];
        
        // add the last page arrow sprites
        _nextPage = [CCSprite spriteWithFile:@"Arrow.png"]; // create and initialize the arrow
        _nextPage.rotation = 180;
        _nextPage.position = ccp(size.width/4 + 325, size.height/3 - 160);
        _nextPage.tag = 0;
        [self addChild:_nextPage];
        
        // display of what page it is
        CCLabelTTF *pageLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",page] fontName:@"KBPlanetEarth" fontSize:24];
        pageLabel.position = ccp(size.width/4 + 275, size.height/3 - 160);
        pageLabel.tag = 0;
        [self addChild:pageLabel];
    }
    
    int i = 0;
    // loop through the loaded statistics
    for (Statistics *statistic in statistics) {
        if (i >= (page - 1) * results && i < page * results)
        {
            CCLabelTTF *level = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",statistic.level] fontName:@"KBPlanetEarth" fontSize:24];
            CCLabelTTF *score = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",statistic.score] fontName:@"KBPlanetEarth" fontSize:24];
            CCLabelTTF *minTime = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%f",statistic.minTime] fontName:@"KBPlanetEarth" fontSize:24];
            CCLabelTTF *maxTime = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%f",statistic.maxTime] fontName:@"KBPlanetEarth" fontSize:24];
            level.position = ccp(size.width/4, (height + 100) - 25 * (i % results));
            score.position = ccp(size.width/4 + 100, (height + 100) - 25 * (i % results));
            minTime.position = ccp(size.width/4 + 275, (height + 100) - 25 * (i % results));
            maxTime.position = ccp(size.width/4 + 450, (height + 100) - 25* (i % results));
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
- (void) cleanup {
    
    // Remove all children that were tagged as 0
    while ([self getChildByTag:0])
        [self removeChildByTag:0 cleanup:true];
    
    _nextPage = nil;
    _lastPage = nil;
}

- (void) dealloc {
    
    // release all the accounts in the array
    for (Account* account in self.accounts)
        [account release];
    
    [self.accounts release];
    [self.selectedAccount release];
    [super dealloc];
}
@end
