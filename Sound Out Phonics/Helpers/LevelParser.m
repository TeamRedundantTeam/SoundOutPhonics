//
//  LevelParser.m
//  Sound Out Phonics
//
//  Created on 2013-11-10.
//  Copyright (c) 2013 Team Redundant Team. All rights reserved.
//

#import "LevelParser.h"
#import "Level.h"

@implementation LevelParser

- (NSArray*) loadLevels:(NSURL*) xmlUrl{
    // uses NSXML to parse our file into an array of Level objects
    retrievedValue = [[[NSMutableArray alloc] init] autorelease];
    parser = [[NSXMLParser alloc] initWithContentsOfURL:xmlUrl];
    parser.delegate = self;
    [parser parse];
    return retrievedValue;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {

}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    	currentNodeContent = (NSMutableString *) [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    // check and assign each tag element to the appropriate variable
    if ([elementName isEqualToString:@"Number"]){
		number = currentNodeContent.intValue;
	}
	if ([elementName isEqualToString:@"Name"]){
		name = currentNodeContent;
	}
    if ([elementName isEqualToString:@"Graphemes"]){
		grapheme = currentNodeContent;
	}
    if ([elementName isEqualToString:@"Sprite"]){
		sprite = currentNodeContent;
	}
    
    // end of a level so add our level object into our array
	if ([elementName isEqualToString:@"Level"]){
        Level *level = [[Level alloc] initWithParameters:number withName:name withGraphemes:grapheme withImageLocation:sprite];
        [retrievedValue addObject:level];
		[currentNodeContent release];
		currentNodeContent = nil;
	}
}

- (void) dealloc{
	[parser release];
	[super dealloc];
}

@end
