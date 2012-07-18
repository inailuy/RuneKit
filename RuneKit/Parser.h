//
//  Parser.h
//  RuneKit
//
//  Created by Yuliani Noriega on 12/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParserObject.h"

@interface Parser : NSObject<NSXMLParserDelegate>{
    NSMutableString *currentNodeContent;
    NSString        *completeNodeContentForTitle;
    NSMutableArray  *logs;
    NSXMLParser     *parser;
    ParserObject    *currentLog;
    
    bool error;
}

@property (nonatomic, strong) NSMutableArray *logs;
@property (nonatomic) bool error;

-(id) loadXMLByURL:(NSString *)urlString;
@end
