//
//  MasterViewController.m
//  Refueling
//
//  Created by Samuel on 17.06.13.
//  Copyright (c) 2013 Samuel Schepp. All rights reserved.
//

#import "CarsViewController.h"
#import "CarCell.h"
#import "CarViewController.h"
#import "RefuelingsViewController.h"
#import "Car.h"
#import "NoEntryCell.h"

@interface CarsViewController () {
    NSMutableArray *cars;
    CarViewController *carViewController;
    RefuelingsViewController* refuelingsViewController;
	ImportViewController* importViewController;

}
@end

@implementation CarsViewController

- (void)awakeFromNib
{
	[super awakeFromNib];
	[self.editButtonItem setTitle:NSLocalizedString(@"Edit",nil)];
	[self.navigationItem setTitle:NSLocalizedString(@"My cars", nil)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
    cars = [NSMutableArray array];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"cars"];
    if(data == NULL)
    {
        cars = [NSMutableArray array];
        NSLog(@"cars = [NSMutableArray array]");
    } else {
        cars = [NSKeyedUnarchiver unarchiveObjectWithData:data];
		NSLog(@"cars loaded");
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveCar:) name:@"saveCar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteCar:) name:@"deleteCar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveDataInBackground:) name:@"saveData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveData:) name:@"saveDataInForeground" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addRefueling:) name:@"addRefueling" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editRefueling:) name:@"editRefueling" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteRefueling:) name:@"deleteRefueling" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sortRefuelings:) name:@"sortRefuelings" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(carsImported:) name:@"carsImported" object:nil];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	//[self disableEditMode:YES];
}

-(void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	
	if(cars.count == 0)[self disableEditMode:YES];
	[self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)insertObject:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
	carViewController = [storyboard instantiateViewControllerWithIdentifier:@"CarViewController"];
	[carViewController setDelegate:self];
    [self.navigationController pushViewController:carViewController animated:YES];
    carViewController.row = -1;
}

-(void) saveDataInBackground:(NSNotification*) not
{
	[self performSelectorInBackground:@selector(saveData:) withObject:nil];
}

- (void) saveData:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cars];
    [defaults setObject:data forKey:@"cars"];
    NSLog(@"saved");
    [self backup];
}

