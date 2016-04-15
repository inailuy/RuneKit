//
//  ContentCalcTVC.h
//  RuneKit
//
//  Created by yuL on 9/19/11.
//  Copyright 2011 Nidit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModifyContent.h"

@interface ContentCalcTVC : UITableViewController <ModifyContentDelegate>{
    NSMutableArray      *tableCellInfo;
    NSDictionary        *delegate;
    
    IBOutlet UITextField *textField;
    IBOutlet UISearchBar *search;
    
    NSString             *modifier;
    NSString             *skill;
    
    int count;
    int skillLevel;
    int currentEXP;
    int GoalEXP;
    int goalLevel;
}

@property (nonatomic, strong) NSMutableArray *tableCellInfo;
@property (nonatomic, strong) NSDictionary *delegate;
@property (nonatomic, strong) IBOutlet UITextField *textField;
@property (nonatomic, strong) IBOutlet UISearchBar *search;
@property (nonatomic, strong) NSString *modifier;
@property (nonatomic, strong) NSString *skill;
@property int count;
@property int skillLevel;
@property int currentEXP;
@property int GoalEXP;
@property int goalLevel;

@end