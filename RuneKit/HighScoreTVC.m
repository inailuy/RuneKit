//
//  HighScoreTVC.m
//  RuneKit
//
//  Created by Yuliani Noriega on 12/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "HighScoreTVC.h"
#import "ContentCalcTVC.h"

@implementation HighScoreTVC

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
//    stats = [[NSMutableArray alloc] init];
//    skills = [[NSMutableArray alloc] init];
    //[self.navigationController setNavigationBarHidden:YES];
    
    
    //Creating UISearchbar
    searchBarInput = [[UISearchBar alloc] init];
    searchBarInput.barStyle = 1;
    searchBarInput.placeholder = @"UserName";
    searchBarInput.delegate = (id)self;
    searchBarInput.autocapitalizationType = UITextAutocapitalizationTypeNone;
    //[self.view insertSubview:searchBarInput atIndex:0];
    [searchBarInput sizeToFit];
    self.navigationItem.titleView = searchBarInput;
    
    
    //blockerView when keyboard is up
    blockView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 340, 800)];
    blockView.backgroundColor = [UIColor blackColor];
    blockView.alpha = .75;
    UITapGestureRecognizer *blockerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [blockerTap setNumberOfTapsRequired:1];
    UISwipeGestureRecognizer *swipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [swipeGR setDirection:UISwipeGestureRecognizerDirectionUp];
    [swipeGR setDirection:UISwipeGestureRecognizerDirectionRight];
    [swipeGR setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeGR setDirection:UISwipeGestureRecognizerDirectionDown];
    [blockView addGestureRecognizer:blockerTap];
    [blockView addGestureRecognizer:swipeGR];
    
    //creating array of names of all the skills
    didEnterInput = NO;
    NSString * skillDataPath = [[NSString alloc] init];
    skillDataPath = [[NSBundle mainBundle] pathForResource:@"SkillData" ofType:@"plist"];
    skillData = [NSDictionary dictionaryWithContentsOfFile:skillDataPath];
    skills = [[NSMutableArray alloc] initWithArray:[skillData objectForKey:@"skillNames"]];
    skillImages = [[NSMutableArray alloc] init];  
    
    //creating array of all the mini skill images
    for (int i = 0; i < 26; i++){
        NSString *pathForImage = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"skill_%i",i] ofType:@"gif"];
        UIImage *image = [UIImage imageWithContentsOfFile:pathForImage];
        [skillImages addObject:image];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) formatingSkills:(NSString *) rawInput{
    if (rawInput != @"_") {
        NSArray *triples = [rawInput componentsSeparatedByString:@"\n"];
        NSMutableArray *matrix = [[NSMutableArray alloc] init];
        for (NSString *triple in triples) {
            [matrix addObject:[triple componentsSeparatedByString:@","]];
        }
        stats = matrix;
    }
}

-(NSString *)retrieveUserData:(NSString *) user{
    user = [user stringByReplacingOccurrencesOfString:@" " withString:@"_"];
	NSString *link = [NSString stringWithFormat:@"http://hiscore.runescape.com/index_lite.ws?player="];
	NSString * urlstring = [link stringByAppendingString:user];
	NSURL *url = [NSURL URLWithString:urlstring];
	NSString *string = [NSString stringWithContentsOfURL:url usedEncoding:NULL error:NULL];
    
    if (string) return string;
    else return @"_";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (stats)
        return [skills count];
    else
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    if ((tableViewIsPopulated && indexPath.row != 25 && indexPath.row != 19 && indexPath.row != 0) && [[[stats objectAtIndex:indexPath.row] objectAtIndex:1] intValue] != 99){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (stats.count) {
        tableViewIsPopulated = YES;
        if ([[[stats objectAtIndex:indexPath.row] objectAtIndex:2] intValue] > 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@: %@",[skills objectAtIndex:indexPath.row], [[stats objectAtIndex:indexPath.row] objectAtIndex:1]];
            cell.imageView.image = [skillImages objectAtIndex:indexPath.row];
            
            NSNumberFormatter *format = [[NSNumberFormatter alloc] init];
            [format setNumberStyle:NSNumberFormatterDecimalStyle];
            NSNumber *number = [NSNumber numberWithInt:[[[stats objectAtIndex:indexPath.row] objectAtIndex:2] intValue]];
            NSString *FormatString = [format stringFromNumber:number];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Xp: %@", FormatString];
        }
        else{
            cell.textLabel.text = [NSString stringWithFormat:@"%@: ?",[skills objectAtIndex:indexPath.row]];
            cell.imageView.image = [skillImages objectAtIndex:indexPath.row];
            cell.detailTextLabel.text = nil;
        }
    }
    else{
        tableViewIsPopulated = NO;
        cell.imageView.image = nil;
        cell.textLabel.text = nil;
        cell.detailTextLabel.text = nil;
        cell.accessoryType = UITableViewCellAccessoryNone;
        if (didEnterInput)
            if (indexPath.row == 0) cell.textLabel.text = @"        User Name does not exist";
    }
    
    return cell;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (stats) {
        if ((tableViewIsPopulated && indexPath.row != 25 && 
             indexPath.row != 19 && indexPath.row != 0) && 
            [[[stats objectAtIndex:indexPath.row] objectAtIndex:1] intValue] != 99) {
            ContentCalcTVC *subview = [[ContentCalcTVC alloc] initWithStyle:UITableViewStylePlain];
            
            subview.skillLevel = [[[stats objectAtIndex:indexPath.row] objectAtIndex:1] intValue];
            subview.delegate = [[skillData objectForKey:@"skill"] objectForKey:[NSString stringWithFormat:@"%i", indexPath.row]];
            subview.title = [skills objectAtIndex:indexPath.row];
            subview.currentEXP = [[[stats objectAtIndex:indexPath.row] objectAtIndex:2] intValue];
            subview.GoalEXP = [[[stats objectAtIndex:indexPath.row] objectAtIndex:1] intValue] + 1;
            subview.skill = [NSString stringWithFormat:@"%i",indexPath.row];
            
            [self.navigationController pushViewController:subview animated:YES];
        }
    }
}

#pragma mark - SearchBar Delegate Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    //Setting up EGO
    if (_refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
        view.delegate = self;
        [self.tableView addSubview:view];
		_refreshHeaderView = view;
	}
    
    stats = nil;
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    CGRect frame = spinner.frame;
    frame.origin.x = self.view.frame.size.width / 2 - frame.size.width / 2;
    frame.origin.y = self.view.frame.size.height / 1.8 - frame.size.height / 2;
    spinner.frame = frame;
    [self.view.window addSubview:spinner];
    [spinner startAnimating];
    
    NSString *passingString = [NSString stringWithString:searchBar.text];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("userName downloader", NULL);
    dispatch_async(downloadQueue, ^{
        NSString *stringData = [NSString stringWithString:[self retrieveUserData:passingString]];
        currentSearchFieldInput = passingString;
        [self formatingSkills:stringData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [spinner stopAnimating];
        });
    });
    dispatch_release(downloadQueue);
    [searchBar resignFirstResponder];

    
    didEnterInput = YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
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
        NSString *stringData = [NSString stringWithString:[self retrieveUserData:currentSearchFieldInput]];
        [self formatingSkills:stringData];
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
