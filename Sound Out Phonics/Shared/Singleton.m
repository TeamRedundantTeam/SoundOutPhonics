//
//  Singleton.m
//  Sound Out Phonics
//
//  Created by Oleg M on 2013-11-06.
//  Copyright (c) 2013 Team Redundant Team. All rights reserved.
//

#import "Singleton.h"

@implementation Singleton
static Singleton* _sigleton = nil;
@synthesize loggedInAccount = _loggedInAccount;

+(Singleton*)sharedSingleton
{
	@synchronized([Singleton class])
	{
		if (!_sigleton)
			[[self alloc] init];
        
		return _sigleton;
	}
	return nil;
}

+(id)alloc
{
	@synchronized([Singleton class])
	{
		NSAssert(_sigleton == nil, @"Attempted to allocate a second instance of a singleton.");
		_sigleton = [super alloc];
		return _sigleton;
	}
    
	return nil;
}

-(id)init {
	self = [super init];
	if (self != nil) {
		// initialize stuff here
	}
    
	return self;
}

@end
