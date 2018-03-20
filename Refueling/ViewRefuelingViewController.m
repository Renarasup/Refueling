//
//  ViewRefuelingViewController.m
//  Refueling
//
//  Created by Samuel on 20.06.13.
//  Copyright (c) 2013 Samuel Schepp. All rights reserved.
//

#import "ViewRefuelingViewController.h"

@interface ViewRefuelingViewController ()

@end

@implementation ViewRefuelingViewController

NSString* amountUnit;
NSString* currency;
NSString* distanceUnit;
@synthesize refueling, navigationBar, dateLabel, amountLabel, costsLabel, milageLabel, row, scrollView, editButton, refuelingViewController, toolbar, nextButtonItem, previousButtonItem, startsLabel, dateDescLabel, amountDescLabel, priceDescLabel, odometerDescLabel, fullPriceDescLabel, fullPriceLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        refueling = [[Refueling alloc] init];
        refuelingViewController = [[RefuelingViewController alloc]init];
        row = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
	
	[self.navigationItem setTitle:NSLocalizedString(@"Fill-up",nil)];
	[dateDescLabel setText:NSLocalizedString(@"Date",nil)];
	[amountDescLabel setText:NSLocalizedString(@"Amount",nil)];
	[odometerDescLabel setText:NSLocalizedString(@"Odometer",nil)];
	[priceDescLabel setText:NSLocalizedString(@"Price",nil)];
    [fullPriceDescLabel setText:NSLocalizedString(@"Full Price",nil)];
	[[self startsDescLabel]setText:NSLocalizedString(@"Missed previous fill-up?", nil)];
	[[self fullDescLabel]setText:NSLocalizedString(@"Partly filled up?", nil)];
	[[self startsLabel]setText:NSLocalizedString(@"no", nil)];
	[[self fullLabel]setText:NSLocalizedString(@"no", nil)];
	
	
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSString *strDate = [dateFormatter stringFromDate:[self.refueling date]];
    [dateLabel setText:strDate];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [amountLabel setText:[NSString stringWithFormat:@"%@ %@", [formatter stringFromNumber:[NSNumber numberWithDouble:[self.refueling amount]]], amountUnit]];
    
    [costsLabel setText:[NSString stringWithFormat:@"%@ %@ / %@", [formatter stringFromNumber:[NSNumber numberWithDouble:[self.refueling costs]]], currency, amountUnit]];
    
    [milageLabel setText:[NSString stringWithFormat:@"%@ %@", [formatter stringFromNumber:[NSNumber numberWithDouble:[self.refueling milage]]], distanceUnit]];
    
    float fullPrice = self.refueling.costs * (float)self.refueling.amount;
    [fullPriceLabel setText:[NSString stringWithFormat:@"%@ %@",
                             [formatter stringFromNumber:[NSNumber numberWithFloat:fullPrice]], currency]];
	
	if([refueling starts]) [self.startsLabel setText:NSLocalizedString(@"yes", nil)];
	if([refueling partly]) [self.fullLabel setText:NSLocalizedString(@"yes", nil)];
    
    CGFloat height = 450;
    [self.scrollView setContentSize:CGSizeMake(0, height)];
    NSLog(@"tst");
    NSLog(@"%f", height);
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self.scrollView setContentOffset:scrollView.contentOffset animated:NO];
    return YES;
}

-(void) setRefueling:(Refueling*)ref
{
    refueling = ref;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) didTapBackButton:(id)sender {
    [[self navigationController]popViewControllerAnimated:YES];
}
- (IBAction)editButtonPushed:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    refuelingViewController = [storyboard instantiateViewControllerWithIdentifier:@"RefuelingViewController"];
    [[self navigationController]pushViewController:refuelingViewController animated:YES];
    [refuelingViewController setRefueling:self.refueling];
    refuelingViewController.row = self.row;
}

@end
