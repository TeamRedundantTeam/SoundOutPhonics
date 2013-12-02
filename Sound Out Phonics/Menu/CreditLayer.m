//
//  CreditLayer.m
//  Sound Out Phonics
//
//  Purpose: An overlay that gives credits to everyone who has participated in this project
//
//  History: History of the file can be found here: https://github.com/TeamRedundantTeam/SoundOutPhonics/commits/master/Sound%20Out%20Phonics/Menu/CreditLayer.h
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
//  Created on 2013-12-1.
//  Copyright (c) 2013 Team Redundant Team. All rights reserved.
//

#import "CreditLayer.h"

@implementation CreditLayer

- (id)initWithColor:(ccColor4B)color {
    if((self = [super initWithColor:color])) {
        
        // enable touch for this layer
        [self setTouchEnabled:YES];
        
        // get the screen size of the device
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        // create and initialize a background
        CCSprite *background = [CCSprite spriteWithFile:@"Default-Background.png"];
        background.scale = 0.95;
        background.position = ccp(size.width/2, size.height/2);
        [self addChild:background];
        
        CCLabelTTF *layerName = [CCLabelTTF labelWithString:@"CREDITS" fontName:@"KBPlanetEarth" fontSize:48];
        layerName.position = ccp(size.width/2, size.height-75);
        [self addChild:layerName];
        
        _exitButton = [CCSprite spriteWithFile:@"Cancel-Icon-White.png"];
        _exitButton.position = ccp(size.width/2 + 475, size.height - 25);
        [self addChild:_exitButton];
        
        CCLabelTTF *supervisor = [CCLabelTTF labelWithString:@"Project Supervisor" fontName:@"KBPlanetEarth" fontSize:24];
        CCLabelTTF *herbert = [CCLabelTTF labelWithString:@"Dr. Herbert Tsang" fontName:@"KBPlanetEarth" fontSize:16];
        
        CCLabelTTF *asistant = [CCLabelTTF labelWithString:@"Project Assistant" fontName:@"KBPlanetEarth" fontSize:24];
        CCLabelTTF *yong = [CCLabelTTF labelWithString:@"Yong Liao" fontName:@"KBPlanetEarth" fontSize:16];
        
        CCLabelTTF *projectManager = [CCLabelTTF labelWithString:@"Project Manager" fontName:@"KBPlanetEarth" fontSize:24];
        CCLabelTTF *morgan = [CCLabelTTF labelWithString:@"Morgan Jenkins" fontName:@"KBPlanetEarth" fontSize:16];
        
        CCLabelTTF *headTechnicalWriter = [CCLabelTTF labelWithString:@"Head Technical Write" fontName:@"KBPlanetEarth" fontSize:24];
        CCLabelTTF *ian = [CCLabelTTF labelWithString:@"Ian Stewart" fontName:@"KBPlanetEarth" fontSize:16];
        
        CCLabelTTF *technicalWriter = [CCLabelTTF labelWithString:@"Technical Writer/QA" fontName:@"KBPlanetEarth" fontSize:24];
        CCLabelTTF *robert = [CCLabelTTF labelWithString:@"Robert Silvan" fontName:@"KBPlanetEarth" fontSize:16];
        
        CCLabelTTF *leadDeveloper = [CCLabelTTF labelWithString:@"Lead Developer" fontName:@"KBPlanetEarth" fontSize:24];
        CCLabelTTF *oleg = [CCLabelTTF labelWithString:@"Oleg Matvejev" fontName:@"KBPlanetEarth" fontSize:16];
        
        CCLabelTTF *developer = [CCLabelTTF labelWithString:@"Developer" fontName:@"KBPlanetEarth" fontSize:24];
        CCLabelTTF *jordan = [CCLabelTTF labelWithString:@"Jordan Yap" fontName:@"KBPlanetEarth" fontSize:16];
        
        CCLabelTTF *uiDesigener = [CCLabelTTF labelWithString:@"UI Designer" fontName:@"KBPlanetEarth" fontSize:24];
        CCLabelTTF *erik = [CCLabelTTF labelWithString:@"Erik Schultz" fontName:@"KBPlanetEarth" fontSize:16];
        
        CCLabelTTF *consultant = [CCLabelTTF labelWithString:@"Consultant" fontName:@"KBPlanetEarth" fontSize:24];
        CCLabelTTF *teressa = [CCLabelTTF labelWithString:@"Teresa Jenkins" fontName:@"KBPlanetEarth" fontSize:16];
        
        supervisor.position = ccp(size.width/2, size.height - 120);
        herbert.position = ccp(size.width/2, size.height - 150);
        
        asistant.position = ccp(size.width/2, size.height - 190);
        yong.position = ccp(size.width/2, size.height - 220);
        
        projectManager.position = ccp(size.width/2, size.height - 260);
        morgan.position = ccp(size.width/2, size.height - 290);
        
        leadDeveloper.position = ccp(size.width/2, size.height - 330);
        oleg.position = ccp(size.width/2, size.height - 360);
        
        developer.position = ccp(size.width/2, size.height - 400);
        jordan.position = ccp(size.width/2, size.height - 430);
        
        uiDesigener.position = ccp(size.width/2, size.height - 470);
        erik.position = ccp(size.width/2, size.height - 500);
        
        headTechnicalWriter.position = ccp(size.width/2, size.height - 540);
        ian.position = ccp(size.width/2, size.height - 570);
        
        technicalWriter.position = ccp(size.width/2, size.height - 610);
        robert.position = ccp(size.width/2, size.height - 640);
        
        consultant.position = ccp(size.width/2, size.height - 680);
        teressa.position = ccp(size.width/2, size.height - 710);
        
        [self addChild:projectManager];
        [self addChild:morgan];
        
        [self addChild:headTechnicalWriter];
        [self addChild:ian];
        
        [self addChild:technicalWriter];
        [self addChild:robert];
        
        [self addChild:leadDeveloper];
        [self addChild:oleg];
        
        [self addChild:developer];
        [self addChild:jordan];
    
        [self addChild:uiDesigener];
        [self addChild:erik];
        
        [self addChild:supervisor];
        [self addChild:herbert];
        
        [self addChild:asistant];
        [self addChild:yong];
        
        [self addChild:consultant];
        [self addChild:teressa];
    }
    return self;
}

// dispatcher to catch the touch events
- (void)registerWithTouchDispatcher {
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

// Handles the events that happen when the release occurs at a specific location
- (void)tapReleaseAt:(CGPoint)releaseLocation {
    
    // Occurs when the user taps the exit button
    if (CGRectContainsPoint(_exitButton.boundingBox, releaseLocation)) {
        [self.parent scheduleOnce:@selector(menuEnableTouch) delay:0];
        [self.parent removeChild:self cleanup:YES];
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


- (void)dealloc {
    [super dealloc];
}
@end
