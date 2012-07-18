//
//  ParserObjectMAIN.h
//  RuneKit
//
//  Created by Yuliani Noriega on 12/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParserObjectMAIN : NSObject{
    NSString *title;
    NSString *description;
    NSString *category;
    NSString *link;
    NSString *pubDate;
}

@property (copy)NSString *title;
@property (copy)NSString *description;
@property (copy)NSString *category;
@property (copy)NSString *link;
@property (copy)NSString *pubDate;

@end
