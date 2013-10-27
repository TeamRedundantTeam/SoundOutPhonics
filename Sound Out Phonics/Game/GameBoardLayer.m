//
//  GameBoardLayer.m
//  Sound Out Phonics
//
//  Created by Oleg M on 2013-10-23.
//  Copyright (c) 2013 Team Redundant Team. All rights reserved.
//

// Import the interfaces
#import "GameBoardLayer.h"



#pragma mark - GameBoardLayer

// GameBoardLayer implementation
@implementation GameBoardLayer
@synthesize picture;
@synthesize tts;
@synthesize level;
@synthesize graphymes;
@synthesize selectedLabel;
@synthesize slots;
@synthesize submitButton;

//@synthesize slot;
+(CCScene *) sceneWithParamaters:(NSString*) gameLevel :(NSString*) levelGraphymes {
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameBoardLayer *layer = [GameBoardLayer nodeWithParamaters:gameLevel:levelGraphymes];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// Creates the node of the level with the paramaters and then calles initWithParamaters to initialize the layer
+(id)nodeWithParamaters:(NSString*)level :(NSString*) levelGraphymes {
    return  [[[self alloc] initWithParamaters:level:levelGraphymes] autorelease];
}

// Converts levelGraphymes into an array and randomizes the graphymes in that array
- (NSArray*) generateGraphymeList:(NSString*) levelName :(NSString*) levelGraphymes {
    
    NSArray* tempList = [levelGraphymes componentsSeparatedByString:@"-"];
    NSMutableArray* tempMutableList = [NSMutableArray arrayWithArray:tempList];

    int j;
    
    // Randomize the list using Fisher and Yates' algorithm
    for (int i = tempMutableList.count-1; i > 0; i--) {
        j = arc4random() % (i+1);
        [tempMutableList exchangeObjectAtIndex:i withObjectAtIndex:j];
    }
    
    // Create an array with the randomized mutable array
    NSArray* graphymeList = [NSArray arrayWithArray:tempMutableList];
    
    NSString* temp = @"";
    // Create the string from the new randomized array
    for (int i = 0; i < tempMutableList.count; i++) {
        temp = [temp stringByAppendingString:[tempMutableList objectAtIndex:i]];
    }
    
    // Recursively check that the randomized array is not in the proper order
    if ([temp isEqualToString:levelName] && graphymeList.count > 1)
        graphymeList = [self generateGraphymeList:levelName:levelGraphymes];
    
    return graphymeList;
}

-(id) initWithParamaters:(NSString*) gameLevel :(NSString*) levelGraphymes {
    
    if((self=[super init])) {
        
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
        
        // Create the graphyme list in randamized order
        NSArray* graphymeList = [self generateGraphymeList:gameLevel:levelGraphymes];
        
        // Create Slots
        self.slots = [[NSMutableArray alloc] init];
        for (int i = 0; i < graphymeList.count; i++) {
            // Create Slots
            Slots *slot = [[Slots alloc] initWithPosition:ccp(screenSize.width/4 + i*225, screenSize.height/4)];
            [slots addObject:slot];
            [self addChild:slot];
            [slot release];
        }
        
        // Add Submit Button
        self.submitButton = [[SubmitButton alloc] initWithPosition:ccp(screenSize.width - screenSize.width/9, screenSize.height/15)];
        [self.submitButton setState:false];
        [self addChild:submitButton];
        
        // Create Graphymes
        self.graphymes = [[NSMutableArray alloc] init];
        for (int i = 0; i < graphymeList.count; i++) {
            
            // Create Labels
            CCLabelTTF *graphyme = [CCLabelTTF labelWithString:[graphymeList objectAtIndex:i]
                                    fontName:@"Marker Felt" fontSize:64];
            graphyme.position = ccp(screenSize.width/2 + i*screenSize.width/10, screenSize.height - screenSize.height/4.5);
            
            [self addChild:graphyme];
            [graphymes addObject:graphyme];

        }
    }
    return self;
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    [tts release];
    [level release];
    [picture release];
    [Slots release];
    [submitButton release];
    [graphymes release];
	[super dealloc];
}

// Dispatcher to catch the touch events
- (void)registerWithTouchDispatcher {
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];

}

