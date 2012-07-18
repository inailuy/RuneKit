//
//  ArticleViewController.h
//  RuneKit
//
//  Created by Yuliani Noriega on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "HTMLNode.h"
#import "HTMLParser.h"

@interface ArticleViewController : UIViewController{
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *categoryLabel;
    IBOutlet UILabel *dateLabel;
    IBOutlet UILabel *completeTitleLabel;
    IBOutlet UITextView *article;
    IBOutlet UILabel *loading;
    
    UIActivityIndicatorView *spinner;

}

@property (strong) NSArray *contentPassed;

@end
