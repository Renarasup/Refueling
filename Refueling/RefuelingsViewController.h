//
//  RefuelingsViewController.h
//  Refueling
//
//  Created by Samuel on 19.06.13.
//  Copyright (c) 2013 Samuel Schepp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefuelingViewController.h"
#import "ViewRefuelingViewController.h"
#import "StatisticsViewController.h"
#import "ButtonCell.h"
#import "Car.h"

@interface RefuelingsViewController : UIViewController 
@property NSString* amountUnit;

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)pushCompose:(id)sender;

@property (nonatomic) Car* car;
@property (nonatomic) RefuelingViewController* refuelingViewController;
@property (nonatomic) ViewRefuelingViewController* viewRefuelingViewController;
@property (nonatomic) StatisticsViewController* statisticsViewController;
@property unsigned long row;

@end
