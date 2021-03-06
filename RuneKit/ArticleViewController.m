//
//  ArticleViewController.m
//  RuneKit
//
//  Created by Yuliani Noriega on 12/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ArticleViewController.h"

@implementation ArticleViewController

@synthesize contentPassed;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

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
    
//     Might need later
    
//    completeTitleLabel.layer.borderWidth = 2.5;
//    completeTitleLabel.layer.borderColor = [UIColor grayColor].CGColor;
//    titleLabel.text = [contentPassed objectAtIndex:0];
//    categoryLabel.text = [contentPassed objectAtIndex:1];
//    dateLabel.text = [contentPassed objectAtIndex:2];
    
    //Spinner initiation
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGRect frame = spinner.frame;
    frame.origin.x = self.view.frame.size.width / 2 - frame.size.width / 2;
    frame.origin.y = self.view.frame.size.height / 3 - frame.size.height / 2;
    spinner.frame = frame;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    //Block for loading the article, so that it doesn't freeze the UI.
    dispatch_queue_t downloadQueue = dispatch_queue_create("new content downloader", NULL);
    dispatch_async(downloadQueue, ^{
        NSError *error = nil;
        NSArray *inputNodes = [[NSArray alloc] init];
        NSURL *url = [[NSURL alloc] initWithString:[contentPassed objectAtIndex:3]];
        NSData *urlContent = [[NSData alloc] initWithContentsOfURL:url];
        NSString *htmlContent = [[NSString alloc]initWithData:urlContent encoding:NSASCIIStringEncoding];
        HTMLParser *parser = [[HTMLParser alloc] initWithString:htmlContent error:&error];
        HTMLNode *bodyNode = [parser body];
        inputNodes = [bodyNode findChildrenWithAttribute:@"class" matchingName:@"Article" allowPartial:YES];
        //Back into the main thread to do some UI calls.
        dispatch_async(dispatch_get_main_queue(), ^{
            loading.text = nil;
            article.text = [[[inputNodes objectAtIndex:0] allContents] substringFromIndex:4];
            article.selectedRange = [article.text rangeOfString:[contentPassed objectAtIndex:0]];
            article.editable=NO;
            if (spinner) [spinner stopAnimating];
        });
    });
    dispatch_release(downloadQueue);
}

- (void)viewDidUnload
{
    categoryLabel = nil;
    dateLabel = nil;
    titleLabel = nil;
    completeTitleLabel = nil;
    titleLabel = nil;
    categoryLabel = nil;
    dateLabel = nil;
    completeTitleLabel = nil;
    article = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
