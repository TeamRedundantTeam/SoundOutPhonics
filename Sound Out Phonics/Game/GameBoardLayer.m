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


+(CCScene *) sceneWithParamaters:(NSString*) gameLevel {
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameBoardLayer *layer = [GameBoardLayer nodeWithParamaters:gameLevel];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// Creates the node of the level with the paramaters and then calles initWithParamaters to initialize the layer
+(id)nodeWithParamaters:(NSString*)level{
    return  [[[self alloc] initWithParamaters:level] autorelease];
}

-(id) initWithParamaters : (NSString*) gameLevel {
    
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
        
        

    }
    return self;
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    [tts release];
    [level release];
    [picture release];
	[super dealloc];
}

// Dispatcher to catch the touch events
- (void)registerWithTouchDispatcher {
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];

}

// Handling of the on touch event on tap down
- (void)tapDownAt:(CGPoint)touchLocation {
    
    // If the picture is selected the level name will be played out
    if(CGRectContainsPoint(picture.boundingBox, touchLocation)) {
        [tts playWord:level];
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

@end

