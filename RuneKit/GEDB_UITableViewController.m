//
//  GEDB_UITableViewController.m
//  RuneKit
//
//  Created by Yuliani Noriega on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GEDB_UITableViewController.h"
#import "HTMLNode.h"
#import "HTMLParser.h"
#import "Reachability.h"


@implementation GEDB_UITableViewController

@synthesize blockView, blockView2, itemNames, itemPrices, itemImages, queryString, firstQuery;

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
    
    queryString =[[NSString alloc] init];
    firstQuery = NO;
    itemPrices = [[NSMutableArray alloc] init];
    itemNames = [[NSMutableArray alloc] init];
    itemImages = [[NSMutableArray alloc] init];
    
    //Creating UISearchbar
    searchBarInput = [[UISearchBar alloc] init];
    searchBarInput.barStyle = 1;
    searchBarInput.placeholder = @"Search the Grand Exchange";
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
    
    //Setting up blockView2
    self.blockView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 800, 370)];
    self.blockView2.backgroundColor = [UIColor whiteColor];
    self.blockView2.alpha = .1;
//    UITapGestureRecognizer *blockerTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
//    [blockerTap setNumberOfTapsRequired:1];
//    UISwipeGestureRecognizer *swipeGR2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
//    [swipeGR2 setDirection:UISwipeGestureRecognizerDirectionUp];
//    [swipeGR2 setDirection:UISwipeGestureRecognizerDirectionRight];
//    [swipeGR2 setDirection:UISwipeGestureRecognizerDirectionLeft];
//    [swipeGR2 setDirection:UISwipeGestureRecognizerDirectionDown];
//    [self.blockView2 addGestureRecognizer:blockerTap2];
//    [self.blockView2 addGestureRecognizer:swipeGR2];
    
    

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (itemPrices.count) return itemPrices.count;
    else if (!firstQuery) return 0;
    else return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ItemDiscriptionCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    cell.selectionStyle = UITableViewCellAccessoryNone;
    if ([itemImages lastObject]) {
        cell.textLabel.text = [itemNames objectAtIndex:indexPath.row];
        cell.detailTextLabel.text =  [[NSString alloc] initWithFormat:@"Price: %@",[itemPrices objectAtIndex:indexPath.row]];
        cell.imageView.image = [UIImage imageWithData:[itemImages objectAtIndex:indexPath.row]];
    }
    else if (![itemImages lastObject] && firstQuery){
        cell.detailTextLabel.text = @"";
        cell.imageView.image = Nil;
        Reachability *internetConnection = [Reachability reachabilityForInternetConnection];
        if ([internetConnection isReachable])
            cell.textLabel.text = @"            Item Not In Database";
        else {
            cell.textLabel.text = Nil;
//            UIAlertView *noConnectionAlert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"Please connect to the internet" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:Nil];
//            [noConnectionAlert show];
        }
    }
    
    return cell;
}

//**---This method queries the grandexchange database and parses the results into 2 arrays
- (void) parseTheQuery:(NSString *)query{
    //local arrays
    //NSArray *itemNamesArray = [[NSArray alloc] init];
    //NSArray *itemPricesArray = [[NSArray alloc] init];
    NSMutableArray *itemImagesArray = [[NSMutableArray alloc] init];
    
    //removes content on arrays so that it doesn't mix old results with new
    [itemNames removeAllObjects];
    [itemPrices removeAllObjects];
    [itemImages removeAllObjects];
    
    //Local inits/allocs
    NSError *error = nil;
    NSString *urlString = [NSString stringWithFormat:@"http://itemdb-rs.runescape.com/results.ws?query="];
    NSURL *url = [NSURL URLWithString:[urlString stringByAppendingString:query]];
    NSData *urlContent = [NSData dataWithContentsOfURL:url];
    NSString *htmlContent = [[NSString alloc]initWithData:urlContent encoding:NSASCIIStringEncoding];
    
    //Parsing the query
    HTMLParser *parser = [[HTMLParser alloc] initWithString:htmlContent error:&error];
    HTMLNode *bodyNode = [parser body];
    HTMLNode *databaseItems = [bodyNode findChildTag:@"tbody"];
    htmlContent = [databaseItems rawContents];
    
    //placing results into 2 local arrays
    NSArray *itemNamesArray = [NSArray arrayWithArray:[databaseItems findChildTags:@"a"]];
    NSArray *itemPricesArray = [NSArray arrayWithArray:[databaseItems findChildrenWithAttribute:@"class" matchingName:@"price" allowPartial:YES]];
    //placing local arrays content into class arrays for ui use
    
    for (int i = 0; i<[[databaseItems findChildTags:@"img"] count] ; i=i+2)
        [itemImagesArray addObject:[[[databaseItems findChildTags:@"img"] objectAtIndex:i] getAttributeNamed:@"src"]];
    
    for (int i=0; i < [itemPricesArray count]; i++) {
        [itemNames addObject:[[itemNamesArray objectAtIndex:i] contents]];
        [itemPrices addObject:[[itemPricesArray objectAtIndex:i] contents]];
        [itemImages addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:[itemImagesArray objectAtIndex:i]]]];
    }
                
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


#pragma mark UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    firstQuery = YES;
    if (queryString != searchBar.text) {
        queryString = searchBar.text;
        
        [self.view.window addSubview:blockView2];
        //Setting up EGO
        if (_refreshHeaderView == nil) {
            EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
            view.delegate = self;
            [self.tableView addSubview:view];
            _refreshHeaderView = view;
        }
    
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGRect frame = spinner.frame;
        frame.origin.x = self.view.frame.size.width / 2 - frame.size.width / 2;
        frame.origin.y = self.view.frame.size.height / 2 - frame.size.height / 2;
        spinner.frame = frame;
        [self.view addSubview:spinner];
        [spinner startAnimating];

        [searchBar resignFirstResponder];
    
        dispatch_queue_t downloadQueue = dispatch_queue_create("loading GE results", NULL);
        dispatch_async(downloadQueue, ^{
            [self parseTheQuery:[queryString stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [spinner stopAnimating];
                [self.tableView reloadData];
                [blockView2 removeFromSuperview];
            });
        });
        dispatch_release(downloadQueue);
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
   // [self loadView];
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
    dispatch_queue_t downloadQueue = dispatch_queue_create("downloading GE results", NULL);
    dispatch_async(downloadQueue, ^{
        //reload searchInput here
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

@end
