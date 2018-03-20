//
//  MasterViewController.h
//  Refueling
//
//  Created by Samuel on 17.06.13.
//  Copyright (c) 2013 Samuel Schepp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImportViewController.h"

@interface CarsViewController : UITableViewController

- (IBAction)toggleEditMode:(id)sender;
- (IBAction)insertObject:(id)sender;

-(void)disableEditMode:(BOOL)animanted;

@end
