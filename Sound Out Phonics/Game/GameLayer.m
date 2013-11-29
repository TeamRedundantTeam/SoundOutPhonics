//
//  GameBoardLayer.m
//  Sound Out Phonics
//
//  Purpose: This is the main game class scene and layer that handles all the game
//           logic, displays sprites and performs touch events

//  History: History of the file can be found here:
//           Version 0.1 - 0.5: https://github.com/TeamRedundantTeam/SoundOutPhonics/commits/master/Sound%20Out%20Phonics/Game/GameBoardLayer.m
//           Version 0.6 + : https://github.com/TeamRedundantTeam/SoundOutPhonics/commits/master/Sound%20Out%20Phonics/Game/GameLayer.m
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
//  Created on 2013-10-23.
//  Copyright (c) 2013 Team Redundant Team. All rights reserved.
//

// import the interfaces
#import "GameLayer.h"

#pragma mark - GameLayer

// GameLayer implementation
@implementation GameLayer

// Returns a CCScene that contains the GameLayer as the only child and takes paramater level which has information about the level and number of tries the user attempted to play this level. The attempts are used when the player decides to refresh the level before completing it.
+ (CCScene *)sceneWithLevel:(Level *)level withAttempts:(int)attempts{
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer nodeWithParamaters:level withAttempts:attempts];
	
	// add layer as a child to scene
	[scene addChild:layer];
	
	// return the scene
	return scene;
}

// creates the node of the level with the paramaters and then calles initWithParamaters to initialize the layer
+ (id)nodeWithParamaters:(Level *)level withAttempts:(int)attempts {
    return [[[self alloc] initWithLevel:level withAttempts:attempts] autorelease];
}

// initializes the level with provided level infromation and number of times the person has attempted to do this level
- (id)initWithLevel:(Level *)level withAttempts:(int)attempts {
    
    if ((self = [super init])) {
        
        // enable touch for this layer
        [self setTouchEnabled:YES];
        
        // get the screen size of the device
        _size = [[CCDirector sharedDirector] winSize];
        
        // create and initialize a background
        CCSprite *background = [CCSprite spriteWithFile:@"Default-Background.png"];
        
        background.position = ccp(_size.width/2, _size.height/2);
        
		// add the background as a child to this layer
        [self addChild: background];
        
        // information about the current level
        _level = level;
        
        // add picture sprite object
        [_level createSprite];
        _level.sprite.position = ccp(_size.width/5.5, _size.height - _size.height/4.5);
        [self addChild:_level.sprite];
        
        // create the graphyme list in randomized order
        NSArray* graphemeList = [self generateGraphemeList:_level.name withGraphemes:_level.graphemes];
        
        // How many reults allowed per page
        int results = 7;
        
        // Check that the grapheme number does not exceed the maximum result number. Otherwise the graphemes will be outside of the viewable area.
        if (graphemeList.count < results) {
        
            // create Slots Array
            _slots = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < graphemeList.count; i++) {
            
                // Dynamicly determine the position of the x-coordinate based on how many graphemes are present
                CGFloat xpos = _size.width/2 - (graphemeList.count - 1 ) * 70 + (i % results) * 140;
                CGFloat ypos = _size.height/4;
            
                // create an individual slot
                Slot *slot = [[Slot alloc] initWithPosition:ccp(xpos, ypos)];
                [_slots addObject:slot];
                [self addChild:slot];
                [slot release];
            }
    
        
            // create Graphemes
            _graphemes = [[NSMutableArray alloc] init];
            for (int i = 0; i < graphemeList.count; i++) {
            
                // create Labels
                CCLabelTTF *grapheme = [CCLabelTTF labelWithString:[graphemeList objectAtIndex:i]
                                    fontName:@"KBPlanetEarth" fontSize:64];
            
                CGFloat xpos = _size.width/2 + 140 - (graphemeList.count - 1 ) * 32 + i * 64;
                CGFloat ypos = _size.height - _size.height/4.5;
                grapheme.position = ccp(xpos, ypos);
            
                [self addChild:grapheme];
                [_graphemes addObject:grapheme];
            }
        }
        else
            NSLog(@"Error could not add that many graphemes to the screen at this time. The maximum number of graphemes allowed on the screen is %d",results);
        
        // add Submit Button
        _submitButton = [[StateButton alloc] initWithFile:@"Submit-Button.png" withPosition:ccp(_size.width - _size.width/9, _size.height/15)];
        [_submitButton setState:false];
        [self addChild:_submitButton];
        
        _attempts = attempts;
        NSString *score = [NSString stringWithFormat:@"Score: %d", [self generateScore:_attempts]];
        _levelScore = [CCLabelTTF labelWithString:score fontName:@"KBPlanetEarth" fontSize:24];
        _levelScore.position = ccp(_size.width/2, _size.height - 24);
        [self addChild:_levelScore];
        
        _resetButton = [CCSprite spriteWithFile:@"Reset-Button.png"];
        _resetButton.position = ccp(_size.width - 50, _size.height - 50);
        [self addChild:_resetButton];
        
        // initialize the schedular to calculate time since the level has started
        [self schedule: @selector(tick:)];
        
        // play level name at the start
        [[TextToSpeech tts] playWord:_level.name];
    }
    return self;
}

