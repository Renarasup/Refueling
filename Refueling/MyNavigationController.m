//
//  MyNavigationControllerViewController.m
//  Refueling
//
//  Created by Samuel Schepp on 10.08.13.
//  Copyright (c) 2013 Samuel Schepp. All rights reserved.
//

#import "MyNavigationController.h"

@interface MyNavigationController ()

@end

@implementation MyNavigationController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
-(NSUInteger)supportedInterfaceOrientations
{
	id currentViewController = self.topViewController;
	
    if ([currentViewController isKindOfClass:[GraphViewController class]])
	{
        return (UIInterfaceOrientationMaskAll);
	}
	
    return UIInterfaceOrientationMaskPortrait;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
	id currentViewController = self.topViewController;
	
    if ([currentViewController isKindOfClass:[GraphViewController class]])
	{
        return (UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight | UIInterfaceOrientationPortrait);
	}
	
    return UIInterfaceOrientationPortrait;
}
 */

@end
