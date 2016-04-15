//
//  HighScoreTVC.h
//  RuneKit
//
//  Created by Yuliani Noriega on 12/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface HighScoreTVC : UITableViewController<EGORefreshTableHeaderDelegate>{
    NSMutableArray       *skills;
    NSMutableArray       *skillImages;
    NSMutableArray       *stats;
    NSDictionary         *skillData;
    NSString             *currentSearchFieldInput;
    
    BOOL didEnterInput;
    BOOL tableViewIsPopulated;
    
    IBOutlet UISearchBar *searchBarInput;
    IBOutlet UILabel     *label;
    UIView               *blockView;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end