// converts levelGraphemes into an array and randomizes the graphemes in that array
- (NSArray*)generateGraphemeList:(NSString*)levelName withGraphemes:(NSString*)levelGraphemes{
    
    NSArray* tempList = [levelGraphemes componentsSeparatedByString:@"-"];
    NSMutableArray* tempMutableList = [NSMutableArray arrayWithArray:tempList];
    
    int j;
    
    // randomize the list using Fisher and Yates' algorithm
    for (int i = tempMutableList.count-1; i > 0; i--) {
        j = arc4random() % (i+1);
        [tempMutableList exchangeObjectAtIndex:i withObjectAtIndex:j];
    }
    
    // create an array with the randomized mutable array
    NSArray* graphemeList = [NSArray arrayWithArray:tempMutableList];
    
    NSString* temp = @"";
    // create the string from the new randomized array
    for (int i = 0; i < tempMutableList.count; i++) {
        temp = [temp stringByAppendingString:[tempMutableList objectAtIndex:i]];
    }
    
    // recursively check that the randomized array is not in the proper order
    if ([temp isEqualToString:levelName] && graphemeList.count > 1)
        graphemeList = [self generateGraphemeList:levelName withGraphemes:levelGraphemes];
    
    return graphemeList;
}

// dispatcher to catch the touch events
- (void)registerWithTouchDispatcher {
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

// handling of the on tap down at a specific location that will do various functionality depending on which sprite is being touched
- (void)tapDownAt:(CGPoint)touchLocation {
    
    CCLabelTTF *newGrapheme = nil;
    
    // checks if a grapheme has been selected
    for (CCLabelTTF *grapheme in _graphemes) {
        if (CGRectContainsPoint(grapheme.boundingBox, touchLocation)) {
            newGrapheme = grapheme;
            break;
        }
    }
    
    // if a new grapheme has been selected then begin rotating it from side to side
    if (newGrapheme != _selectedGrapheme) {
        [_selectedGrapheme stopAllActions];
        [_selectedGrapheme runAction:[CCRotateTo actionWithDuration:0.1 angle:0]];
        CCRotateTo *rotLeft = [CCRotateBy actionWithDuration:0.1 angle:-4.0];
        CCRotateTo *rotCenter = [CCRotateBy actionWithDuration:0.1 angle:0.0];
        CCRotateTo *rotRight = [CCRotateBy actionWithDuration:0.1 angle:4.0];
        CCSequence *rotSeq = [CCSequence actions:rotLeft, rotCenter, rotRight, rotCenter, nil];
        [newGrapheme runAction:[CCRepeatForever actionWithAction:rotSeq]];
        _selectedGrapheme = newGrapheme;
    }
    
    // record the selected graphemes last touch location location
    if (_selectedGrapheme)
        _selectedGraphemeLastPosition = touchLocation;
    
    // if the picture is selected the level name will be played out
    if (_selectedGrapheme == nil && CGRectContainsPoint(_level.sprite.boundingBox, touchLocation)) {
        [[TextToSpeech tts] playWord:_level.name];
    }
    
    // if submit button is selected and it is enabled
    if ([_submitButton state] && CGRectContainsPoint(_submitButton.boundingBox, touchLocation)) {
        [self executeSubmitButton];
    }
}

// executes when the SubmitButton is pressed
- (void)executeSubmitButton {
    NSString *userInput = @"";
    for (Slot *slot in _slots) {
        userInput = [userInput stringByAppendingString:[slot.grapheme string]];
    }
    
    // the user was able to put the the right graphemes into the slot. Create Victory Screen scene
    if ([userInput isEqualToString:_level.name]) {

        // play the right spelled out word to the player
        [[TextToSpeech tts] playWord:userInput];

        // sprite object must be removed from the selected level since we are sharing this perticular level between layers and CCSprite can only be attached to one scene at a time. We are not removing the child from the layer because it makes the sprite dissapear before the transition ends. This also assures that each sprite is assign to one scene at a time.
        [_level removeSprite];
        
        // save the statistics after the player has won the game
        [self saveStatistics];

        // background color. To-Do change the color to a more nicer color
        ccColor4B c = {100,100,0,100};
        
        // create the victory scene on top of this scene
        NSString *score = [NSString stringWithFormat:@"%d", [self generateScore:_attempts]];
        VictoryLayer * vl = [[[VictoryLayer alloc] initWithColor:c withScore:score] autorelease];
        [self.parent addChild:vl z:10];
        [self onExit];
    }
    else {
        // play the wrong spelled out word to the player
        [[TextToSpeech tts] playWord:userInput];
        
        // attempts increase since the player wasn't able to get the word right at this time. Used to decrease the score
        _attempts++;
        
        // the score will change and we need to remove the previous score
        [self removeChild:_levelScore];
        
        // create a new score based on number of attempts
        NSString *score = [NSString stringWithFormat:@"Score: %d", [self generateScore:_attempts]];
        _levelScore = [CCLabelTTF labelWithString:score fontName:@"KBPlanetEarth" fontSize:24];
        _levelScore.position = ccp(_size.width/2, _size.height - 24);
        [self addChild:_levelScore];
        
        
        // background color. Transparent red
        ccColor4B c = {225, 0, 0, 150};
        
        // create the losing layer with a color scene on top of the current layer
        _wrongAnswerLayer = [[CCLayerColor alloc] initWithColor:c];
        [self addChild:_wrongAnswerLayer];
        
        // Disable the touch while the the wrong answer layer is active to prevent the user from removing objects from slots
        // or pressing submit button again
        [self setTouchEnabled:NO];
        [self scheduleOnce:@selector(removeLayer) delay:1];
    }
}

// occurs when the wrongAnswerLayer is being removed from the scene
- (void)removeLayer {
    [self removeChild:_wrongAnswerLayer];
    [_wrongAnswerLayer release];
    // Re-enable the touch
    [self setTouchEnabled:YES];
}

// saves the statistics at the end of the level into already existing statistic or creates a new one
- (void)saveStatistics {
    
    // get the currently logged in account
    Account *account = [Singleton sharedSingleton].loggedInAccount;
    
    // get the accounts statistics
    NSArray *statistics = account.statistics;
    
    // used to determine if we found a statistic for this specific level
    Statistics *foundStatistic = nil;
    
    // determine if there is a statistic for this level
    for (Statistics *statistic in statistics) {
        if (statistic.level == _level.levelId) {
            foundStatistic = statistic;
            break;
        }
    }
    
    // determine how much score should be given for this level
    int score = [self generateScore:_attempts];
    
    // there already exists statistic for this level
    if (foundStatistic) {
        
        // add new score if it is better than the previous one
        if (foundStatistic.score < score) {
            foundStatistic.score = score;
        }
        
        // add new minimum completion time if it's better than the previous time
        if (foundStatistic.minTime > _elapsedTime) {
            foundStatistic.minTime = _elapsedTime;
        }
        
        // add new maximum completion time if it's better than the previous time
        if (foundStatistic.maxTime < _elapsedTime) {
            foundStatistic.maxTime = _elapsedTime;
        }
        
        // update the statistic in the database based on the logged in account, current level and the account's statistic for this level
        [[SOPDatabase database]updateStatistic:account.accountId withLevel:_level.levelId withStatistic:foundStatistic];
    }
    else {
        
        // create new statistic in the database
        [[SOPDatabase database] createStatistic:account.accountId withLevel:_level.levelId withScore:score witTime:_elapsedTime];
        
        // update the accounts statistic after we insert the new statistic
        account.statistics = [[SOPDatabase database] loadAccountStatistics:account.accountId];
    }
}

// handles the events that happen when the release occurs at a specific location
- (void)tapReleaseAt:(CGPoint)releaseLocation {
    
    // stop all the action that the selected label is performing and deselect it.
    if (_selectedGrapheme) {
        [_selectedGrapheme stopAllActions];
        [_selectedGrapheme runAction:[CCRotateTo actionWithDuration:0.1 angle:0]];
        [self placeGrapheme:releaseLocation];
        [self checkSubmitButton];
    }
    
    if (CGRectContainsPoint(_resetButton.boundingBox, releaseLocation)) {
        int i = 0;
        
        // put all graphemes in the original position
        for (CCSprite *grapheme in _graphemes) {
            grapheme.position = ccp(_size.width/2 + i * _size.width/10, _size.height - _size.height/4.5);
            i++;
        }
        
        // remove all graphemes from the slots
        for (Slot *slot in _slots) {
            slot.grapheme = nil;
            [_submitButton setState:false];
        }
        
        _attempts++;
        
        // remove Previous Score
        [self removeChild:_levelScore];
        
        // create a new score based on number of attempts
        NSString *score = [NSString stringWithFormat:@"Score: %d", [self generateScore:_attempts]];
        _levelScore = [CCLabelTTF labelWithString:score fontName:@"KBPlanetEarth" fontSize:24];
        _levelScore.position = ccp(_size.width/2, _size.height - 24);
        [self addChild:_levelScore];
    }

}

// event that is called when the touch begins
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    // gathers the locaiton of the touch and sends it onto the tapDownAt method
    CGPoint touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    [self tapDownAt:touchLocation];
    return YES;
}


