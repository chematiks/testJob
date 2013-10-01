//
//  CLDetailListViewController.h
//  testJobProject
//
//  Created by Администратор on 9/26/13.
//  Copyright (c) 2013 ChematiksLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLDetailListViewController : UIViewController
{
    UILabel * labelDetailTimeFrom;
    UILabel * labelDetailTimeTo;
    UILabel * labelSeatNumber;
    UILabel * labelTypeBuch;
    
    UITextField * fieldDetailTimeFrom;
    UITextField * fieldDetailTimeTo;
    UITextField * fieldSeatNumber;
    UITextField * fieldTypeBuch;
    
    NSRange range;
    
    int inputClass;
    
}

- (IBAction)changeTypeList:(id)sender;

-(IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)textFieldDidEndEditing:(id)sender;

@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (retain, nonatomic) IBOutlet UITextField *surnameField;
@property (retain, nonatomic) IBOutlet UITextField *nameLabel;
@property (retain, nonatomic) IBOutlet UITextField *otchestvoLabel;
@property (retain, nonatomic) IBOutlet UITextField *salaryLabel;

@end
