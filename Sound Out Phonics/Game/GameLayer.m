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

// GameBoardLayer implementation
@implementation GameLayer
@synthesize picture;
@synthesize tts;
@synthesize level;
@synthesize graphemes;
@synthesize selectedGrapheme;
@synthesize slots;
@synthesize submitButton;

// Create the Game scene
+ (CCScene *)sceneWithParamaters:(NSString *)gameLevel withGraphemes:(NSString *)levelGraphemes {
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer nodeWithParamaters:gameLevel withGraphemes:levelGraphemes];
	
	// add layer as a child to scene
	[scene addChild:layer];
	
	// return the scene
	return scene;
}

// Creates the node of the level with the paramaters and then calles initWithParamaters to initialize the layer
+ (id)nodeWithParamaters:(NSString *)level withGraphemes:(NSString *)levelGraphemes {
    return [[[self alloc] initWithParamaters:level withGraphemes:levelGraphemes] autorelease];
}

// Converts levelGraphemes into an array and randomizes the graphemes in that array
- (NSArray*)generateGraphemeList:(NSString*)levelName withGraphemes:(NSString*)levelGraphemes {
    
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

- (id)initWithParamaters:(NSString *)gameLevel withGraphemes:(NSString *)levelGraphemes {
    
    if ((self = [super init])) {
        
        // Enable touch for this layer
        [self setTouchEnabled:YES];
        
        // Get the screen size of the device
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        
        self.level = gameLevel;
        
        // Add picture sprite object
        self.picture = [[SpritePicture alloc] initWithPosition:ccp(screenSize.width/5.5, screenSize.height - screenSize.height/4.5)];
        
        [self addChild:picture];

        // Add text to speech object
        self.tts = [[TextToSpeech alloc] init];
        
        // Create the graphyme list in randomized order
        NSArray* graphemeList = [self generateGraphemeList:gameLevel withGraphemes:levelGraphemes];
        
        // Create Slots Array
        self.slots = [[NSMutableArray alloc] init];
        for (int i = 0; i < graphemeList.count; i++) {
            // Create an individual slot
            Slot *slot = [[Slot alloc] initWithPosition:ccp(screenSize.width/4 + i*225, screenSize.height/4)];
            [slots addObject:slot];
            [self addChild:slot];
            [slot release];
        }
        
        // Add Submit Button
        self.submitButton = [[SubmitButton alloc] initWithPosition:ccp(screenSize.width - screenSize.width/9, screenSize.height/15)];
        [self.submitButton setState:false];
        [self addChild:submitButton];
        
        // Create Graphemes
        self.graphemes = [[NSMutableArray alloc] init];
        for (int i = 0; i < graphemeList.count; i++) {
            
            // Create Labels
            CCLabelTTF *grapheme = [CCLabelTTF labelWithString:[graphemeList objectAtIndex:i]
                                    fontName:@"Marker Felt" fontSize:64];
            grapheme.position = ccp(screenSize.width/2 + i*screenSize.width/10, screenSize.height - screenSize.height/4.5);
            
            [self addChild:grapheme];
            [graphemes addObject:grapheme];
        }
    }
    return self;
}


// on "dealloc" you need to release all your retained objects
- (void)dealloc
{
    [tts release];
    [level release];
    [picture release];
    [slots release];
    [submitButton release];
    [graphemes release];
	[super dealloc];
}

// Dispatcher to catch the touch events
- (void)registerWithTouchDispatcher {
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

// Handling of the on tap down at a specific location that will do various functionality depending on which sprite is being touched
- (void)tapDownAt:(CGPoint)touchLocation {
    
    CCLabelTTF *newGrapheme = nil;
    
    // Checks if a grapheme has been selected
    for (CCLabelTTF *grapheme in graphemes) {
        if (CGRectContainsPoint(grapheme.boundingBox, touchLocation)) {
            newGrapheme = grapheme;
            break;
        }
    }
    
    // If a new grapheme has been selected then begin rotating it from side to side
    if (newGrapheme != selectedGrapheme) {
        [selectedGrapheme stopAllActions];
        [selectedGrapheme runAction:[CCRotateTo actionWithDuration:0.1 angle:0]];
        CCRotateTo *rotLeft = [CCRotateBy actionWithDuration:0.1 angle:-4.0];
        CCRotateTo *rotCenter = [CCRotateBy actionWithDuration:0.1 angle:0.0];
        CCRotateTo *rotRight = [CCRotateBy actionWithDuration:0.1 angle:4.0];
        CCSequence *rotSeq = [CCSequence actions:rotLeft, rotCenter, rotRight, rotCenter, nil];
        [newGrapheme runAction:[CCRepeatForever actionWithAction:rotSeq]];
        selectedGrapheme = newGrapheme;
    }
    
    // Record the selected graphemes last touch location location
    if (selectedGrapheme)
        selectedGraphemeLastPosition = touchLocation;
    
    // If the picture is selected the level name will be played out
    if (selectedGrapheme == nil && CGRectContainsPoint(picture.boundingBox, touchLocation)) {
        [tts playWord:level];
    }
    
    // If submit button is selected and it is enabled
    if ([self.submitButton state] && CGRectContainsPoint(submitButton.boundingBox, touchLocation)) {
        NSString *userInput = @"";
        for (Slot *slot in slots) {
            userInput = [userInput stringByAppendingString:[slot.grapheme string]];
        }
        
        // The user was able to put the the right graphemes into the slot. Create Victory Screen scene
        if ([userInput isEqualToString:level])
        {
            ccColor4B c = {100,100,0,100};
            VictoryLayer * vl = [[[VictoryLayer alloc] initWithColor:c] autorelease];
            [self.parent addChild:vl z:10];
            [self onExit];
        }
        [tts playWord:userInput];
    }
}

// Handles the events that happen when the release occurs at a specific location
- (void)tapReleaseAt:(CGPoint)releaseLocation {
    
    // Stop all the action that the selected label is performing and deselect it.
    if (selectedGrapheme) {
        [selectedGrapheme stopAllActions];
        [selectedGrapheme runAction:[CCRotateTo actionWithDuration:0.1 angle:0]];
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
    if (selectedGrapheme) {
        CGPoint newPos = ccpAdd(selectedGrapheme.position, translation);
        selectedGrapheme.position = newPos;
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
    for (Slot *slot in slots) {
        if (slot.grapheme == nil) {
            filledSlots = false;
            [self.submitButton setState:false];
        }
    }
    if (filledSlots == true)
        [self.submitButton setState:true];
}

// A helper function that determines if a object can be placed into the slot
- (void)placeGrapheme:(CGPoint)releaseLocation {
    Slot *destinationSlot = nil;
    Slot *sourceSlot = nil;
    
    for (Slot *s in slots)
        if (CGRectContainsPoint(s.boundingBox, releaseLocation)) {
            destinationSlot = s;
            //Don't look at the other slots
            break;
        }
    
    for (Slot *s in slots)
        if (s.grapheme == selectedGrapheme) {
            sourceSlot = s;
            break;
        }

    
    //Grapheme is being placed over a slot
    if (destinationSlot!=nil) {
        //Destination doesn't have a grapheme on it
        if (destinationSlot.grapheme == nil) {
            destinationSlot.grapheme = selectedGrapheme;
            destinationSlot.scale = 0.8;
            selectedGrapheme.position = ccp(destinationSlot.position.x, destinationSlot.position.y);
            

            // If we came from a slot remove our grapheme
            if (sourceSlot != nil) {
                sourceSlot.grapheme = nil;
                sourceSlot.scale = 1;
            }
 
        } else { //Graphyme is being placed on a full slot
            if (sourceSlot.grapheme == selectedGrapheme) {
                selectedGrapheme.position = ccp(sourceSlot.position.x, sourceSlot.position.y);
            } else {
                selectedGrapheme.position = selectedGraphemeLastPosition;
            }
        }
    } else {
        //Graphyme came from another slot
        if (sourceSlot != nil) {
            sourceSlot.grapheme = nil;
            sourceSlot.scale = 1.0;
        }
        
        selectedGrapheme.position = releaseLocation;
    }
    selectedGrapheme = nil;
}
@end

