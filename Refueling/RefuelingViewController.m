//
//  RefuelingViewController.m
//  Refueling
//
//  Created by Samuel on 20.06.13.
//  Copyright (c) 2013 Samuel Schepp. All rights reserved.
//

#import "RefuelingViewController.h"
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)

@interface RefuelingViewController () <UIActionSheetDelegate>

@end


@implementation RefuelingViewController

@synthesize scrollView, dateTextField, costsTextField, amountTextField, milageTextField, datePicker, row, refueling, navigationItem, dateLabel, amountLabel, odometerLabel, priceLabel, deleteButton, unitALabel, unitBLabel, unitCLabel, toolbar, infoLabel, amountUnit, currency, distanceUnit;



-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	//if(row == -1) [dateTextField becomeFirstResponder];
	
}

-(void)viewDidLoad {
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
	
	[dateTextField setInputView:datePicker];
	[self changedDatePicker:nil];
	
	UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
	[self.view addGestureRecognizer:singleTap];
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	
	amountUnit = @"L";
	if([[defaults objectForKey:@"amount_pref"]isEqual:@"1"])
	{
		amountUnit = @"gal";
	}
	
	currency = @"€";
	if([[defaults objectForKey:@"currency_pref"]isEqual:@"1"])
	{
		currency = @"$";
	}
	if([[defaults objectForKey:@"currency_pref"]isEqual:@"2"])
	{
		currency = @"SFr.";
	}
	
	distanceUnit = @"km";
	if([[defaults objectForKey:@"distance_pref"]isEqual:@"1"])
	{
		distanceUnit = @"mi";
	}
	[unitALabel setText:amountUnit];
	[unitBLabel setText:[NSString stringWithFormat:@"%@ / %@", currency, amountUnit]];
	[unitCLabel setText:distanceUnit];

	
	if(self.row == -1)
	{
		navigationItem.title = NSLocalizedString(@"Add fill-up", nil);
		[deleteButton setHidden:YES];
	}
	else
	{
		[infoLabel setHidden:YES];
		navigationItem.title = NSLocalizedString(@"Edit fill-up", nil);
		[deleteButton setHidden:NO];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];

		NSString *strDate = [dateFormatter stringFromDate:[refueling date]];
		[dateTextField setText:strDate];
		[datePicker setDate:[refueling date]];
		
		NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
		[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
		[formatter setGroupingSeparator:@""];
		
		[amountTextField setText:[NSString stringWithFormat:@"%@", [formatter stringFromNumber:[NSNumber numberWithDouble:[refueling amount]]]]];
		
		[costsTextField setText:[NSString stringWithFormat:@"%@", [formatter stringFromNumber:[NSNumber numberWithDouble:[refueling costs]]]]];
		
		[milageTextField setText:[NSString stringWithFormat:@"%@", [formatter stringFromNumber:[NSNumber numberWithInt:[refueling milage]]]]];
		
		[[self rowSwitch] setOn:[refueling starts]];
		[[self fullSwitch]setOn:[refueling partly]];
	}
	
	

	[dateLabel setText:NSLocalizedString(@"Date",nil)];
	[amountLabel setText:NSLocalizedString(@"Amount",nil)];
	[odometerLabel setText:NSLocalizedString(@"Odom.",nil)];
	[priceLabel setText:NSLocalizedString(@"Price",nil)];
	[deleteButton setTitle:NSLocalizedString(@"Delete fill-up",nil) forState:UIControlStateNormal];
	[[self startsLabel]setText:NSLocalizedString(@"I missed to enter prev. fill-up", nil)];
	[[self partlyLabel] setText:NSLocalizedString(@"I partly filled up", nil)];
	[infoLabel setText:NSLocalizedString(@"This app works best with only few partial fill-ups.", nil)];
	
	
	if(!self.deleteButton.isHidden)
	{
		self.scrollView.contentSize = CGSizeMake(320, 340);
	}
	else {
		self.scrollView.contentSize = CGSizeMake(320, 290);
	}
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    // create attributed string
    NSString *yourString = @"a string";  //can also use array[row] to get string
    NSDictionary *attributeDict = @{NSForegroundColorAttributeName : [UIColor blackColor]};
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:yourString attributes:attributeDict];
	
    // add the string to a label's attributedText property
    UILabel *labelView = [[UILabel alloc] init];
    labelView.attributedText = attributedString;
	
    // return the label
    return labelView;
}

-(void)keyboardWillShow:(id)sender
{
	int keyboardHeight = 216;
	UIEdgeInsets insets =  UIEdgeInsetsMake(scrollView.contentInset.top, scrollView.contentInset.left, keyboardHeight, scrollView.contentInset.right);
	[scrollView setContentInset:insets];
	[scrollView setScrollIndicatorInsets:insets];
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

-(void)handleSingleTap:(UITapGestureRecognizer *)sender{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setRefueling:(Refueling *)ref
{
	refueling = ref;
}

- (IBAction)pushCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pushSave:(id)sender {
    @try {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        
        
        NSDate* date = [datePicker date];
        double amount = [formatter numberFromString:amountTextField.text].doubleValue;
        double costs =  [formatter numberFromString:costsTextField.text].doubleValue;
        int milage = [formatter numberFromString:milageTextField.text].intValue;
		double starts = [[self rowSwitch]isOn];
		double partly = [[self fullSwitch]isOn];
        
        refueling = [[Refueling alloc] init];
        self.refueling.date = date;
        self.refueling.amount = amount;
        self.refueling.costs = costs;
        self.refueling.milage = milage;
		self.refueling.starts = starts;
		self.refueling.partly = partly;
    }
    @catch (NSException *exception) {
        
        return ;
    }
    
    if(row == -1)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"addRefueling" object:self];
    }
    else
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"editRefueling" object:self];
    }
	
	NSURLConnection *theConnection= [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:
																			[NSURL URLWithString:@"http://www.echopadder.bplaced.net/activity.php?kind=AddedRefueling&name=Refueling"]
																							cachePolicy:NSURLRequestReloadIgnoringCacheData
																						timeoutInterval:10.0] delegate:self];
	
	[theConnection start];
}

-(BOOL) checkValid
{
	return true;
}


- (IBAction)changedDatePicker:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSString *strDate = [dateFormatter stringFromDate:[datePicker date]];
    [dateTextField setText:strDate];
}

- (IBAction)pushDelete:(id)sender {
    UIActionSheet *myMenu = [[UIActionSheet alloc]
                             initWithTitle: nil
                             delegate:self
                             cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                             destructiveButtonTitle:NSLocalizedString(@"Delete fill-up", nil)
                             otherButtonTitles:nil];
    [myMenu showInView:self.view];
}

- (IBAction)pushInfo:(UIButton *)sender {
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIdx
{
    if(buttonIdx == 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteRefueling" object:nil];
    }
}
@end
