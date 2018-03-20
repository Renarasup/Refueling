//
//  FilterViewController.h
//  Refueling
//
//  Created by Samuel Schepp on 07.02.14.
//  Copyright (c) 2014 Samuel Schepp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Car.h"

@interface FilterViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *applyButton;

@property (weak, nonatomic) IBOutlet UILabel *noFilterButton;
@property (weak, nonatomic) IBOutlet UILabel *noFilterDate;
@property (weak, nonatomic) IBOutlet UILabel *thisMonthButton;
@property (weak, nonatomic) IBOutlet UILabel *lastMonthButton;
@property (weak, nonatomic) IBOutlet UILabel *thisYearButton;
@property (weak, nonatomic) IBOutlet UILabel *lastYearButton;
@property (weak, nonatomic) IBOutlet UILabel *thisMonthDate;
@property (weak, nonatomic) IBOutlet UILabel *lastMonthDate;
@property (weak, nonatomic) IBOutlet UILabel *thisYearDate;
@property (weak, nonatomic) IBOutlet UILabel *lastYearDate;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (weak, nonatomic) IBOutlet UILabel *customLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *toLabel;
@property (weak, nonatomic) IBOutlet UITextField *fromTextBox;
@property (weak, nonatomic) IBOutlet UITextField *toTextBox;
@property (weak, nonatomic) IBOutlet UILabel *orLabel;
@property (weak, nonatomic) IBOutlet UILabel *orLabel2;

@property (strong, nonatomic) NSDate* customStartDate;
@property (strong, nonatomic) NSDate* customEndDate;

@property (strong, nonatomic) Car* car;
@end
