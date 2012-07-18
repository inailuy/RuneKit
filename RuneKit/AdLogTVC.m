//
//  AdLogTVC.m
//  RuneKit
//
//  Created by Yuliani Noriega on 12/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AdLogTVC.h"
#import "Reachability.h"


@implementation AdLogTVC
@synthesize blockView;
@synthesize userName;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    //Creating UISearchbar
    searchBarInput = [[UISearchBar alloc] init];
    searchBarInput.barStyle = 1;
    searchBarInput.placeholder = @"Search the AdventureLog";
    searchBarInput.delegate = (id)self;
    searchBarInput.autocapitalizationType = UITextAutocapitalizationTypeNone;
    //[self.view insertSubview:searchBarInput atIndex:0];
    [searchBarInput sizeToFit];
    self.navigationItem.titleView = searchBarInput;
    
    UINavigationBar *bar = [[UINavigationBar alloc] init];
    
    [self.navigationController.navigationBar addSubview:bar];
    
    //Setting up blockView
    self.blockView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 340, 800)];
    self.blockView.backgroundColor = [UIColor blackColor];
    self.blockView.alpha = .75;
    UITapGestureRecognizer *blockerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [blockerTap setNumberOfTapsRequired:1];
    UISwipeGestureRecognizer *swipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [swipeGR setDirection:UISwipeGestureRecognizerDirectionUp];
    [swipeGR setDirection:UISwipeGestureRecognizerDirectionRight];
    [swipeGR setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeGR setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.blockView addGestureRecognizer:blockerTap];
    [self.blockView addGestureRecognizer:swipeGR];
    
}

- (void)viewDidUnload
{
    searchBarInput = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) parseTheLog{
    NSString *url = [NSString stringWithFormat:@"http://services.runescape.com/m=adventurers-log/rssfeed?searchName="];
    NSString *fullURL = [url stringByAppendingFormat:@"%@", self.userName];
    xmlParser = [[Parser alloc] loadXMLByURL:fullURL];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (xmlParser.error == YES) return 1;
    else return [xmlParser.logs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ACELL";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    
    if (xmlParser.error == NO) {
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        ParserObject *currentLog = [xmlParser.logs objectAtIndex:indexPath.row];
        cell.textLabel.text = currentLog.title;
        cell.detailTextLabel.text = currentLog.description;
    }
    else {
        cell.detailTextLabel.text = nil;
        Reachability *internetConnection = [Reachability reachabilityForInternetConnection];
        if ([internetConnection isReachable])
        cell.textLabel.text = @"     Username Not In Database";
        else {
            cell.textLabel.text = Nil;
//            UIAlertView *noConnectionAlert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"Please connect to the internet" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:Nil];
//            [noConnectionAlert show];
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
      *detailViewController = [[ alloc] initWithNibName:@"" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    //Setting up EGO
    if (_refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
        view.delegate = self;
        [self.tableView addSubview:view];
		_refreshHeaderView = view;
	}
    
    self.userName = [searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGRect frame = spinner.frame;
    frame.origin.x = self.view.frame.size.width / 2 - frame.size.width / 2;
    frame.origin.y = self.view.frame.size.height / 2 - frame.size.height / 2;
    spinner.frame = frame;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    [searchBar resignFirstResponder];
    dispatch_queue_t downloadQueue = dispatch_queue_create("userName downloader", NULL);
    dispatch_async(downloadQueue, ^{
        [self parseTheLog];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [spinner stopAnimating];
        });
    });
    dispatch_release(downloadQueue);
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
//    [self loadView];
    [self.view.window addSubview:blockView];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [blockView removeFromSuperview];
}

-(void)tap{
    if ([searchBarInput isFirstResponder])
        [searchBarInput resignFirstResponder];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    dispatch_queue_t downloadQueue = dispatch_queue_create("userName downloader", NULL);
    dispatch_async(downloadQueue, ^{
        [self parseTheLog];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
    dispatch_release(downloadQueue);
    
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.7];
    
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

@end
