//
//  MainPage.m
//  RuneKit App
//
//  Created by Yuliani Noriega on 12/20/11.
//  Copyright (c) 2011 RuneKit. All rights reserved.
//

#import "MainPage.h"
#import "ArticleViewController.h"

@implementation MainPage{
    ParserMAIN *xmlParser;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    UIActivityIndicatorView *spinner;
    NSDictionary *imageDictionary;
    
    NSArray *contentPassed;
    Reachability *internetConnection;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Start parsing the XML webpage
    [self parseTheLog];
    
    internetConnection = [Reachability reachabilityForInternetConnection];
    
    // Setting up Spinner for when class is retrieving data
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGRect frame = spinner.frame;
    frame.origin.x = self.view.frame.size.width / 2 - frame.size.width / 2;
    frame.origin.y = self.view.frame.size.height / 3 - frame.size.height / 2;
    spinner.frame = frame;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    // Setting path to images
    NSString *pathForImage1 = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"rsz_cat_1"] ofType:@"gif"];
    NSString *pathForImage2 = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"rsz_cat_2"] ofType:@"gif"];
    NSString *pathForImage3 = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"rsz_cat_3"] ofType:@"gif"];
    NSString *pathForImage4 = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"rsz_cat_4"] ofType:@"gif"];
    NSString *pathForImage6 = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"rsz_cat_6"] ofType:@"gif"];
    NSString *pathForImage9 = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"rsz_cat_9"] ofType:@"gif"];
    
    // Creating images
    UIImage *image1 = [UIImage imageWithContentsOfFile:pathForImage1];
    UIImage *image2 = [UIImage imageWithContentsOfFile:pathForImage2];
    UIImage *image3 = [UIImage imageWithContentsOfFile:pathForImage3];
    UIImage *image4 = [UIImage imageWithContentsOfFile:pathForImage4];
    UIImage *image6 = [UIImage imageWithContentsOfFile:pathForImage6];
    UIImage *image9 = [UIImage imageWithContentsOfFile:pathForImage9];
    
    // Making dictionary so that later show the right image that gets called by currentLog.catergory in "tableView: cellForRowAtIndexPath:"
    imageDictionary = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:image1, image2, image3, image4, image6, image9, nil] forKeys:[NSArray arrayWithObjects:@"Game Update News", @"Website News", @"Customer Support News", @"Technical News",@"Behind the Scenes News",@"Shop News", nil]];

    // Setting up EGO for pull down to Refresh
    if (_refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
        view.delegate = self;
        [self.tableView addSubview:view];
		_refreshHeaderView = view;
	}
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

// Retrieves XML data from Runescape's news page using blocks and places them in the ParserMain object so that it doesn't block the UI
- (void) parseTheLog
{
    dispatch_queue_t downloadQueue = dispatch_queue_create("News downloader", NULL);
    dispatch_async(downloadQueue, ^{
        NSString *url = [NSString stringWithFormat:@"http://services.runescape.com/m=news/g=runescape/latest_news.rss"];
        xmlParser = [[ParserMAIN alloc] loadXMLByURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            if (spinner) [spinner stopAnimating];
        });
    });
    dispatch_release(downloadQueue);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // The number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section if no internet connection return 0.
    if ([internetConnection isReachable]) return xmlParser.logs.count;
    else return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ArticleTabCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.textLabel.font = [UIFont systemFontOfSize:15.5];
    
    // Configure the cell...
    if ([internetConnection isReachable]){
        // Create the ParserMainObject From the xmlParser 
        ParserObjectMAIN *currentLog = [xmlParser.logs objectAtIndex:indexPath.row];
        
        // Set the text/subtext and image using the ParserObjectMain object
        cell.textLabel.text = currentLog.title;
        cell.detailTextLabel.text = [currentLog.pubDate substringToIndex:16];
        cell.imageView.image = [imageDictionary objectForKey:currentLog.category];
    }
    else {
        // Make everything Nil if internet connection is unreachable
        cell.detailTextLabel.text = Nil;
        cell.imageView.image = Nil;
        cell.textLabel.text = Nil;
    }

    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Create the next ViewController and send some delegate key information with Array called contentPassed
    ArticleViewController *article = [[ArticleViewController alloc] init];
    ParserObjectMAIN *passingLog = [xmlParser.logs objectAtIndex:indexPath.row];
    article.contentPassed = [NSArray arrayWithObjects:passingLog.title, passingLog.category, [passingLog.pubDate substringToIndex:16], [passingLog link], nil];
    
    // Push the next View Controller
    [self.navigationController pushViewController:article animated:YES];
    
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  Should be calling tableviews data source model to reload
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	
	//  Model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{		
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self parseTheLog];
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.7];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{	
	return [NSDate date]; // should return date data source was last changed
	
}

@end