-(void) backup {
	
	// iTunes
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	if([[NSUserDefaults standardUserDefaults] boolForKey:@"itunesbackup_pref"])
	{
		if ([paths count] > 0)
		{
			for(int i = 0; i < cars.count; i++)
			{
				NSString  *dictPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", ((Car*)[cars objectAtIndex:i]).name]];
				[NSKeyedArchiver archiveRootObject:[cars objectAtIndex:i] toFile:dictPath];
				NSLog(@"%@ written to NSDocumentDirectory", [NSString stringWithFormat:@"%@.plist", ((Car*)[cars objectAtIndex:i]).name]);
			}
		}
	}
	else {
		NSArray *_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [_paths objectAtIndex:0];
		NSMutableArray* _fileNames = [NSMutableArray arrayWithArray:[[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:nil]];
		_fileNames = [NSMutableArray arrayWithArray:[_fileNames filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF endswith '.plist'"]]];
		for(int i = 0; i < _fileNames.count; i++)
		{
			[[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@", documentsDirectory, [_fileNames objectAtIndex:i]] error:nil];
			NSLog(@"(iTunes) Did Delete: %@", [_fileNames objectAtIndex:i]);
		}
	}
	
	
	// iCloud
	
	if([[NSUserDefaults standardUserDefaults] boolForKey:@"icloudbackup_pref"])
	{
		NSUbiquitousKeyValueStore *keyStore =
		[[NSUbiquitousKeyValueStore alloc] init];
		Car* tinyCar = [Car new];
		
		for (int i = 0; i < cars.count; i++) {
			tinyCar.name = ((Car*)[cars objectAtIndex:i]).name;
			tinyCar.refuelings = ((Car*)[cars objectAtIndex:i]).refuelings;
			tinyCar.fuelType = ((Car*)[cars objectAtIndex:i]).fuelType;
			[keyStore setObject:[NSKeyedArchiver archivedDataWithRootObject:tinyCar] forKey:tinyCar.name];
			NSLog(@"Written to iCloud: %@", tinyCar.name);
		}
	}
	else {
		NSUbiquitousKeyValueStore *keyStore =
		[[NSUbiquitousKeyValueStore alloc] init];
		NSArray* allkeys = [NSArray array];
		allkeys = [[keyStore dictionaryRepresentation]allKeys];
		for(int i = 0; i < allkeys.count; i++)
		{
			[keyStore removeObjectForKey:[allkeys objectAtIndex:i]];
			NSLog(@"Removed from iCloud: %@", [allkeys objectAtIndex:i]);
		}
	}
}

- (void) carsImported:(NSNotification*) not
{
	for (Car* car in importViewController.importedCars) {
		[cars insertObject:car atIndex:0];
	}
	[[self tableView]reloadData];
	[self saveDataInBackground:nil];
}

#pragma mark - Car

- (void) addRefueling:(id)sender
{
    [[[cars objectAtIndex:refuelingsViewController.row] refuelings] addObject:refuelingsViewController.refuelingViewController.refueling];
    [self sortRefuelings:sender];
    [[refuelingsViewController tableView] reloadData];
	[self saveDataInBackground:nil];
	[refuelingsViewController.refuelingViewController.navigationController popViewControllerAnimated:YES];
}
- (void) editRefueling:(id)sender
{
    [[[cars objectAtIndex:refuelingsViewController.row] refuelings] replaceObjectAtIndex:refuelingsViewController.viewRefuelingViewController.row withObject:refuelingsViewController.viewRefuelingViewController.refuelingViewController.refueling];
    [refuelingsViewController.tableView reloadData];
    [refuelingsViewController.viewRefuelingViewController setRefueling:[refuelingsViewController.car.refuelings objectAtIndex:refuelingsViewController.viewRefuelingViewController.refuelingViewController.row]];
	[self saveDataInBackground:nil];
	[refuelingsViewController.viewRefuelingViewController.refuelingViewController.navigationController popViewControllerAnimated:YES];
}

- (void) sortRefuelings:(id)sender
{
    [[[cars objectAtIndex:refuelingsViewController.row] refuelings] sortUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *date1 = [(Refueling*)a date];
        NSDate *date2 = [(Refueling*)b date];
        return [date1 compare:date2];
    }];
}

- (void) deleteRefueling:(id)sender
{
    [[[cars objectAtIndex:refuelingsViewController.row] refuelings] removeObjectAtIndex:refuelingsViewController.viewRefuelingViewController.row];
    [refuelingsViewController.tableView reloadData];
    //[refuelingsViewController.viewRefuelingViewController.navigationController popViewControllerAnimated:NO];
    [refuelingsViewController.viewRefuelingViewController.refuelingViewController.navigationController popToViewController:refuelingsViewController animated:YES];
	[self saveDataInBackground:nil];
}

- (void)saveCar:(NSNotification *)notification
{
    if(carViewController.row == -1)
    {
        Car *car = [[Car alloc] init];
        car.name = carViewController.modelTextField.text;
        car.fuelType = carViewController.fuelTypeTextField.text;
        car.image = carViewController.imageView.image;
        [cars insertObject:car atIndex:0];
    } else {
        Car *car = [[Car alloc] init];
        car.name = carViewController.modelTextField.text;
        car.fuelType = carViewController.fuelTypeTextField.text;
        car.image = carViewController.imageView.image;
        car.refuelings = [[cars objectAtIndex:carViewController.row]refuelings];
        [cars replaceObjectAtIndex:[carViewController row] withObject:car];
    }
    [[self tableView]reloadData];
    [self saveDataInBackground:nil];
}

-(void)deleteCar:(NSNotification *) notification
{
    [cars removeObjectAtIndex:carViewController.row];
    [carViewController.navigationController popViewControllerAnimated:YES];
    [[self tableView]reloadData];
	[self saveDataInBackground:nil];
}

-(void)importPushed:(id)sender
{
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
	importViewController = [storyboard instantiateViewControllerWithIdentifier:@"ImportViewController"];
	[importViewController setDelegate:self];
	[[self navigationController] pushViewController:importViewController animated:YES];
}


#pragma mark - Table View

- (IBAction) toggleEditMode:(id)sender {
	
    if([self.editButtonItem.title isEqual: NSLocalizedString(@"Edit", @"Edit")])
    {
		[self.tableView beginUpdates];
        [self.tableView setEditing:YES animated:NO];
        [(UIBarButtonItem*)sender setTitle:NSLocalizedString(@"Done", @"Done")];
		NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
		[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationTop];
		[self.tableView endUpdates];
    }
    else if([self.editButtonItem.title isEqual: NSLocalizedString(@"Done", @"Done")]) {
		[self.tableView beginUpdates];
        [self.tableView setEditing:NO animated:NO];
        [(UIBarButtonItem*)sender setTitle:NSLocalizedString(@"Edit", @"Edit")];
		NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
		[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationTop];
		[self.tableView endUpdates];
    }
}

- (void) disableEditMode:(BOOL)animated {
    if(self.tableView.isEditing)
	{
        [self.tableView setEditing:NO animated:NO];
        [self.editButtonItem setTitle:NSLocalizedString(@"Edit", @"Edit")];
		NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
		if(cars.count > 0)
		{
			if(animated) [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationRight];
			else [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
		}
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(cars.count == 0)
    {
        [self.editButtonItem setEnabled:NO];
		return 1;
    }
    else
    {
        [self.editButtonItem setEnabled:YES];
    }
	
	if(tableView.editing)
	{
		return cars.count+1;
	}
    return cars.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(cars.count == 0)
	{
		NoEntryCell* cell = [[NoEntryCell alloc]initWithType:@"car"];
		[tableView setScrollEnabled:NO];
		[cell.importButton addTarget:self action:@selector(importPushed:) forControlEvents:UIControlEventTouchUpInside];
		return cell;
	}
	
	NSInteger row = [indexPath row];
	if(indexPath.row == 0 && self.tableView.isEditing)
	{
		ButtonCell* cell;
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ButtonCell" owner:self options:nil];
		cell = [topLevelObjects objectAtIndex:0];
		cell.label.text = NSLocalizedString(@"Import cars", nil);
		return cell;
	}
	if([tableView isEditing])
	{
		row -=1;
	}
	
	if(row < cars.count && row > -1)
	{
	
		CarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CarCell"];
		if (cell == nil) {
			// Load the top-level objects from the custom cell XIB.
			NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CarCell" owner:self options:nil];
			// Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
			cell = [topLevelObjects objectAtIndex:0];
		}
    
		// Configure the cell...
		[[cell label] setText:[[cars objectAtIndex:row] name]];
		[[cell imageView] setImage: [((Car* )[cars objectAtIndex:row]) image]];
		if(CGSizeEqualToSize(cell.imageView.image.size, CGSizeZero))
		{
			[[cell imageView]setImage:[UIImage imageNamed:@"emptycar.png"]];
		}
		[tableView setScrollEnabled:YES];
		[cell setEditing:[tableView isEditing] animated:NO];
		return cell;
	}
	return [[ButtonCell alloc]init];
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEditing])
    {
        NSInteger row = [indexPath row];
		if(indexPath.row == 0)
		{
			[self importPushed:nil];
			return;
		}
		row -= 1;
		
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
		carViewController = [storyboard instantiateViewControllerWithIdentifier:@"CarViewController"];
		[carViewController setCar:[cars objectAtIndex:indexPath.row-1]];
		[carViewController setDelegate:self];
        carViewController.row = row;
        [self.navigationController pushViewController:carViewController animated:YES];
    }
    if(![tableView isEditing]) {
		if(cars.count > 0)
		{
			UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
			refuelingsViewController = [storyboard instantiateViewControllerWithIdentifier:@"RefuelingsViewController"];
			refuelingsViewController.row = indexPath.row;
			refuelingsViewController.car = [cars objectAtIndex:indexPath.row];
			[[self navigationController]pushViewController:refuelingsViewController animated:YES];
		}
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	return UITableViewCellEditingStyleNone;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(cars.count ==0)
	{
		return 300;
	}
	if(indexPath.row == 0 && self.tableView.isEditing)
	{
		return 66;
	}
	if(indexPath.row == [self tableView:self.tableView numberOfRowsInSection:0] - 1)
	{
		return 193;
	}
    return 194;
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
	if(fromIndexPath.row != toIndexPath.row)
	{
		Car* car = [cars objectAtIndex:fromIndexPath.row - 1];
		[cars removeObjectAtIndex:fromIndexPath.row - 1];
		[cars insertObject:car atIndex:toIndexPath.row - 1];
		[self saveDataInBackground:nil];
	}
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    if (proposedDestinationIndexPath.row == 0) {
        return [NSIndexPath indexPathForRow:1 inSection:0];
    }
    else {
        return proposedDestinationIndexPath;
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row > 0)
	{
		return YES;
	}
	return NO;
}

@end
