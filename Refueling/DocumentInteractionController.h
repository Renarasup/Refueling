//
//  DocumentInteractionControllerViewController.h
//  Refueling
//
//  Created by Samuel Schepp on 17.08.13.
//  Copyright (c) 2013 Samuel Schepp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Car.h"
#import "Refueling.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <CoreGraphics/CoreGraphics.h>


@interface DocumentInteractionController : UIViewController

@property (strong, nonatomic) UIDocumentInteractionController* documentInteractionController;

- (IBAction)pushDoneButton:(id)sender;
- (IBAction)pushOpen:(id)sender;
- (IBAction)pushEmail:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;

//Local
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *openButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UILabel *seperatedLabel;

@end
