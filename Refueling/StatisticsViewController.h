//
//  StatisticsViewController.h
//  Refueling
//
//  Created by Samuel on 25.06.13.
//  Copyright (c) 2013 Samuel Schepp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Refueling.h"
#import "GraphViewController.h"
#import "MyNavigationController.h"
#import "Car.h"
#import "AppDelegate.h"
#import "DocumentInteractionController.h"
#import "FilterViewController.h"

@interface StatisticsViewController : UITableViewController

- (void) setCar:(Car*)_car;
- (IBAction)didTapAction:(UIBarButtonItem *)sender;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet DocumentInteractionController* dic;
@property (weak, nonatomic) IBOutlet UILabel *filterLabel;

@property (weak, nonatomic) IBOutlet UILabel *labelA;
@property (weak, nonatomic) IBOutlet UILabel *labelB;
@property (weak, nonatomic) IBOutlet UILabel *labelC;
@property (weak, nonatomic) IBOutlet UILabel *labelD;
@property (weak, nonatomic) IBOutlet UILabel *labelE;
@property (weak, nonatomic) IBOutlet UILabel *labelF;
@property (weak, nonatomic) IBOutlet UILabel *labelG;
@property (weak, nonatomic) IBOutlet UILabel *labelH;
@property (weak, nonatomic) IBOutlet UILabel *labelI;
@property (weak, nonatomic) IBOutlet UILabel *labelJ;
@property (weak, nonatomic) IBOutlet UILabel *labelK;

//Local
@property (weak, nonatomic) IBOutlet UILabel *lA;
@property (weak, nonatomic) IBOutlet UILabel *lB;
@property (weak, nonatomic) IBOutlet UILabel *lC;
@property (weak, nonatomic) IBOutlet UILabel *lD;
@property (weak, nonatomic) IBOutlet UILabel *lE;
@property (weak, nonatomic) IBOutlet UILabel *lF;
@property (weak, nonatomic) IBOutlet UILabel *lG;
@property (weak, nonatomic) IBOutlet UILabel *lH;
@property (weak, nonatomic) IBOutlet UILabel *lI;
@property (weak, nonatomic) IBOutlet UILabel *lJ;
@property (weak, nonatomic) IBOutlet UILabel *lK;

@property NSString* amountUnit;
@property NSString* currency;
@property NSString* distanceUnit;

@end
