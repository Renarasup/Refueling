//
//  DocumentInteractionControllerViewController.m
//  Refueling
//
//  Created by Samuel Schepp on 17.08.13.
//  Copyright (c) 2013 Samuel Schepp. All rights reserved.
//

#import "DocumentInteractionController.h"

@interface DocumentInteractionController () <UIDocumentInteractionControllerDelegate, MFMailComposeViewControllerDelegate>

@end

@implementation DocumentInteractionController

@synthesize documentInteractionController, fileNameLabel, doneButton, openButton, seperatedLabel;

-(void)viewWillAppear:(BOOL)animated
{
	[fileNameLabel setText:[[self.documentInteractionController.URL path] lastPathComponent]];
	[self.documentInteractionController setDelegate:self];
	
	[seperatedLabel setText:NSLocalizedString(@"Semicolon-separated", nil)];
	[openButton setTitle:NSLocalizedString(@"Open in ...", nil) forState:UIControlStateNormal];
}

- (IBAction)pushDoneButton:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pushOpen:(id)sender {
	[self.documentInteractionController presentOpenInMenuFromRect:self.view.frame inView:self.view animated:YES];
}

- (IBAction)pushEmail:(id)sender {
	
	MFMailComposeViewController* vc = [[MFMailComposeViewController alloc] init];
	[vc setSubject:documentInteractionController.URL.path.lastPathComponent];
	[vc setMailComposeDelegate:self];
	NSData* data = [NSData dataWithContentsOfFile:documentInteractionController.URL.path];
	[vc addAttachmentData:data mimeType:@"application/csv" fileName:documentInteractionController.URL.path.lastPathComponent];
	[self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	NSLog(@"Mail done");
	[controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIDocumentInteractionControllerDelegate

- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller {
    return self;
}

- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller
{
	return self.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller
{
	return self.view.frame;
}

@end
