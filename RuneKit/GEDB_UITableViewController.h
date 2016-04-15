//
//  GEDB_UITableViewController.h
//  RuneKit
//
//  Created by Yuliani Noriega on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface GEDB_UITableViewController : UITableViewController<EGORefreshTableHeaderDelegate>{
    NSMutableArray *itemNames;
    NSMutableArray *itemPrices;
    NSMutableArray *itemImages;
    NSString * queryString;
    
    IBOutlet UISearchBar *searchBarInput;
    IBOutlet UIView *blockView;
    IBOutlet UIView *blockView2;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    BOOL firstQuery;
}

@property (nonatomic, strong) IBOutlet UIView *blockView;
@property (nonatomic, strong) IBOutlet UIView *blockView2;
@property (nonatomic, strong) NSMutableArray *itemNames;
@property (nonatomic, strong) NSMutableArray *itemPrices;
@property (nonatomic, strong) NSMutableArray *itemImages;
@property (nonatomic, strong) NSString *queryString;
@property (nonatomic) BOOL firstQuery;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end
