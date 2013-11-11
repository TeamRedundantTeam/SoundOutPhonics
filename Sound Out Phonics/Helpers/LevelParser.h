//
//  LevelParser.h
//  Sound Out Phonics
//
//  Created on 2013-11-10.
//  Copyright (c) 2013 Team Redundant Team. All rights reserved.
//

#import "LevelParser.h"
#import <Foundation/Foundation.h>

@interface LevelParser : NSObject<NSXMLParserDelegate> {
    int number;
    NSString *name;
    NSString *grapheme;
    NSString *sprite;
    NSMutableString	*currentNodeContent;
    NSMutableArray *retrievedValue;
    NSXMLParser *parser;
}


- (NSArray *)loadLevels:(NSURL*) xmlUrl;

@end