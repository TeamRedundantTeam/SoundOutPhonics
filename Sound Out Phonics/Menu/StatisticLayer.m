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
        CCSprite *background = [CCSprite spriteWithFile:@"Background-No-Gradient.png"]; // create and initialize the background sprite (png)
        background.position = ccp(size.width/2, size.height/2); // center background layer
        [self addChild:background];

        
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
        _account = [Singleton sharedSingleton].loggedInAccount;
        
        // if account level is Teacher than we need to display all the students statistics otherwise only the currently logged in player
        if (_account.type == 1)
            [self displayStudents];
        else
            [self displayAccountStatistic:_account.accountId withStartingHeight:size.height/2];
    }
    return self;
}


// display all the students pulled from the database
- (void)displayStudents {
    
    CGSize size = [[CCDirector sharedDirector] winSize]; // ask the director for the window size
    
    // create the selected avatar frame
    _selectedAvatarBorder = [CCSprite spriteWithFile:@"Selected-Portrait.png"];
    _selectedAvatarBorder.visible = false;
    _selectedAvatarBorder.tag = 1;
    [self addChild:_selectedAvatarBorder];
    
    // load the accounts from the database
    self.accounts = [[SOPDatabase database] loadAccounts];
    
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
        
        accountType.position = ccp(size.width/4 + i*140, size.height-155);
        [self addChild:accountType];
        
        // add the avatar
        [account createAvatar];
        account.avatar.position = ccp(size.width/4 + i*140, size.height-250);
        [self addChild:account.avatar];
        
        // create user name under the avatar
        CCLabelTTF *avatarName = [CCLabelTTF labelWithString:account.name fontName:@"KBPlanetEarth" fontSize:24];
        avatarName.position = ccp(size.width/4 + i*140, size.height-350);
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
            while ([self getChildByTag:0])
                [self removeChildByTag:0 cleanup:true];
            
            // display the statistic of a selected account
            [self displayAccountStatistic:_selectedAccount.accountId withStartingHeight:size.height/4];
            
            // make the avatar box visible since we now have a selected account
            if (!_selectedAvatarBorder.visible)
                _selectedAvatarBorder.visible = true;
            
            // move the border to the new selected avatar
            _selectedAvatarBorder.position = ccp(_selectedAccount.avatar.position.x, _selectedAccount.avatar.position.y);
            break;
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

// display account statistic based on the input account id and the starting height. Each sprite has a special tag which indicates allows us to remove them later if teacher is selecting multiple student accounts.

- (void)displayAccountStatistic:(int)accountId withStartingHeight:(int)height{
    
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
    
    // pull statistics from the database
    NSArray *statistics = [[SOPDatabase database] loadAccountStatistics:accountId];
    
    int i = 0;
    for (Statistics *statistic in statistics) {
        CCLabelTTF *level = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",statistic.level] fontName:@"KBPlanetEarth" fontSize:24];
        CCLabelTTF *score = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",statistic.score] fontName:@"KBPlanetEarth" fontSize:24];
        CCLabelTTF *minTime = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%f",statistic.minTime] fontName:@"KBPlanetEarth" fontSize:24];
        CCLabelTTF *maxTime = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%f",statistic.maxTime] fontName:@"KBPlanetEarth" fontSize:24];
        level.position = ccp(size.width/4, (height + 100) - 25 * i);
        score.position = ccp(size.width/4 + 100, (height + 100) - 25 * i);
        minTime.position = ccp(size.width/4 + 275, (height + 100) - 25 * i);
        maxTime.position = ccp(size.width/4 + 450, (height + 100) - 25* i);
        level.tag = 0;
        score.tag = 0;
        minTime.tag = 0;
        maxTime.tag = 0;
        [self addChild:level];
        [self addChild:score];
        [self addChild:minTime];
        [self addChild:maxTime];
        i++;
    }
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
