//
//  ImportViewController.h
//  Refueling
//
//  Created by Samuel Schepp on 14.08.13.
//  Copyright (c) 2013 Samuel Schepp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImportCarCell.h"
#import "InfoCell.h"
#import "Car.h"
#import "CarsViewController.h"

@interface ImportViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *importButton;
@property (weak, nonatomic) IBOutlet UIView *importButtonView;
@property (strong, retain) Car* currentCar;

@property (strong, nonatomic) NSMutableArray* paths;
@property (strong, nonatomic) NSMutableArray* fileNames;
@property (strong, nonatomic) NSMutableArray* carsFromiCloud;
@property (strong, nonatomic) NSMutableArray* states;
@property (strong, nonatomic) NSMutableArray* importedCars;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property id delegate;

- (IBAction)pushImportButton:(UIBarButtonItem *)sender;
- (IBAction)pushRefresh:(id)sender;
- (IBAction)pushCancel:(id)sender;



@end
