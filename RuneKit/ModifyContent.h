//
//  ModifyContent.h
//  RuneKit
//
//  Created by yuL on 10/12/11.
//  Copyright 2011 Nindit. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ModifyContentDelegate;

@interface ModifyContent : UIViewController<UITextFieldDelegate>{
    NSString     *goal;
    NSString     *exp;
    NSString     *modifierSender;
    
    NSArray      *modifierText;
    NSArray      *moidfierDigits;
    NSDictionary *modifierDictionary;
    
    UIPickerView *modifier;
    UITextField  *goalField;
    UITextField  *expField;
    
    UIToolbar    *toolbar;
    
    id <ModifyContentDelegate> __unsafe_unretained delegate;
}

@property (copy) NSString *goal;
@property (copy) NSString *exp;
@property (copy) NSString *modifierSender;

@property (nonatomic, strong) IBOutlet UIPickerView *modifier;
@property (nonatomic, strong) IBOutlet UITextField  *goalField;
@property (nonatomic, strong) IBOutlet UITextField  *expField;
@property (nonatomic, strong)          UIToolbar    *toolbar;
@property (nonatomic, strong)          NSDictionary *modifierDictionary;
@property (nonatomic, strong)          NSArray      *modifierText;
@property (nonatomic, strong)          NSArray      *modifierDigits;
@property (unsafe_unretained) id <ModifyContentDelegate> delegate;

-(void)previousField:(id)sender;
-(void)nextField:(id)sender;
-(void)hideClicked:(id)sender;
-(void)doneClicked:(id)sender;


@end

@protocol ModifyContentDelegate

-(void)modifyContent:(ModifyContent *)sender pickExp:(NSString *)exp withGoal:(NSString *)goal andModifier:(NSString *)modifierString;

@end