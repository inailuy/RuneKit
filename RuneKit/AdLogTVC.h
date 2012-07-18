//
//  AdLogTVC.h
//  RuneKit
//
//  Created by Yuliani Noriega on 12/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parser.h"
#import "EGORefreshTableHeaderView.h"

@interface AdLogTVC : UITableViewController<EGORefreshTableHeaderDelegate>{
    IBOutlet UIView *blockView;
    Parser *xmlParser;
    IBOutlet UISearchBar *searchBarInput;
    NSString *userName;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}

@property (nonatomic, strong) IBOutlet UIView *blockView;
@property (nonatomic, strong) NSString *userName;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end
