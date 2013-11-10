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

// Import the interfaces
#import "GameLayer.h"


#pragma mark - GameLayer

// GameLayer implementation
@implementation GameLayer

// Returns a CCScene that contains the GameBoard as the only child and takes paramater level which has information about the level
// and number of tries the user attempted to play this level. The attempts are used when the player decides to refresh the level before
// completing it.
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

// Creates the node of the level with the paramaters and then calles initWithParamaters to initialize the layer
+ (id)nodeWithParamaters:(Level *)level withAttempts:(int)attempts {
    return [[[self alloc] initWithLevel:level withAttempts:attempts] autorelease];
}

// Initializes the level with provided level infromation and number of times the person has attempted to do this level
- (id)initWithLevel:(Level *)level withAttempts:attempts {
    
    if ((self = [super init])) {
        
        // Enable touch for this layer
        [self setTouchEnabled:YES];
        
        // Get the screen size of the device
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        
        // Information about the current level
        _level = level;
        
        // Add picture sprite object
        [_level createSprite];
        _level.sprite.position = ccp(screenSize.width/5.5, screenSize.height - screenSize.height/4.5);
        [self addChild:_level.sprite];

        // Add text to speech object
        _tts = [[TextToSpeech alloc] init];
        
        // Create the graphyme list in randomized order
        NSArray* graphemeList = [self generateGraphemeList:_level.name withGraphemes:_level.graphemes];
        
        // Create Slots Array
        _slots = [[NSMutableArray alloc] init];
        for (int i = 0; i < graphemeList.count; i++) {
            // Create an individual slot
            Slot *slot = [[Slot alloc] initWithPosition:ccp(screenSize.width/4 + i*225, screenSize.height/4)];
            [_slots addObject:slot];
            [self addChild:slot];
            [slot release];
        }
        
        // Add Submit Button
        _submitButton = [[SubmitButton alloc] initWithPosition:ccp(screenSize.width - screenSize.width/9, screenSize.height/15)];
        [_submitButton setState:false];
        [self addChild:_submitButton];
        
        // Create Graphemes
        _graphemes = [[NSMutableArray alloc] init];
        for (int i = 0; i < graphemeList.count; i++) {
            
            // Create Labels
            CCLabelTTF *grapheme = [CCLabelTTF labelWithString:[graphemeList objectAtIndex:i]
                                    fontName:@"Marker Felt" fontSize:64];
            grapheme.position = ccp(screenSize.width/2 + i*screenSize.width/10, screenSize.height - screenSize.height/4.5);
            
            [self addChild:grapheme];
            [_graphemes addObject:grapheme];
        }
        
        _attempts = attempts;
        NSString *score = [NSString stringWithFormat:@"Score: %d", [self generateScore:_attempts]];
        _levelScore = [CCLabelTTF labelWithString:score fontName:@"Marker Felt" fontSize:24];
        _levelScore.position = ccp(screenSize.width/2, screenSize.height - 24);
        [self addChild:_levelScore];
        
        [self schedule: @selector(tick:)];
    }
    return self;
}

// Converts levelGraphemes into an array and randomizes the graphemes in that array
- (NSArray*)generateGraphemeList:(NSString*)levelName withGraphemes:(NSString*)levelGraphemes{
    
    NSArray* tempList = [levelGraphemes componentsSeparatedByString:@"-"];
    NSMutableArray* tempMutableList = [NSMutableArray arrayWithArray:tempList];
    
    int j;
    
    // Randomize the list using Fisher and Yates' algorithm
    for (int i = tempMutableList.count-1; i > 0; i--) {
        j = arc4random() % (i+1);
        [tempMutableList exchangeObjectAtIndex:i withObjectAtIndex:j];
    }
    
    // Create an array with the randomized mutable array
    NSArray* graphemeList = [NSArray arrayWithArray:tempMutableList];
    
    NSString* temp = @"";
    // Create the string from the new randomized array
    for (int i = 0; i < tempMutableList.count; i++) {
        temp = [temp stringByAppendingString:[tempMutableList objectAtIndex:i]];
    }
    
    // Recursively check that the randomized array is not in the proper order
    if ([temp isEqualToString:levelName] && graphemeList.count > 1)
        graphemeList = [self generateGraphemeList:levelName withGraphemes:levelGraphemes];
    
    return graphemeList;
}

