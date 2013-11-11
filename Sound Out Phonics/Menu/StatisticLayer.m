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

// Helper class method that creates a Scene with the StatistcLayer as the only child.
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

// Initialize the instance
- (id)init
{
	// Apple recommends to re-assign "self" with the "super's" return value
	if((self = [super init])) {
        
        CGSize size = [[CCDirector sharedDirector] winSize]; // ask the director for the window size
        
        // Enable touch for this layer
        [self setTouchEnabled:YES];
        
        // Add the background sprite
        CCSprite *background = [CCSprite spriteWithFile:@"mainmenu-no_gradient.png"]; // create and initialize the background sprite (png)
        background.position = ccp(size.width/2, size.height/2); // center background layer
        [self addChild:background];

        
        // Add the back button sprite
        CCSprite *backButton = [CCSprite spriteWithFile:@"mainmenu-logout_icon.png"]; // create and initialize the back button sprite (png)
        backButton.position = ccp(size.width - 180, size.height - size.height + 50);
        [self addChild:backButton];

        
        // Add the back text which will make the user go back to the menu when pressed
        [CCMenuItemFont setFontName:@"KBPlanetEarth"]; // set the default CCMenuItemFont to our custom font, KBPlanetEarth
        [CCMenuItemFont setFontSize:48]; // set the default CCMenuItemFont size
        
        CCMenuItem *itemBack = [CCMenuItemFont itemWithString:@"back" block:^(id sender) {
            
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade
                                                       transitionWithDuration:1.0
                                                       scene:[MenuLayer scene]]];
        }];

        CCMenu *menu = [CCMenu menuWithItems:itemBack, nil];
		[menu setPosition:ccp(size.width - 100, size.height - size.height + 40)];
        
		// Add the menu to the layer
		[self addChild:menu];
        
        
        // Set the account to the logged in account
        _account = [Singleton sharedSingleton].loggedInAccount;
        
        // If account level is Teacher than we need to display all the students statistics otherwise only the currently logged in player
        if (_account.type == 1)
            [self displayStudents];
        else
            [self displayAccountStatistic:_account.accountId withStartingHeight:size.height/2];
    }
    return self;
}


// Display all the students pulled from the database
- (void)displayStudents {
    
    CGSize size = [[CCDirector sharedDirector] winSize]; // ask the director for the window size
    
    // Create the selected avatar frame
    _selectedAvatarBorder = [CCSprite spriteWithFile:@"SelectedPortrait.png"];
    _selectedAvatarBorder.visible = false;
    _selectedAvatarBorder.tag = 1;
    [self addChild:_selectedAvatarBorder];
    
    // Load the accounts from the database
    self.accounts = [[SOPDatabase database] loadAccounts];
    
    // Create the account avatars and names
    // TO-DO: Organize into rows and multiple pages
    int i = 0;
    for (Account *account in self.accounts) {
        
        // Display what type of account it is.
        CCLabelTTF *accountType;
        
        // Determine which string should be displayed based on the account type
        if (account.type == 1)
            accountType = [CCLabelTTF labelWithString:@"Teacher" fontName:@"KBPlanetEarth" fontSize:24];
        else
            accountType = [CCLabelTTF labelWithString:@"Student" fontName:@"KBPlanetEarth" fontSize:24];
        
        accountType.position = ccp(size.width/4 + i*140, size.height-155);
        [self addChild:accountType];
        
        // Add the avatar
        [account createAvatar];
        account.avatar.position = ccp(size.width/4 + i*140, size.height-250);
        [self addChild:account.avatar];
        
        // Create user name under the avatar
        CCLabelTTF *avatarName = [CCLabelTTF labelWithString:account.name fontName:@"KBPlanetEarth" fontSize:24];
        avatarName.position = ccp(size.width/4 + i*140, size.height-350);
        [self addChild:avatarName];
        i++;
    }

}

// Dispatcher to catch the touch events
- (void)registerWithTouchDispatcher {
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

// Handles the events that happen when the release occurs at a specific location
- (void)tapReleaseAt:(CGPoint)releaseLocation {
    
    CGSize size = [[CCDirector sharedDirector] winSize]; // ask the director for the window size
    
    // Checks if one of the accounts has been selected
    for (Account *account in self.accounts) {
        if (CGRectContainsPoint(account.avatar.boundingBox, releaseLocation)) {
            self.selectedAccount = account;
        
            // A new student is selected and we must remove the individual statistic from previously selected student.
            while ([self getChildByTag:0])
                [self removeChildByTag:0 cleanup:true];
            
            // Display the statistic of a selected account
            [self displayAccountStatistic:_selectedAccount.accountId withStartingHeight:size.height/4];
            
            // Make the avatar box visible since we now have a selected account
            if (!_selectedAvatarBorder.visible)
                _selectedAvatarBorder.visible = true;
            
            // Move the border to the new selected avatar
            _selectedAvatarBorder.position = ccp(_selectedAccount.avatar.position.x, _selectedAccount.avatar.position.y);
            break;
        }
    }
}

// Event that is called when the touch has ended
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint releaseLocation = [touch locationInView:[touch view]];
    releaseLocation = [[CCDirector sharedDirector] convertToGL:releaseLocation];
    [self tapReleaseAt:releaseLocation];
}

// Event that is called when the touch begins
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    return YES;
}

// Display account statistic based on the input account id and the starting height. Each sprite has a special tag which indicates allows us to remove
// them later if teacher is selecting multiple student accounts.
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
    
    // 
    levelCategory.tag = 0;
    scoreCategory.tag = 0;
    minTimeCategory.tag = 0;
    maxTimeCategory.tag = 0;
    [self addChild:levelCategory];
    [self addChild:scoreCategory];
    [self addChild:minTimeCategory];
    [self addChild:maxTimeCategory];
    
    // Pull statistics from the database
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
    
    // Release all the accounts in the array
    for (Account* account in self.accounts)
        [account release];
    
    [self.accounts release];
    [self.selectedAccount release];
    [super dealloc];
}
@end
