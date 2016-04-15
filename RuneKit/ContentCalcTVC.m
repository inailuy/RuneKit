//
//  ContentCalcTVC.m
//  RuneKit
//
//  Created by yuL on 9/19/11.
//  Copyright 2011 Nindit. All rights reserved.
//

#import "ContentCalcTVC.h"
#import "ModifyContent.h"

@implementation ContentCalcTVC

@synthesize tableCellInfo, delegate;
@synthesize textField, search;
@synthesize modifier, skill;
@synthesize count, skillLevel, currentEXP, GoalEXP, goalLevel;

//algorithm that returns the experiance points for the given level entered
-(double)levelAlgo:(double) number{
	double a = 0;
	for(double i=1; i < number; i++)
		a += floor(i+300*pow(2,(i/7)));
    return (a/4);
}

-(float) expNeededForGoal{
    int current = self.currentEXP;
    int goal = [self levelAlgo:self.GoalEXP];
    
    return (goal - current);
}


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
    
    self.modifier = @"1";
    tableCellInfo = [NSMutableArray arrayWithObjects:[self.delegate allKeys], [self.delegate allValues], nil];
    
    //uinavigation item
    UIBarButtonItem *item = [[UIBarButtonItem alloc] 
                             initWithTitle:@"Modifier" 
                             style:UIBarButtonItemStylePlain 
                             target:self 
                             action:@selector(displayModifyContent:)];
    self.navigationItem.rightBarButtonItem = item;

}

-(void)displayModifyContent:(id)sender{
    NSString *skillDataPath = [[NSBundle mainBundle] pathForResource:@"SkillData" ofType:@"plist"];
    NSDictionary *preModifier = [NSDictionary dictionaryWithContentsOfFile:skillDataPath];
    NSDictionary *specificModifier = [preModifier objectForKey:@"modifier"];
    
    UINavigationController *nav = [[UINavigationController alloc] init];
    nav.navigationBar.barStyle = UIBarStyleDefault;
    
    ModifyContent *_modifyContent = [[ModifyContent alloc] init];
    _modifyContent.modifier = [specificModifier objectForKey:self.skill];
    _modifyContent.delegate = self;
    _modifyContent.exp = [NSString stringWithFormat:@"%i", currentEXP];
    _modifyContent.goal = [NSString stringWithFormat:@"%i", self.GoalEXP];
    _modifyContent.modifierDictionary = [specificModifier objectForKey:skill];
    [nav pushViewController:_modifyContent animated:NO];
    
    [self presentModalViewController:nav animated:YES];
}

-(void)modifyContent:(ModifyContent *)sender pickExp:(NSString *)exp withGoal:(NSString *)goal andModifier:(NSString *)modifierString{
    self.currentEXP = [exp intValue];
    self.GoalEXP = [goal intValue];
    self.modifier = modifierString;
    
    [self dismissModalViewControllerAnimated:YES];
    [self loadView];
    
}

- (void)viewDidUnload
{
    
    [super viewDidUnload];
    self.textField = nil;
    self.search = nil;
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    return [[tableCellInfo objectAtIndex:0] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    float num = ([self expNeededForGoal] / [[[tableCellInfo objectAtIndex:1] objectAtIndex:indexPath.row] floatValue]) / [self.modifier floatValue];
    NSNumberFormatter *format = [[NSNumberFormatter alloc] init];
    [format setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *number = [NSNumber numberWithInt:(int)num];
    NSString *FormatString = [format stringFromNumber:number];
    NSString *descriptor = [NSString stringWithFormat:@"%i", ([[[tableCellInfo objectAtIndex:1] objectAtIndex:indexPath.row] intValue] * [self.modifier intValue])];
    
    NSString *cellText = [NSString stringWithFormat:@"%@: %@",[[tableCellInfo objectAtIndex:0] objectAtIndex:indexPath.row], FormatString];
    
    cell.textLabel.text = cellText;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", descriptor];
    return cell;
}


#pragma mark - Table view delegate


@end
