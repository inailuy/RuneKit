//
//  ParserMAIN.m
//  RuneKit
//
//  Created by Yuliani Noriega on 12/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ParserMAIN.h"

@implementation ParserMAIN

@synthesize logs;
@synthesize error;

-(id) loadXMLByURL:(NSString *)urlString
{
    completeNodeContent = [[NSMutableString alloc] init];
    logs            = [[NSMutableArray alloc] init];
    NSURL *url      = [NSURL URLWithString:urlString];
    NSData  *data   = [[NSData alloc] initWithContentsOfURL:url];
    
    if (!data)  error = YES;
    else if (data) error = NO;
    
    parser          = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    [parser parse];
    return self;
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementname namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementname isEqualToString:@"item"])
    {
        currentLog = [ParserObjectMAIN alloc];
        completeNodeContent = @"";
    }
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementname namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementname isEqualToString:@"title"])
    {
        currentLog.title = completeNodeContent;
    }
    if ([elementname isEqualToString:@"description"])
    {
        currentLog.description = currentNodeContent;
    }
    if ([elementname isEqualToString:@"category"])
    {
        currentLog.category = currentNodeContent;
    }
    if ([elementname isEqualToString:@"link"])
    {
        currentLog.link = currentNodeContent;
    }
    if ([elementname isEqualToString:@"pubDate"])
    {
        currentLog.pubDate = currentNodeContent;
    }
    if ([elementname isEqualToString:@"item"])
    {
        [logs addObject:currentLog];
        currentLog = nil;
        currentNodeContent = nil;
    }
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    currentNodeContent = [NSMutableString stringWithString:[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    completeNodeContent = [completeNodeContent stringByAppendingString:currentNodeContent];
}

@end
