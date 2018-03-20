//
//  RefuelingsViewController.m
//  Refueling
//
//  Created by Samuel on 19.06.13.
//  Copyright (c) 2013 Samuel Schepp. All rights reserved.
//

#import "RefuelingsViewController.h"
#import "Refueling.h"
#import "RefuelingCell.h"
#import "RefuelingViewController.h"
#import "NoEntryCell.h"

@interface RefuelingsViewController () <UITableViewDelegate>
@end
@implementation RefuelingsViewController
@synthesize navigationBar, car, row, refuelingViewController, viewRefuelingViewController, statisticsViewController, amountUnit;



- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self.navigationItem setTitle:NSLocalizedString(@"Fill-ups", nil)];
}


- (IBAction)pushCompose:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    refuelingViewController = [storyboard instantiateViewControllerWithIdentifier:@"RefuelingViewController"];
    [[self navigationController]pushViewController:refuelingViewController animated:YES];
    refuelingViewController.row = -1;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.navigationItem.leftBarButtonItem setTitle:@""];
	/* GENERATED REFUELINGS
	if(refuelings.count == 0)
	{
		NSLog(@"refuelings.count == 0");
		int currentMilage = 0;
		NSDate* currentDate = [NSDate date];
		
		for(int i = 0; i < 100; i++)
		{
			Refueling* ref = [[Refueling alloc]init];
			
			ref.date = [currentDate dateByAddingTimeInterval:[self random:1123200 to:2160000]];
			currentDate = ref.date;
			
			ref.amount = [self random:18 to:25];
			
			ref.milage = currentMilage + [self random:300 to:350];
			currentMilage = ref.milage;
			
			ref.costs = [self random:1.6 to:1.7];
			
			[refuelings addObject:ref];
		}
		
		[[self tableView]reloadData];
	}
	*/
	
    [[NSNotificationCenter defaultCenter]postNotificationName:@"sortRefuelings" object:nil];
	[self.tableView reloadData];
	
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	amountUnit = @"L";
	if([[defaults objectForKey:@"amount_pref"]isEqual:@"1"])
	{
		amountUnit = @"gal";
	}
}

- (double)random:(double)from to:(double)to
{
	double rand = ((double)(arc4random() % 10)) / 10;
	double span = to - from;
	double number = span * rand;
	double finalNumber = number + from;
	return finalNumber;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(car.refuelings.count > 0)
    {
        return car.refuelings.count+2;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(car.refuelings.count == 0)
	{
		NoEntryCell* cell = [[NoEntryCell alloc]initWithType:@"refueling"];
		[tableView setScrollEnabled:NO];
		return cell;
	}
	
	[tableView setScrollEnabled:YES];
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonCell"];
        if (cell == nil) {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ButtonCell" owner:self options:nil];
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
        }
        
        if(![self shouldShowStatisticsButton])
        {
            [(ButtonCell*)cell setEnabled:NO];
        } else
        {
            [(ButtonCell*)cell setEnabled:YES];
        }
		[[(ButtonCell*)cell label]setText:NSLocalizedString(@"View statistics", nil)];
    }
    
    else if(indexPath.row == car.refuelings.count+1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"EmptyRefuelingCell"];
        if (cell == nil) {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"EmptyRefuelingCell" owner:self options:nil];
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
        }
        
    }
    else if (indexPath.row < car.refuelings.count+1 && indexPath.row > 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"RefuelingCell"];
        if (cell == nil) {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"RefuelingCell" owner:self options:nil];
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
        }
        // Configure the cell...
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        NSString *strDate = [dateFormatter stringFromDate:[[car.refuelings objectAtIndex:indexPath.row-1] date]];
        [[(RefuelingCell*)cell dateLabel] setText:strDate];
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [[(RefuelingCell*)cell amountLabel] setText:[NSString stringWithFormat:@"%@ %@", [formatter stringFromNumber:[NSNumber numberWithDouble:[[car.refuelings objectAtIndex:indexPath.row-1] amount]]], amountUnit]];
	}
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0 && [self shouldShowStatisticsButton])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        statisticsViewController = [storyboard instantiateViewControllerWithIdentifier:@"StatisticsViewController"];
        [[self navigationController]pushViewController:statisticsViewController animated:YES];
        [statisticsViewController setCar:[car copy]];
    }
    if(indexPath.row > 0 && indexPath.row < car.refuelings.count+1)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        viewRefuelingViewController = [storyboard instantiateViewControllerWithIdentifier:@"ViewRefuelingViewController"];
        [[self navigationController]pushViewController:viewRefuelingViewController animated:YES];
        [viewRefuelingViewController setRefueling:[car.refuelings objectAtIndex:indexPath.row-1]];
        viewRefuelingViewController.row = indexPath.row-1;
        //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (BOOL)shouldShowStatisticsButton {
	// Teilbetankungen verrechnen
	
	if(car.refuelings.count == 0) return false;
	
	Car* carCopy = [car copy];
	for(int i = 0; i < carCopy.refuelings.count - 1; i++) {
		if([[carCopy.refuelings objectAtIndex:i]partly]) {
			[[carCopy.refuelings objectAtIndex:i+1]setAmount:[[carCopy.refuelings objectAtIndex:i]amount] + [[carCopy.refuelings  objectAtIndex:i+1]amount]];
			
			if([[carCopy.refuelings objectAtIndex:i]starts]) {
				[[carCopy.refuelings objectAtIndex:i+1]setStarts:YES];
			}
			[carCopy.refuelings removeObjectAtIndex:i];
			i--;
		}
	}
	if([[carCopy.refuelings lastObject]partly]) {
		[carCopy.refuelings removeLastObject];
	}
	
	BOOL should = carCopy.refuelings.count > 1;
	return should;
	
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
	{
		return NO;
	}
	else
	{
		return NO;
	}
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete && indexPath > 0) {
        NSLog(@"Delete Refueling");
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(car.refuelings.count == 0)
	{
		return 320;
	}
    if(indexPath.row == 0) {
        return 75;
    }
    else if (indexPath.row > car.refuelings.count)
    {
        return 20;
    }
    else {
		if(indexPath.row < car.refuelings.count && indexPath.row >= 0)
		{
			if([[car.refuelings objectAtIndex:indexPath.row]starts])
			{
				return 70;
			}
		}
	}
	return 45;
}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

@end