// event that is called when the touch has ended
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint releaseLocation = [touch locationInView:[touch view]];
    releaseLocation = [[CCDirector sharedDirector] convertToGL:releaseLocation];
    [self tapReleaseAt:releaseLocation];
}

// translate the selected label to the new location
- (void)panForTranslation:(CGPoint)translation {
    if (_selectedGrapheme) {
        CGPoint newPos = ccpAdd(_selectedGrapheme.position, translation);
        _selectedGrapheme.position = newPos;
    }
}

// event that occurs when the touch is moved from one location to another
- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
    oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
    oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
    
    CGPoint translation = ccpSub(touchLocation, oldTouchLocation);
    [self panForTranslation:translation];
}

// checks if the submit button should be enabled or not
// only enabled the button when each of the slots are filled with a graphemes, otherwise the button is disabled
- (void)checkSubmitButton {
    bool filledSlots = true;
    for (Slot *slot in _slots) {
        if (slot.grapheme == nil) {
            filledSlots = false;
            [_submitButton setState:false];
        }
    }
    if (filledSlots == true)
        [_submitButton setState:true];
}

// a helper function that determines if a object can be placed into the slot
- (void)placeGrapheme:(CGPoint)releaseLocation {
    Slot *destinationSlot = nil;
    Slot *sourceSlot = nil;
    
    for (Slot *s in _slots)
        if (CGRectContainsPoint(s.boundingBox, releaseLocation)) {
            destinationSlot = s;
            // don't look at the other slots
            break;
        }
    
    for (Slot *s in _slots)
        if (s.grapheme == _selectedGrapheme) {
            sourceSlot = s;
            break;
        }
    
    // grapheme is being placed over a slot
    if (destinationSlot!=nil) {
        // destination doesn't have a grapheme on it
        if (destinationSlot.grapheme == nil) {
            destinationSlot.grapheme = _selectedGrapheme;
            destinationSlot.scale = 0.8;
            _selectedGrapheme.position = ccp(destinationSlot.position.x, destinationSlot.position.y);
            

            // if we came from a slot remove our grapheme
            if (sourceSlot != nil) {
                sourceSlot.grapheme = nil;
                sourceSlot.scale = 1;
            }
 
        } else { // graphyme is being placed on a full slot
            if (sourceSlot.grapheme == _selectedGrapheme) {
                _selectedGrapheme.position = ccp(sourceSlot.position.x, sourceSlot.position.y);
            } else {
                _selectedGrapheme.position = _selectedGraphemeLastPosition;
            }
        }
    } else {
        // graphyme came from another slot
        if (sourceSlot != nil) {
            sourceSlot.grapheme = nil;
            sourceSlot.scale = 1.0;
        }
        
        _selectedGrapheme.position = releaseLocation;
    }
    _selectedGrapheme = nil;
}

// generate the amount of score given for the level based on number of attempts
- (int)generateScore:(int)attempts {
    switch (attempts) {
        case 0:
            return 100;
        case 1:
            return 10;
        default:
            return 1;
    }
}

// Used to determine for how long the player has been playing this level
-(void)tick:(ccTime)dt {
    _elapsedTime += dt;
}

// on "dealloc" you need to release all your retained objects
- (void)dealloc {
    [_slots release];
    [_submitButton release];
    [_graphemes release];
	[super dealloc];
}
@end

