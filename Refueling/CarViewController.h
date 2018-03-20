//
//  CarViewController.h
//  Refueling
//
//  Created by Samuel on 18.06.13.
//  Copyright (c) 2013 Samuel Schepp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarsViewController.h"
#import "Car.h"
#import "SAScrollView.h"
#import "AppDelegate.h"

@interface CarViewController : UIViewController <UIActionSheetDelegate>
- (IBAction)pushCancel:(id)sender;
- (IBAction)pushSave:(id)sender;
- (IBAction)pushDelete:(id)sender;
- (IBAction)pushGetImage:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *modelTextField;
@property (weak, nonatomic) IBOutlet UITextField *fuelTypeTextField;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic)  NSUInteger row;
@property (strong, nonatomic) Car* car;
@property (strong, nonatomic) UIImage* currentImage;

@property id delegate;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;


//Local
@property (weak, nonatomic) IBOutlet UILabel *modelLabel;
@property (weak, nonatomic) IBOutlet UILabel *fuelTypeLabel;

@end
