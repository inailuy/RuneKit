//
//  MapVC.m
//  RuneKit
//
//  Created by Yuliani Noriega on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MapVC.h"

@implementation MapVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *pathForImage = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"RuneScape_Worldmap"] ofType:@"png"];
    UIImage *worldMapImage = [[UIImage alloc] initWithContentsOfFile:pathForImage];
    worldMapImageView = [[UIImageView alloc] initWithImage:worldMapImage];
    
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    applicationFrame.origin.x = 0;
    applicationFrame.origin.y = 0;
	UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:applicationFrame];
	scrollView.contentSize = worldMapImage.size;
	[scrollView addSubview:worldMapImageView];
    
    scrollView.minimumZoomScale = .1;
	scrollView.maximumZoomScale = 1.0;
	scrollView.delegate = self;
    [scrollView setContentOffset:CGPointMake(2217, 1680)];
    [self.view addSubview:scrollView];
}


- (void)viewDidUnload
{
    //_view = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return worldMapImageView;
}

@end