// Handling of the on touch event on tap down which will activate various functions based on which sprite is selected
- (void)tapDownAt:(CGPoint)touchLocation {
    
    CCLabelTTF *newLabel = nil;
    
    // Checks if a graphyme has been selected
    for (CCLabelTTF *label in graphymes) {
        if (CGRectContainsPoint(label.boundingBox, touchLocation)) {
            newLabel = label;
            break;
        }
    }
    
    // If a new graphyme has been selected then begin rotating it from side to side
    if (newLabel != selectedLabel) {
        [selectedLabel stopAllActions];
        [selectedLabel runAction:[CCRotateTo actionWithDuration:0.1 angle:0]];
        CCRotateTo *rotLeft = [CCRotateBy actionWithDuration:0.1 angle:-4.0];
        CCRotateTo *rotCenter = [CCRotateBy actionWithDuration:0.1 angle:0.0];
        CCRotateTo *rotRight = [CCRotateBy actionWithDuration:0.1 angle:4.0];
        CCSequence *rotSeq = [CCSequence actions:rotLeft, rotCenter, rotRight, rotCenter, nil];
        [newLabel runAction:[CCRepeatForever actionWithAction:rotSeq]];
        selectedLabel = newLabel;
    }
    
    if (selectedLabel)
        selectedLabelLastPosition = touchLocation;
    
    // If the picture is selected the level name will be played out
    if (selectedLabel == nil && CGRectContainsPoint(picture.boundingBox, touchLocation)) {
        [tts playWord:level];
    }
    
    if ([self.submitButton state] && CGRectContainsPoint(submitButton.boundingBox, touchLocation)) {
        NSString *userInput = @"";
        for (Slots *slot in slots) {
            userInput = [userInput stringByAppendingString:[slot.graphyme string]];
        }
        [tts playWord:userInput];
    }

}

- (void)tapReleaseAt:(CGPoint)releaseLocation {
    
    // Stop all the action that the selected label is performing and deselect it.
    if (selectedLabel) {
        [selectedLabel stopAllActions];
        [selectedLabel runAction:[CCRotateTo actionWithDuration:0.1 angle:0]];
        [self placeGraphyme:releaseLocation];
        [self checkSubmitButton];
    }

}
// Event that is called when the touch has began
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    // Gathers the locaiton of the touch and sends it onto the tapDownAt
    CGPoint touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    [self tapDownAt:touchLocation];
    return YES;
}


// Event that is called when the touch has ended
- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint releaseLocation = [touch locationInView:[touch view]];
    releaseLocation = [[CCDirector sharedDirector] convertToGL:releaseLocation];
    [self tapReleaseAt:releaseLocation];
}

// Translate the selected label to the new location
- (void)panForTranslation:(CGPoint)translation {
    if (selectedLabel) {
        CGPoint newPos = ccpAdd(selectedLabel.position, translation);
        selectedLabel.position = newPos;
    }
}

// Event that occurs when the touch is moved
- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
    oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
    oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
    
    CGPoint translation = ccpSub(touchLocation, oldTouchLocation);
    [self panForTranslation:translation];
}

// Checks if the submit button should be enabled or not
// Only enabled when each slot is filled with a grypheme otherwise the button is disabled
- (void) checkSubmitButton {
    bool filledSlots = true;
    for (Slots *slot in slots) {
        if (slot.graphyme == nil) {
            filledSlots = false;
            [self.submitButton setState:false];
        }
    }
    if (filledSlots == true)
        [self.submitButton setState:true];
}

// A helper function that determines if a object can be placed into the slot
- (void)placeGraphyme:(CGPoint)releaseLocation {
    Slots *destinationSlot = nil;
    Slots *sourceSlot = nil;
    
    for(Slots *s in slots)
        if (CGRectContainsPoint(s.boundingBox, releaseLocation)){
            destinationSlot = s;
            //Don't look at the other slots
            break;
        }
    
    for(Slots *s in slots)
        if (s.graphyme == selectedLabel){
            sourceSlot = s;
            break;
        }

    
    //Graphyms is being placed over a slot
    if(destinationSlot!=nil){
        //Destination doesn't have a graphyme on it
        if (destinationSlot.graphyme == nil) {
            destinationSlot.graphyme = selectedLabel;
            destinationSlot.scale = 0.8;
            selectedLabel.position = ccp(destinationSlot.position.x, destinationSlot.position.y);
            

            // If we came from a slot remove our graphyme
            if (sourceSlot != nil) {
                sourceSlot.graphyme = nil;
                sourceSlot.scale = 1;
            }
 
        } else { //Graphyme is being placed on a full slot
            if (sourceSlot.graphyme == selectedLabel) {
                selectedLabel.position = ccp(sourceSlot.position.x, sourceSlot.position.y);
            } else {
                selectedLabel.position = selectedLabelLastPosition;
            }
        }
    } else {
        //Graphyme came from another slot
        if (sourceSlot != nil) {
            sourceSlot.graphyme = nil;
            sourceSlot.scale = 1.0;
        }
        
        selectedLabel.position = releaseLocation;
    }
    selectedLabel = nil;

}
@end

