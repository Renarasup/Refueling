//
//  ImportViewController.m
//  Refueling
//
//  Created by Samuel Schepp on 14.08.13.
//  Copyright (c) 2013 Samuel Schepp. All rights reserved.
//

#import "ImportViewController.h"

@interface ImportViewController () <UITableViewDataSource, UITableViewDelegate>

@end

NSUInteger itunesFileCount = 0;
NSUInteger animationCounter = 0;
UIRefreshControl *refreshControl;

@implementation ImportViewController

@synthesize tableView, importButton, fileNames, states, importedCars, paths, importButtonView, currentCar, carsFromiCloud, activityIndicator;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
	[importButton setTitle:NSLocalizedString(@"Import selection", nil)];
	[self.navigationItem setTitle:NSLocalizedString(@"Import cars", nil)];
	
	refreshControl = [[UIRefreshControl alloc] init];
	[refreshControl setTintColor:[UIColor whiteColor]];
	[refreshControl addTarget:self action:@selector(pushRefresh:) forControlEvents:UIControlEventValueChanged];
	[tableView addSubview: refreshControl];
}

- (void) viewDidAppear:(BOOL)animated
{
	NSLog(@"View Did appear");
	[super viewDidAppear:animated];
	
	@try {
		[self fetch];
	}
	@catch (NSException *exception) {
		
	}
	@finally {
		
	}
	
	if(fileNames.count == 0)
	{
		[importButton setEnabled:NO];
	}
	
	[UIView animateWithDuration:0.2
						  delay:0
						options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction |UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 [tableView setAlpha:1];
						 [activityIndicator setAlpha:0];
					 }
					 completion:nil];
	
	//[(CarsViewController*)self.delegate disableEditMode:YES];
}


- (void)fetch
{
	NSLog(@"Will fetch");
	paths = [NSMutableArray array];
	NSMutableArray* _fileNames = [NSMutableArray array];
	
	// iTunes
	NSArray *_paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [_paths objectAtIndex:0];
	_fileNames = [NSMutableArray arrayWithArray:[[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:nil]];
	_fileNames = [NSMutableArray arrayWithArray:[_fileNames filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF endswith '.plist'"]]];
	itunesFileCount = _fileNames.count;
	for(int i = 0; i < _fileNames.count; i++)
	{
		[paths addObject:[NSString stringWithFormat:@"%@/%@",documentsDirectory, [_fileNames objectAtIndex:i]]];
	}
	fileNames = _fileNames;
	
	// iCloud
	NSUbiquitousKeyValueStore *keyStore =
	[[NSUbiquitousKeyValueStore alloc] init];
	NSArray* allKeys = [[keyStore dictionaryRepresentation]allKeys];
	carsFromiCloud = [NSMutableArray array];
	for (NSString* key in allKeys) {
		[carsFromiCloud addObject:[NSKeyedUnarchiver unarchiveObjectWithData:[keyStore objectForKey:key]]];
		[fileNames addObject:key];
	}
	if(carsFromiCloud == nil)
	{
		NSLog(@"Cars from iCloud == nil");
	}
	
	
	states = [NSMutableArray array];
	for(int i = 0; i < fileNames.count; i++)
	{
		[states addObject:[NSNumber numberWithInt:0]];
	}
	[tableView reloadData];
	NSLog(@"Did fetch");
}

- (IBAction)pushImportButton:(UIBarButtonItem *)sender{
	@try {
		importedCars = [NSMutableArray array];
		for(int i = 0; i < itunesFileCount; i++)
		{
			if([[states objectAtIndex:i] isEqual:[NSNumber numberWithInt:1]])
			{
				self.currentCar = [[Car alloc]init];
				self.currentCar = [NSKeyedUnarchiver unarchiveObjectWithFile:[paths objectAtIndex:i]];
				[importedCars addObject:self.currentCar];
			}
		}
		
		for (int i = 0; i < carsFromiCloud.count; i++) {
			if([[states objectAtIndex:itunesFileCount + i]isEqual:[NSNumber numberWithInt:1]])
			{
				[importedCars addObject:[carsFromiCloud objectAtIndex:i]];
			}
		}
		
		[[NSNotificationCenter defaultCenter] postNotificationName:@"carsImported" object:self];
		[[self navigationController] popViewControllerAnimated:YES];
	}
	@catch (NSException *exception) {
		NSLog(@"%@", exception);
	}
	@finally {
		
	}
}

- (IBAction)pushRefresh:(id)sender {
	animationCounter = 0;
	[NSTimer scheduledTimerWithTimeInterval:0.3
									 target:self
								   selector:@selector(timerFired:)
								   userInfo:nil
									repeats:YES];
	[UIView animateWithDuration:0.2
						  delay:0
						options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 [tableView setAlpha:0];
						 [activityIndicator setAlpha:1];
					 }
					 completion:nil];
	[importButton setEnabled:NO];
}
- (IBAction)pushCancel:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)timerFired:(NSTimer*)timer
{	
	if(animationCounter == 0)
	{
		animationCounter = 1;
	}
	else if(animationCounter == 1)
	{
		[self fetch];
		[UIView animateWithDuration:0.2
							  delay:0
							options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction |UIViewAnimationOptionBeginFromCurrentState
						 animations:^{
							 [tableView setAlpha:1];
							 [activityIndicator setAlpha:0];
						 }
						 completion:nil];
		[timer invalidate];
		[refreshControl endRefreshing];
	}
}

- (void)updateSwitchAtIndexPath:(UISwitch *)aswitch{
	[states replaceObjectAtIndex:aswitch.tag withObject:[NSNumber numberWithBool:aswitch.on]];
	for(int i = 0; i < states.count; i++)
	{
		if([[states objectAtIndex:i] isEqual:[NSNumber numberWithInt:1]])
		{
			[[self importButton] setEnabled:YES];
			return;
		}
	}
	[[self importButton] setEnabled:NO];
}

#pragma TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(fileNames.count == 0)
	{
		return 1;
	}
    return fileNames.count + 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(indexPath.row==0)
	{
		return 60;
	}
	if(indexPath.row == itunesFileCount + 1)
	{
		return 70;
	}
	if(indexPath.row == fileNames.count + 1)
	{
		return 60;
	}
	
	return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(indexPath.row == 0)
	{
		InfoCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"infoCell"];
		if(fileNames.count == 0)
		{
			[cell localize:@"no"];
		}
		else
		{
			[cell localize:@"itunes"];
		}
		return cell;
	}
	if(indexPath.row == itunesFileCount + 1)
	{
		InfoCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"infoCell"];
		[cell localize:@"icloud"];
		return cell;
	}
	
	NSInteger row = 0;
	if(indexPath.row < itunesFileCount+1)
	{
		row = indexPath.row - 1;
	}
	if(indexPath.row > itunesFileCount+1)
	{
		row = indexPath.row - 2;
	}
	
    ImportCarCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"importCarCell"];
	[[cell label]setText:(NSString*)[fileNames objectAtIndex:row]];
	[[cell _switch]setOn:[[states objectAtIndex:row]boolValue]];
	cell._switch.tag = row;
	[cell._switch addTarget:self action:@selector(updateSwitchAtIndexPath:) forControlEvents:UIControlEventTouchUpInside];
	return cell;
}


@end