// Dispatcher to catch the touch events
- (void)registerWithTouchDispatcher {
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

// Handling of the on tap down at a specific location that will do various functionality depending on which sprite is being touched
- (void)tapDownAt:(CGPoint)touchLocation {
    
    CCLabelTTF *newGrapheme = nil;
    
    // Checks if a grapheme has been selected
    for (CCLabelTTF *grapheme in _graphemes) {
        if (CGRectContainsPoint(grapheme.boundingBox, touchLocation)) {
            newGrapheme = grapheme;
            break;
        }
    }
    
    // If a new grapheme has been selected then begin rotating it from side to side
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
    
    // Record the selected graphemes last touch location location
    if (_selectedGrapheme)
        _selectedGraphemeLastPosition = touchLocation;
    
    // If the picture is selected the level name will be played out
    if (_selectedGrapheme == nil && CGRectContainsPoint(_level.sprite.boundingBox, touchLocation)) {
        [_tts playWord:_level.name];
    }
    
    // If submit button is selected and it is enabled
    if ([_submitButton state] && CGRectContainsPoint(_submitButton.boundingBox, touchLocation)) {
        [self executeSubmitButton];
    }
}

// Executes when the SubmitButton is pressed
- (void)executeSubmitButton {
    NSString *userInput = @"";
    for (Slot *slot in _slots) {
        userInput = [userInput stringByAppendingString:[slot.grapheme string]];
    }
    
    // The user was able to put the the right graphemes into the slot. Create Victory Screen scene
    if ([userInput isEqualToString:_level.name]) {

        
        // Sprite object must be removed from the selected level since we are sharing this perticular level between layers and
        // CCSprite can only be attached to one scene at a time. We are not removing the child from the layer because it makes the sprite dissapear
        // before the transition ends. This also assures that each sprite is assign to one scene at a time.
        [_level removeSprite];
        
        // Save the statistics after the player has won the game
        [self saveStatistics];

        // Background color. To-Do change the color to a more nicer color
        ccColor4B c = {100,100,0,100};
        
        // Create the victory scene on top of this scene
        VictoryLayer * vl = [[[VictoryLayer alloc] initWithColor:c] autorelease];
        [self.parent addChild:vl z:10];
        [self onExit];
    }
    else {
        // Play the wrong spelled out word to the player
        [_tts playWord:userInput];
        
        // Attempts increase since the player wasn't able to get the word right at this time. Used to decrease the score
        _attempts++;
        
        // Get the screen size of the device
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        
        // The score will change and we need to remove the previous score
        [self removeChild:_levelScore];
        
        // Create a new score based on number of attempts
        NSString *score = [NSString stringWithFormat:@"Score: %d", [self generateScore:_attempts]];
        _levelScore = [CCLabelTTF labelWithString:score fontName:@"Marker Felt" fontSize:24];
        _levelScore.position = ccp(screenSize.width/2, screenSize.height - 24);
        [self addChild:_levelScore];
    }
}

// Saves the statistics at the end of the level into already existing statistic or creates a new one
- (void)saveStatistics {
    
    // Get the currently logged in account
    Account *account = [Singleton sharedSingleton].loggedInAccount;
    
    // Get the accounts statistics
    NSArray *statistics = account.statistics;
    
    // Used to determine if we found a statistic for this specific level
    Statistics *foundStatistic = nil;
    
    // Determine if there is a statistic for this level
    for (Statistics *statistic in statistics) {
        if (statistic.level == _level.levelId) {
            foundStatistic = statistic;
            break;
        }
    }
    
    // Determine how much score should be given for this level
    int score = [self generateScore:_attempts];
    
    // There already exists statistic for this level
    if (foundStatistic) {
        
        // Add new score if it is better than the previous one
        if (foundStatistic.score < score) {
            foundStatistic.score = score;
        }
        
        // Add new minimum completion time if it's better than the previous time
        if (foundStatistic.minTime > _elapsedTime) {
            foundStatistic.minTime = _elapsedTime;
        }
        
        // Add new maximum completion time if it's better than the previous time
        if (foundStatistic.maxTime < _elapsedTime) {
            foundStatistic.maxTime = _elapsedTime;
        }
        
        // Update the statistic in the database based on the logged in account, current level and the account's statistic for this level
        [[SOPDatabase database]updateStatistic:account.accountId withLevel:_level.levelId withStatistic:foundStatistic];
    }
    else {
        
        // Create new statistic in the database
        [[SOPDatabase database] createStatistic:account.accountId withLevel:_level.levelId withScore:score witTime:_elapsedTime];\
        
        // Update the accounts statistic after we insert the new statistic
        account.statistics = [[SOPDatabase database] loadAccountStatistics:account.accountId];
    }
}

// Handles the events that happen when the release occurs at a specific location
- (void)tapReleaseAt:(CGPoint)releaseLocation {
    
    // Stop all the action that the selected label is performing and deselect it.
    if (_selectedGrapheme) {
        [_selectedGrapheme stopAllActions];
        [_selectedGrapheme runAction:[CCRotateTo actionWithDuration:0.1 angle:0]];
        [self placeGrapheme:releaseLocation];
        [self checkSubmitButton];
    }

}
// Event that is called when the touch begins
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    // Gathers the locaiton of the touch and sends it onto the tapDownAt method
    CGPoint touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    [self tapDownAt:touchLocation];
    return YES;
}


