//
//  InfoViewController.m
//  Refueling
//
//  Created by Samuel Schepp on 16.09.13.
//  Copyright (c) 2013 Samuel Schepp. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

- (void) viewWillAppear:(BOOL)animated
{
	[self.label setText:NSLocalizedString(@"rowText", nil)];
	[self.label sizeToFit];
	[self.okButton setTitle:NSLocalizedString(@"OK, got that!", nil) forState:UIControlStateApplication];
}

- (IBAction)pushOK:(UIButton *)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
