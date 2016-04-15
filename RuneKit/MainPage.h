//
//  MainPage.h
//  RuneKit
//
//  Created by Yuliani Noriega on 12/20/11.
//  Copyright (c) 2011 RuneKit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParserMAIN.h"
#import "EGORefreshTableHeaderView.h"
#import "Reachability.h"


@interface MainPage : UITableViewController<EGORefreshTableHeaderDelegate>

- (void)parseTheLog;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end