// Event that is called when the touch has ended
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint releaseLocation = [touch locationInView:[touch view]];
    releaseLocation = [[CCDirector sharedDirector] convertToGL:releaseLocation];
    [self tapReleaseAt:releaseLocation];
}

// Translate the selected label to the new location
- (void)panForTranslation:(CGPoint)translation {
    if (_selectedGrapheme) {
        CGPoint newPos = ccpAdd(_selectedGrapheme.position, translation);
        _selectedGrapheme.position = newPos;
    }
}

// Event that occurs when the touch is moved from one location to another
- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
    oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
    oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
    
    CGPoint translation = ccpSub(touchLocation, oldTouchLocation);
    [self panForTranslation:translation];
}

// Checks if the submit button should be enabled or not
// Only enabled the button when each of the slots are filled with a graphemes, otherwise the button is disabled
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

// A helper function that determines if a object can be placed into the slot
- (void)placeGrapheme:(CGPoint)releaseLocation {
    Slot *destinationSlot = nil;
    Slot *sourceSlot = nil;
    
    for (Slot *s in _slots)
        if (CGRectContainsPoint(s.boundingBox, releaseLocation)) {
            destinationSlot = s;
            //Don't look at the other slots
            break;
        }
    
    for (Slot *s in _slots)
        if (s.grapheme == _selectedGrapheme) {
            sourceSlot = s;
            break;
        }

    
    //Grapheme is being placed over a slot
    if (destinationSlot!=nil) {
        //Destination doesn't have a grapheme on it
        if (destinationSlot.grapheme == nil) {
            destinationSlot.grapheme = _selectedGrapheme;
            destinationSlot.scale = 0.8;
            _selectedGrapheme.position = ccp(destinationSlot.position.x, destinationSlot.position.y);
            

            // If we came from a slot remove our grapheme
            if (sourceSlot != nil) {
                sourceSlot.grapheme = nil;
                sourceSlot.scale = 1;
            }
 
        } else { //Graphyme is being placed on a full slot
            if (sourceSlot.grapheme == _selectedGrapheme) {
                _selectedGrapheme.position = ccp(sourceSlot.position.x, sourceSlot.position.y);
            } else {
                _selectedGrapheme.position = _selectedGraphemeLastPosition;
            }
        }
    } else {
        //Graphyme came from another slot
        if (sourceSlot != nil) {
            sourceSlot.grapheme = nil;
            sourceSlot.scale = 1.0;
        }
        
        _selectedGrapheme.position = releaseLocation;
    }
    _selectedGrapheme = nil;
}

// Generate the amount of score given for the level based on number of attempts
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
    [_tts release];
    [_slots release];
    [_submitButton release];
    [_graphemes release];
	[super dealloc];
}
@end

