//
//  FilterViewController.m
//  Refueling
//
//  Created by Samuel Schepp on 07.02.14.
//  Copyright (c) 2014 Samuel Schepp. All rights reserved.
//

#import "FilterViewController.h"

@interface FilterViewController () <UITableViewDelegate, UITableViewDataSource>

@end

NSMutableArray* checks;

@implementation FilterViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
	[singleTap setCancelsTouchesInView:NO];
	[self.view addGestureRecognizer:singleTap];
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self initGUI];
	[self resetChecks:YES];
	[[self datePicker] setMaximumDate:[NSDate date]];
	
	[[self fromTextBox] setInputView:self.datePicker];
	[[self toTextBox] setInputView:self.datePicker];
}

-(void)resetChecks:(BOOL)checkFirst {
	if(checkFirst) {
		checks = [NSMutableArray arrayWithObjects:@"1", @"0", @"0", @"0", @"0", @"0", nil];
	}
	else {
		checks = [NSMutableArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", @"0", nil];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender{
    [self.view endEditing:YES];
}

#pragma mark Custom

-(void)initGUI {
	// LOCAL
	[[self fromLabel]setText:NSLocalizedString(@"From", nil)];
	[[self toLabel]setText:NSLocalizedString(@"To", nil)];
	[[self orLabel]setText:NSLocalizedString(@"or", nil)];
	[[self orLabel2]setText:NSLocalizedString(@"or", nil)];
	[[self applyButton]setTitle:NSLocalizedString(@"Apply", nil)];
	[[self noFilterButton]setText:NSLocalizedString(@"No filter", nil)];
	[[self customLabel]setText:NSLocalizedString(@"Custom", nil)];
	
	NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
	[formatter setDateStyle:NSDateFormatterShortStyle];
	
	NSCalendar* cal = [NSCalendar currentCalendar];
	
	NSDateComponents *components = [cal components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
	NSInteger month = [components month];
	NSInteger year = [components year];
	
	// DIESER MONAT
	NSDateComponents* thisMonth = [cal components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
	[thisMonth setDay:1];
	[thisMonth setMonth:month];
	[thisMonth setYear:year];
	NSDate* thisMonthDate = [cal dateFromComponents:thisMonth];
	[[self thisMonthButton] setText:[NSString stringWithFormat:@"%@",
									 NSLocalizedString(@"This Month", nil)]];
	[[self thisMonthDate] setText:[NSString stringWithFormat:@"%@ - %@",
								   [formatter stringFromDate:thisMonthDate],
								   [formatter stringFromDate:[NSDate date]]]];
	
	// LETZER MONAT
	NSDateComponents* lastMonth1 = [cal components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
	[lastMonth1 setDay:1];
	[lastMonth1 setMonth:month - 1];
	[lastMonth1 setYear:year];
	NSDateComponents* lastMonth2 = [cal components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
	NSRange range = [cal rangeOfUnit:NSCalendarUnitDay
							  inUnit:NSCalendarUnitMonth
							 forDate:[cal dateFromComponents:lastMonth1]];
	[lastMonth2 setDay:range.length];
	[lastMonth2 setMonth:month - 1];
	[lastMonth2 setYear:year];
	NSDate* lastMonthDate1 = [cal dateFromComponents:lastMonth1];
	NSDate* lastMonthDate2 = [cal dateFromComponents:lastMonth2];
	[[self lastMonthButton] setText:[NSString stringWithFormat:@"%@",
									 NSLocalizedString(@"Last Month", nil)]];
	[[self lastMonthDate] setText:[NSString stringWithFormat:@"%@ - %@",
									 [formatter stringFromDate:lastMonthDate1],
									 [formatter stringFromDate:lastMonthDate2]]];
	
	// Dieses Jahr
	NSDateComponents* thisYear = [cal components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
	[thisYear setDay:1];
	[thisYear setMonth:1];
	[thisYear setYear:year];
	
	NSDate* thisYearDate = [cal dateFromComponents:thisYear];
	[[self thisYearButton] setText:[NSString stringWithFormat:@"%@",
									 NSLocalizedString(@"This Year", nil)]];
	[[self thisYearDate] setText:[NSString stringWithFormat:@"%@ - %@",
									[formatter stringFromDate:thisYearDate],
									[formatter stringFromDate:[NSDate date]]]];
	
	// LETZES JAHR
	NSDateComponents* lastYear1 = [cal components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
	[lastYear1 setDay:1];
	[lastYear1 setMonth:1];
	[lastYear1 setYear:year - 1];
	
	NSDateComponents* lastYear2 = [cal components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
	[lastYear2 setDay:1];
	[lastYear2 setMonth:12];
	[lastYear2 setYear:year - 1];
	NSRange dayRange = [cal rangeOfUnit:NSCalendarUnitDay
							  inUnit:NSCalendarUnitMonth
							 forDate:[cal dateFromComponents:lastYear2]];
	[lastYear2 setDay:dayRange.length];
	NSDate* lastYearDate1 = [cal dateFromComponents:lastYear1];
	NSDate* lastYearDate2 = [cal dateFromComponents:lastYear2];
	[[self lastYearButton] setText:[NSString stringWithFormat:@"%@",
									 NSLocalizedString(@"Last Year", nil)]];
	[[self lastYearDate] setText:[NSString stringWithFormat:@"%@ - %@",
									[formatter stringFromDate:lastYearDate1],
									[formatter stringFromDate:lastYearDate2]]];
}

#pragma mark Actions

#pragma mark Text Field Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	if(![[checks objectAtIndex:1]isEqual:@"1"]) {
		[textField resignFirstResponder];
		[self resetChecks:NO];
		[checks replaceObjectAtIndex:1 withObject:@"1"];
		[[self tableView]reloadData];
		
		[textField becomeFirstResponder];
	}
	return YES;
}
/*
- (void)textFieldDidEndEditing:(UITextField *)textField {
	[self resetChecks];
	[checks replaceObjectAtIndex:4 withObject:@"1"];
	[[self tableView]reloadData];
}*/

#pragma mark Table View Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if([(NSString* )[checks objectAtIndex:indexPath.row] isEqual: @"1"]) {
		[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
		[cell setBackgroundColor:[UIColor colorWithRed:(39.0/255.0) green:(46.0/255.0) blue:(48.0/255.0) alpha:1]];
	} else {
		[cell setAccessoryType:UITableViewCellAccessoryNone];
		[cell setBackgroundColor:[UIColor colorWithRed:0.054 green:0.054 blue:0.054 alpha:1]];
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self resetChecks:NO];
	[checks replaceObjectAtIndex:indexPath.row withObject:@"1"];

	[tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
	//if(indexPath.row == 1 || indexPath.row == 3) return NO;
	return YES;
}


@end
