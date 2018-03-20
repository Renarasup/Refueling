//
//  RefuelingViewController.h
//  Refueling
//
//  Created by Samuel on 20.06.13.
//  Copyright (c) 2013 Samuel Schepp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Refueling.h"

@interface RefuelingViewController : UIViewController

- (IBAction)pushCancel:(id)sender;
- (IBAction)pushSave:(id)sender;
- (IBAction)changedDatePicker:(id)sender;
- (IBAction)pushDelete:(id)sender;

- (IBAction)pushInfo:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UITextField *costsTextField;
@property (weak, nonatomic) IBOutlet UITextField *milageTextField;

@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;

@property (weak, nonatomic) IBOutlet UISwitch *rowSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *fullSwitch;




@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationItem;
@property (strong, nonatomic) Refueling* refueling;
@property unsigned long row;

//Local
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *odometerLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UIButton *beginsButton;
@property (weak, nonatomic) IBOutlet UILabel *startsLabel;
@property (weak, nonatomic) IBOutlet UILabel *partlyLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

//Prefs
@property (weak, nonatomic) IBOutlet UILabel *unitBLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitALabel;
@property (weak, nonatomic) IBOutlet UILabel *unitCLabel;


@property NSString* amountUnit;
@property NSString* currency;
@property NSString* distanceUnit;


@end
