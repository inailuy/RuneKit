//
//  ParserMAIN.h
//  RuneKit
//
//  Created by Yuliani Noriega on 12/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParserObjectMAIN.h"

@interface ParserMAIN : NSObject<NSXMLParserDelegate>{
    NSMutableString     *currentNodeContent;
    NSString            *completeNodeContent;
    NSMutableArray      *logs;
    NSXMLParser         *parser;
    ParserObjectMAIN    *currentLog;
    bool error;
}

@property (nonatomic, strong) NSMutableArray *logs;
@property (nonatomic) bool error;

-(id) loadXMLByURL:(NSString *)urlString;

@end
