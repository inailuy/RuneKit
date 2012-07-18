//
//  ModifyContent.m
//  RuneKit
//
//  Created by yuL on 10/12/11.
//  Copyright 2011 Nindit. All rights reserved.
//

#import "ModifyContent.h"

@implementation ModifyContent

@synthesize goal, exp, modifierSender;
@synthesize modifierText,modifierDigits, modifierDictionary;
@synthesize modifier;
@synthesize goalField, expField;
@synthesize toolbar;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (toolbar == nil) {
        toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
        
        UIBarButtonItem *previous = [[UIBarButtonItem alloc] initWithTitle:@"Previous" 
                                                                     style:UIBarButtonItemStyleBordered 
                                                                    target:self action:@selector(previousField:)];
        UIBarButtonItem *next = [[UIBarButtonItem alloc] initWithTitle:@"Next" 
                                                                 style:UIBarButtonItemStyleBordered 
                                                                target:self action:@selector(nextField:)];
        UIBarButtonItem *emptySpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace 
                                                                                    target:nil
                                                                                    action:nil];
        emptySpace.width = 119;
        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"Hide" 
                                                                 style:UIBarButtonItemStyleDone 
                                                                target:self action:@selector(hideClicked:)];
        [toolbar setItems:[NSArray arrayWithObjects:previous, next, emptySpace, done, nil]];
        
        toolbar.tintColor = [UIColor grayColor];
        toolbar.opaque = NO;
        toolbar.alpha = .2;
        
    }
    expField.inputAccessoryView = toolbar;
    goalField.inputAccessoryView = toolbar;
    
    self.navigationItem.title = @"Modify";
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    self.goalField.text = goal;
    self.expField.text = exp;
    
    self.modifierSender = @"1";
    
    self.modifierText = [self.modifierDictionary allKeys];
    self.modifierDigits = [self.modifierDictionary allValues];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.modifier = nil;
    self.goalField = nil;
    self.expField = nil;
    self.toolbar = nil;
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)previousField:(id)sender{
    if ([goalField isFirstResponder]) {
        [expField becomeFirstResponder];
    }
    else if ([expField isFirstResponder]){
        [goalField becomeFirstResponder];
    }
}

-(void)nextField:(id)sender{
    if ([expField isFirstResponder]) {
        [goalField becomeFirstResponder];
    }
    else if ([goalField isFirstResponder]){
        [expField becomeFirstResponder];
    } 
}

//hides keyboard
-(void)hideClicked:(id)sender{
    if ([goalField isFirstResponder]) {
        [goalField resignFirstResponder];
    }
    else if ([expField isFirstResponder]){
        [expField resignFirstResponder];
    }
}

//hides madal view
-(void)doneClicked:(id)sender{
    if ([goalField.text intValue] > 99) {
        goalField.text = @"99";
    }
    else if (goalField.text == @"0"){
        goalField.text = @"1";
    }
    if ([goalField isFirstResponder]) {
        [goalField resignFirstResponder];
    }
    else if ([expField isFirstResponder]){
        [expField resignFirstResponder];
    }
    
    [self.delegate modifyContent:self pickExp:self.expField.text withGoal:self.goalField.text andModifier:self.modifierSender];
}

#pragma UIPickerView Delegates

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.modifierDictionary.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.modifierText objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.modifierSender = [modifierDigits objectAtIndex:row];
}

@end
