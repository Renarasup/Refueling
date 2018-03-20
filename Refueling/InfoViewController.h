//
//  InfoViewController.h
//  Refueling
//
//  Created by Samuel Schepp on 16.09.13.
//  Copyright (c) 2013 Samuel Schepp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoViewController : UIViewController

- (IBAction)pushOK:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *okButton;

@end
