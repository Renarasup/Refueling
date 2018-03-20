//
//  GraphViewController.h
//  Refueling
//
//  Created by Samuel on 07.07.13.
//  Copyright (c) 2013 Samuel Schepp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNavigationController.h"
#import "QuartzCore/CALayer.h"

@interface GraphViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *patterImageView;
@property (weak, nonatomic) IBOutlet UIView *detailView;

@property (strong, nonatomic) IBOutlet UIImageView *averageImageView;
@property (weak, nonatomic) IBOutlet UIImageView *maxImageView;
@property (weak, nonatomic) IBOutlet UIImageView *minImageView;

@property (weak, nonatomic) IBOutlet UILabel *maxLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageLabel;
@property (weak, nonatomic) IBOutlet UILabel *minLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


@property (strong, nonatomic) NSMutableArray* dataY;
@property (strong, nonatomic) NSMutableArray* dataX;
@property (strong, nonatomic) NSNumber* average;
@property (strong, nonatomic) NSString* unitY;
@property (strong, nonatomic) NSString* unitX;

@property (weak, nonatomic) IBOutlet UILabel *unitYLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitXLabel;

@property BOOL animationDone;

-(void)prepareGraph;

@end
