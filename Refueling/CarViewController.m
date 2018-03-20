//
//  CarViewController.m
//  Refueling
//
//  Created by Samuel on 18.06.13.
//  Copyright (c) 2013 Samuel Schepp. All rights reserved.
//

#import "CarViewController.h"
#import "AppDelegate.h"
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)

@interface CarViewController  () <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end


@implementation CarViewController
@synthesize modelTextField, fuelTypeTextField, imageView, scrollView, modelLabel, fuelTypeLabel, deleteButton, car, currentImage;

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	//Local
	[modelLabel setText:NSLocalizedString(@"Model",nil)];
	[fuelTypeLabel setText:NSLocalizedString(@"Fuel type",nil)];
	[deleteButton setTitle:NSLocalizedString(@"Delete car",nil) forState:UIControlStateNormal];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
	
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
	
	if(self.row == -1)
	{
		[deleteButton setHidden:YES];
		[self navigationItem].title = NSLocalizedString(@"Add car", @"Add car");
		[scrollView setContentSize:CGSizeMake(320, 294)];
	}
	else
	{
		[self navigationItem].title = NSLocalizedString(@"Edit car", @"Edit car");
		[deleteButton setHidden:NO];
		[imageView setImage:car.image];
		[modelTextField setText:car.name];
		[fuelTypeTextField setText:car.fuelType];
		[scrollView setContentSize:CGSizeMake(320, 338)];
	}
	
	UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
	[self.view addGestureRecognizer:singleTap];
}

- (void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	self.modelTextField.inputAccessoryView = [UIView new];
	self.fuelTypeTextField.inputAccessoryView = [UIView new];
}

-(void)keyboardWillShow:(NSNotification *)sender
{
	CGRect keyboardBounds;
	[[sender.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardBounds];
	int keyboardHeight = keyboardBounds.size.height;
	
	
	UIEdgeInsets insets =  UIEdgeInsetsMake(0, 0, keyboardHeight, 0);
	[scrollView setContentInset:insets];
	[scrollView setScrollIndicatorInsets:insets];
	
	CGPoint buttom = CGPointMake(0, scrollView.contentSize.height - (scrollView.frame.size.height - scrollView.contentInset.bottom));
	
	// if screen < 480
	if([UIScreen mainScreen].bounds.size.height <= 480) {
		[scrollView setContentOffset:buttom animated:YES];
	}
}

-(void)keyboardDidShow:(id)sender
{
}

-(void)keyboardWillHide:(id)sender
{
	
	
	CGPoint buttom = CGPointMake(0, 0);
	[scrollView setContentOffset:buttom animated:YES];
	
}

-(void)keyboardDidHide:(id)sender
{
	[scrollView setContentInset:UIEdgeInsetsZero];
	[scrollView setScrollIndicatorInsets:UIEdgeInsetsZero];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if([modelTextField isFirstResponder])
	{
		[fuelTypeTextField becomeFirstResponder];
	}
	else if ([fuelTypeTextField isFirstResponder])
	{
		[modelTextField becomeFirstResponder];
	}
	return YES;
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)pushSave:(id)sender {
    if([[modelTextField text] isEqual: @""]) {
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@""
                                                             message:NSLocalizedString(@"Please enter a model.", @"Please enter a model.")
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
        [errorAlert show];
        [modelTextField becomeFirstResponder];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"saveCar" object:self];
		[self.navigationController popViewControllerAnimated:YES];
    }
}


- (IBAction)pushDelete:(id)sender {
	[modelTextField resignFirstResponder];
	[fuelTypeTextField resignFirstResponder];
	
    UIActionSheet *myMenu = [[UIActionSheet alloc]
                              initWithTitle: NSLocalizedString(@"Delete car?", nil)
                              delegate:self
                              cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")
                              destructiveButtonTitle:NSLocalizedString(@"Delete", @"Delete")
                              otherButtonTitles:nil];
    myMenu.tag = 1;
    [myMenu showInView:self.view];
}

- (IBAction)pushGetImage:(id)sender {
	[modelTextField resignFirstResponder];
	[fuelTypeTextField resignFirstResponder];
	
	UIActionSheet *myMenu;
	if([imageView image].size.width == CGSizeZero.width)
	{
        myMenu = [[UIActionSheet alloc] initWithTitle: nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Take photo", @"Take photo"), NSLocalizedString(@"Photo library", @"Photo library"), nil];
	}
	else {
		myMenu = [[UIActionSheet alloc]
				  initWithTitle: nil
				  delegate:self
				  cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")
				  destructiveButtonTitle:NSLocalizedString(@"Remove photo", nil)
				  otherButtonTitles:NSLocalizedString(@"Take photo", @"Take photo"), NSLocalizedString(@"Photo library", @"Photo library"), nil];
	}
	
	myMenu.tag = 3;
	[myMenu showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIdx
{
    if(actionSheet.tag == 1 && buttonIdx == 0)
    {
        UIActionSheet *myMenu = [[UIActionSheet alloc]
								 initWithTitle: NSLocalizedString(@"Caution! All your data will be lost!",nil)
                                  delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
								 destructiveButtonTitle:NSLocalizedString(@"Delete car", nil)
                                  otherButtonTitles:nil];
        myMenu.tag = 2;
        [myMenu showInView:self.view];
    }
    else if (actionSheet.tag == 2 && buttonIdx == 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteCar" object:self];
    }
    else if (actionSheet.tag == 3)
    {
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
		
		
		if([imageView image].size.width == CGSizeZero.width)
		{
			if(buttonIdx == 0)
			{
				if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
					picker.sourceType = UIImagePickerControllerSourceTypeCamera;
					[self presentViewController:picker animated:YES completion:nil];
				}
			}
			else if(buttonIdx == 1)
			{
				picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
				[self presentViewController:picker animated:YES completion:nil];
			}
		}
		else
		{
			if(buttonIdx == 1)
			{
				if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
					picker.sourceType = UIImagePickerControllerSourceTypeCamera;
					[self presentViewController:picker animated:YES completion:nil];
				}
			}
			else if(buttonIdx == 2)
			{
				picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
				[self presentViewController:picker animated:YES completion:nil];
			}
			else if (buttonIdx == 0)
			{
				[imageView setImage:nil];
			}
		}
    }
}

-(UIImage*)resize:(UIImage*)image
{
    UIImage *tempImage = nil;
    CGSize targetSize = CGSizeMake(540 ,image.size.height / (image.size.width / 540));
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectMake(0, 0, 0, 0);
    thumbnailRect.origin = CGPointMake(0.0,0.0);
    thumbnailRect.size.width  = targetSize.width;
    thumbnailRect.size.height = targetSize.height;
    
    [image drawInRect:thumbnailRect];
    
    tempImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tempImage;
}

-(UIImage*)crop:(UIImage*)image
{
    CGRect rect;
    rect.size.width = 540;
    rect.size.height = 292;
    rect.origin.x = 0;
    rect.origin.y = (image.size.height / 2) - (292 / 2);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    return [UIImage imageWithCGImage:imageRef];
}



- (void) imagePickerController: (UIImagePickerController *) picker didFinishPickingMediaWithInfo: (NSDictionary *) info {
    UIImage* largeImage = info[UIImagePickerControllerOriginalImage];
	[imageView setImage:[self crop:[self resize:largeImage]]];
	car.image = imageView.image;
	if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
	{
		UIImageWriteToSavedPhotosAlbum(largeImage, nil,nil,nil);
	}
	
	[picker dismissViewControllerAnimated:YES completion:nil];
	NSLog(@"Image setted");
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
