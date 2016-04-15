//
//  ParserObject.h
//  RuneKit
//
//  Created by Yuliani Noriega on 12/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParserObject : NSObject{
    
    NSString *title;
    NSString *description;
}

@property (copy)NSString *title;
@property (copy)NSString *description;

@end
