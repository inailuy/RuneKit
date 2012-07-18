//
//  MainPage.h
//  RuneKit
//
//  Created by Yuliani Noriega on 12/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParserMAIN.h"
#import "EGORefreshTableHeaderView.h"
#import "Reachability.h"


@interface MainPage : UITableViewController<EGORefreshTableHeaderDelegate>{
    ParserMAIN *xmlParser;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    UIActivityIndicatorView *spinner;
    NSDictionary *imageDictionary;
    
    NSArray *contentPassed;
    Reachability *internetConnection;
}



- (void)parseTheLog;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end