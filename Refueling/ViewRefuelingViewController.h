//
//  ViewRefuelingViewController.h
//  Refueling
//
//  Created by Samuel on 20.06.13.
//  Copyright (c) 2013 Samuel Schepp. All rights reserved.
//

#import "Refueling.h"
#import <UIKit/UIKit.h>
#import "RefuelingViewController.h"

@interface ViewRefuelingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *previousButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *nextButtonItem;

@property (nonatomic) Refueling* refueling;
@property unsigned long row;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (nonatomic) RefuelingViewController* refuelingViewController;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *costsLabel;
@property (weak, nonatomic) IBOutlet UILabel *milageLabel;
@property (weak, nonatomic) IBOutlet UILabel *startsLabel;
@property (weak, nonatomic) IBOutlet UILabel *fullLabel;
@property (weak, nonatomic) IBOutlet UILabel *fullPriceLabel;

- (IBAction)editButtonPushed:(id)sender;
-(void) setRefueling:(Refueling*) ref;

//Local
@property (weak, nonatomic) IBOutlet UILabel *dateDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *odometerDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *startsDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *fullDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *fullPriceDescLabel;



@end
