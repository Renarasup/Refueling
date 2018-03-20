//
//  StatisticsViewController.m
//  Refueling
//
//  Created by Samuel on 25.06.13.
//  Copyright (c) 2013 Samuel Schepp. All rights reserved.
//

#import "StatisticsViewController.h"

@interface StatisticsViewController () <UITableViewDelegate, UITableViewDataSource>
@end

@implementation StatisticsViewController

Car* car;
Car* unfilteredCar;
@synthesize tableView = _tableView, labelA, labelB, labelC, labelD, labelE, labelF, labelG, labelH, labelI, labelJ, labelK, lA, lB, lC, lD, lE, lF, lG, lH, lI, lJ, lK, dic, amountUnit, currency, distanceUnit;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        car.refuelings = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[_tableView reloadData];
	
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
	
	self.navigationItem.title = NSLocalizedString(@"Statistics", nil);
	self.filterLabel.text = NSLocalizedString(@"Filter by date", nil);
	
	[self setA];
    [self setB];
    [self setC];
    [self setD];
    [self setE];
    [self setF];
    [self setG];
    [self setH];
    [self setI];
    [self setJ];
	[self setK];
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}


- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if([labelA.text isEqualToString:@"NaN"] && indexPath.row == 0) {
		return NO;
	}
	if([labelG.text isEqualToString:@"NaN"] && indexPath.row == 8) {
		return NO;
	}
	
	if(indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 8)
	{
		return YES;
	}
	else {
		return NO;
	}
}

- (void) didTapBackButton:(id)sender
{
    [[self navigationController]popViewControllerAnimated:YES];
}

- (IBAction)didTapAction:(UIBarButtonItem *)sender
{
	NSURL* url = [self generateCSV:@""];
	
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
	UINavigationController* navigator =[storyboard instantiateViewControllerWithIdentifier:@"DocumentInteractionControllerNavigator"];
	dic = navigator.viewControllers[0];
	dic.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:url];
	[self presentViewController:navigator animated:YES completion:nil];
	
}



- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
	[cell setAlpha:0.2];
	[cell setSelected:YES animated:NO];
	[cell setSelected:YES];
	return indexPath;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
	[cell setAlpha:1];
	[cell setSelected:NO animated:NO];
	[cell setSelected:NO];
	return indexPath;
}

- (NSURL*)generateCSV:(NSString*)filename
{
	NSString* data = @"";
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	
	data = [data stringByAppendingString:[NSString stringWithFormat:@"CSV Export;%@;%@\n", [dateFormatter stringFromDate:[NSDate date]], car.name]];
	data = [data stringByAppendingString:[NSString stringWithFormat:@";\n"]];
	data = [data stringByAppendingString:[NSString stringWithFormat:@"%@:\n", NSLocalizedString(@"Fill-ups", nil)]];
	data = [data stringByAppendingString:[NSString stringWithFormat:@";\n"]];
	data = [data stringByAppendingString:[NSString stringWithFormat:@"%@;%@ [%@];%@ [%@];%@ [%@];%@\n",
										  NSLocalizedString(@"Date", nil),
										  NSLocalizedString(@"Amount", nil), amountUnit,
										  NSLocalizedString(@"Price", nil), currency,
										  NSLocalizedString(@"Odometer", nil), distanceUnit,
										  NSLocalizedString(@"Consumption", nil)]];
	for(int i = 0; i < car.refuelings.count; i++)
	{
		NSString* date = [dateFormatter stringFromDate:[[car.refuelings objectAtIndex:i]date]];
		NSString* amount = [numberFormatter stringForObjectValue:[NSNumber numberWithDouble:[[car.refuelings objectAtIndex:i]amount]]];
		NSString* costs = [numberFormatter stringForObjectValue:[NSNumber numberWithDouble:[[car.refuelings objectAtIndex:i]costs]]];
		NSString* milage = [numberFormatter stringForObjectValue:[NSNumber numberWithDouble:[[car.refuelings objectAtIndex:i]milage]]];
		
		double verbrauch;
		double differenz = 0;
		if(i > 0) differenz = [[car.refuelings objectAtIndex:i] milage]-[[car.refuelings objectAtIndex:i-1] milage];
		double getankt = [[car.refuelings objectAtIndex:i] amount];
		verbrauch = getankt / (differenz/100);
		NSString* consumption = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:verbrauch]];
		if([[car.refuelings objectAtIndex:i]starts] || i == 0)
		{
			consumption = @"";
		}
		
		data = [data stringByAppendingString:[NSString stringWithFormat:@"%@;%@;%@;%@;%@\n", date, amount, costs, milage, consumption]];
	}
	data = [data stringByAppendingString:[NSString stringWithFormat:@"\n"]];
	data = [data stringByAppendingString:[NSString stringWithFormat:@"%@:\n", NSLocalizedString(@"Statistics", nil)]];
	data = [data stringByAppendingString:[NSString stringWithFormat:@"\n"]];
	
	NSNumberFormatter *numberReader = [[NSNumberFormatter alloc] init];
	[numberReader setNumberStyle:NSNumberFormatterDecimalStyle];
	
	data = [data stringByAppendingString:[NSString stringWithFormat:@"%@;%@\n",
										  [NSString stringWithFormat:@"Ø %@ / 100%@", amountUnit, distanceUnit],
										  [numberFormatter stringFromNumber:[numberReader numberFromString:[labelA text]]]]];
	data = [data stringByAppendingString:[NSString stringWithFormat:@"%@;%@\n",
										  [NSString stringWithFormat:@"Ø %@ / %@", amountUnit, NSLocalizedString(@"fill-up", nil)],
										  [numberFormatter stringFromNumber:[numberReader numberFromString:[labelB text]]]]];
	data = [data stringByAppendingString:[NSString stringWithFormat:@"\n"]];
	data = [data stringByAppendingString:[NSString stringWithFormat:@"%@;%@\n",
										  [NSString stringWithFormat:@"Ø %@ / %@", currency, amountUnit],
										  [numberFormatter stringFromNumber:[numberReader numberFromString:[labelC text]]]]];
	data = [data stringByAppendingString:[NSString stringWithFormat:@"%@;%@\n",
										  [NSString stringWithFormat:@"Ø %@ / %@", currency, distanceUnit],
										  [numberFormatter stringFromNumber:[numberReader numberFromString:[labelD text]]]]];
	data = [data stringByAppendingString:[NSString stringWithFormat:@"%@;%@\n",
										  [NSString stringWithFormat:@"Ø %@ / %@", currency, NSLocalizedString(@"day", nil)],
										  [numberFormatter stringFromNumber:[numberReader numberFromString:[labelE text]]]]];
	data = [data stringByAppendingString:[NSString stringWithFormat:@"\n"]];
	data = [data stringByAppendingString:[NSString stringWithFormat:@"%@;%@\n",
										  [NSString stringWithFormat:@"Ø %@ / %@", distanceUnit, NSLocalizedString(@"fill-up", nil)],
										  [numberFormatter stringFromNumber:[numberReader numberFromString:[labelF text]]]]];
	if([distanceUnit isEqual:@"mi"] && [amountUnit isEqual:@"gal"])
	{
		data = [data stringByAppendingString:[NSString stringWithFormat:@"%@;%@\n",
											  [NSString stringWithFormat:@"Ø %@ / %@ (mpg)", distanceUnit, amountUnit],
											  [numberFormatter stringFromNumber:[numberReader numberFromString:[labelK text]]]]];
	}
	else
	{
		data = [data stringByAppendingString:[NSString stringWithFormat:@"%@;%@\n",
											  [NSString stringWithFormat:@"Ø %@ / %@", distanceUnit, amountUnit],
											  [numberFormatter stringFromNumber:[numberReader numberFromString:[labelK text]]]]];
	}
	data = [data stringByAppendingString:[NSString stringWithFormat:@"%@;%@\n",
										  [NSString stringWithFormat:@"Ø %@ / %@", distanceUnit, NSLocalizedString(@"day", nil)],
										  [numberFormatter stringFromNumber:[numberReader numberFromString:[labelG text]]]]];
	data = [data stringByAppendingString:[NSString stringWithFormat:@"\n"]];
	data = [data stringByAppendingString:[NSString stringWithFormat:@"%@;%@\n",
										  [NSString stringWithFormat:@"Σ %@", amountUnit],
										  [numberFormatter stringFromNumber:[numberReader numberFromString:[labelH text]]]]];
	data = [data stringByAppendingString:[NSString stringWithFormat:@"%@;%@\n",
										  [NSString stringWithFormat:@"Σ %@", currency],
										  [numberFormatter stringFromNumber:[numberReader numberFromString:[labelI text]]]]];
	data = [data stringByAppendingString:[NSString stringWithFormat:@"%@;%@\n",
										  [NSString stringWithFormat:@"Σ %@", distanceUnit],
										  [numberFormatter stringFromNumber:[numberReader numberFromString:[labelJ text]]]]];
	
	
	NSString* docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *filePath = [[docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Export %@", car.name]] stringByAppendingPathExtension:@"csv"];
	NSError* error;
	BOOL ok = [data writeToFile:filePath
					 atomically:YES
					   encoding:NSUnicodeStringEncoding
						  error:&error];
	if (!ok) {
		NSLog(@"Error writing file at %@\n%@", filePath, [error localizedDescription]);
	}
	return [NSURL fileURLWithPath:filePath];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{	
	if([[segue identifier] isEqualToString:@"pushFilterView"]) {
		//FilterViewController* filterViewController = [segue destinationViewController];
		return;
	}
	
    GraphViewController *graphViewController = [segue destinationViewController];
	[graphViewController setAnimationDone:NO];
	
	NSMutableArray* refuelings = car.refuelings;
	
    if([[segue identifier] isEqualToString:@"pushGraphViewA"])
    {
		
		
		for(int i = 0; i < refuelings.count; i++) {
			NSLog(@"%@ - %f L - %d km - %d starts - %d partly", [[refuelings objectAtIndex:i]date], [[refuelings objectAtIndex:i]amount], [[refuelings objectAtIndex:i]milage], [[refuelings objectAtIndex:i]starts], [[refuelings objectAtIndex:i]partly]);
		}
		
        // ---- DataY
        NSMutableArray* dataY = [NSMutableArray array];
        for (int i = 1; i< refuelings.count; i++) {
            double verbrauch;
            double differenz = [[refuelings objectAtIndex:i] milage]-[[refuelings objectAtIndex:i-1] milage];
            //NSLog(@"Differenz: %f", differenz);
            
            double getankt = [[refuelings objectAtIndex:i] amount];
            //NSLog(@"Getankt: %f", getankt);
            
            verbrauch = getankt / (differenz/100);
            if(![[refuelings objectAtIndex:i]starts]) [dataY addObject:[NSNumber numberWithDouble:verbrauch]];
        }
        
        // ---- DataX
        NSMutableArray* dataX = [NSMutableArray array];
        for(int i = 1; i < refuelings.count; i++)
        {
            if(![[refuelings objectAtIndex:i]starts]) [dataX addObject:[[refuelings objectAtIndex:i]date]];
        }
		
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
		[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
		graphViewController.average = [formatter numberFromString:labelA.text];
        graphViewController.dataY = dataY;
        graphViewController.dataX = dataX;
        graphViewController.unitX = NSLocalizedString(@"Date", nil);
        graphViewController.unitY = [NSString stringWithFormat:@"%@ [%@ / 100%@]", NSLocalizedString(@"Consumption",nil), amountUnit, distanceUnit];
		
    }
    else if([[segue identifier] isEqualToString:@"pushGraphViewB"])
    {
		refuelings = unfilteredCar.refuelings;
		
        // ---- DataY
        NSMutableArray* dataY = [NSMutableArray array];
        for (int i = 0; i<refuelings.count; i++) {
            double kosten =[[refuelings objectAtIndex:i] costs];
            [dataY addObject:[NSNumber numberWithDouble:kosten]];
        }
        
        // ---- DataX
        NSMutableArray* dataX = [NSMutableArray array];
        for(int i = 0; i < refuelings.count; i++)
        {
            [dataX addObject:[[refuelings objectAtIndex:i]date]];
        }
        
		NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
		[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
		graphViewController.average = [formatter numberFromString:labelC.text];
        graphViewController.dataY = dataY;
        graphViewController.dataX = dataX;
        graphViewController.unitX = NSLocalizedString(@"Date", nil);
        graphViewController.unitY = [NSString stringWithFormat:@"%@ [%@ / %@]", NSLocalizedString(@"Price",nil), currency, amountUnit];
    }
	else if([[segue identifier] isEqualToString:@"pushGraphViewC"])
    {
        // ---- DataY
        NSMutableArray* dataY = [NSMutableArray array];
        for (int i = 1; i<refuelings.count; i++) {
            double verbrauch;
            double differenz = [[refuelings objectAtIndex:i] milage]-[[refuelings objectAtIndex:i-1] milage];
            //NSLog(@"Differenz: %f", differenz);
            
            double getankt = [[refuelings objectAtIndex:i] amount];
            //NSLog(@"Getankt: %f", getankt);
            
            verbrauch = differenz / getankt;
            if(![[refuelings objectAtIndex:i]starts]) [dataY addObject:[NSNumber numberWithDouble:verbrauch]];
        }
        
        // ---- DataX
        NSMutableArray* dataX = [NSMutableArray array];
        for(int i = 1; i < refuelings.count; i++)
        {
            if(![[refuelings objectAtIndex:i]starts]) [dataX addObject:[[refuelings objectAtIndex:i]date]];
        }
        
		NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
		[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
		graphViewController.average = [formatter numberFromString:labelK.text];
        graphViewController.dataY = dataY;
        graphViewController.dataX = dataX;
        graphViewController.unitX = NSLocalizedString(@"Date", nil);
		if([distanceUnit isEqual:@"mi"] && [amountUnit isEqual:@"gal"])
		{
			graphViewController.unitY = [NSString stringWithFormat:@"%@ [mpg]", NSLocalizedString(@"Consumption",nil)];
		}
		else
		{
			graphViewController.unitY = [NSString stringWithFormat:@"%@ [%@ / %@]", NSLocalizedString(@"Consumption",nil), distanceUnit, amountUnit];
		}
    }
}

-(void)setA // L / 100km
{
    // Wieviel insgesamt Gefahren
    NSMutableArray * distances = [NSMutableArray array];
	if(car.refuelings.count == 0) return;
    for(int i = 0; i < car.refuelings.count-1; i++)
    {
        Refueling* refA = (Refueling*)[car.refuelings objectAtIndex:(i)];
        int distanceA = refA.milage;
        
        Refueling* refB = (Refueling*)[car.refuelings objectAtIndex:(i+1)];
        int distanceB = refB.milage;
        
        if(![refB starts]) [distances addObject:[NSNumber numberWithInt:(distanceB-distanceA)]];
    }
    double distance = 0;
    for(int i = 0; i < distances.count; i++)
    {
        distance += [[distances objectAtIndex:i] doubleValue];
    }
    
    // Wieviel insg Getankt
    double tank = 0;
    for(int i = 1; i < car.refuelings.count; i++)
    {
        if(![[car.refuelings objectAtIndex:i] starts]) tank += [[car.refuelings objectAtIndex:i] amount];
    }
    
    double result = tank / (distance / 100);
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [labelA setText:[formatter stringFromNumber:[NSNumber numberWithDouble:result]]];
	[lA setText:[NSString stringWithFormat:@"Ø %@ / 100%@", amountUnit, distanceUnit]];
}
-(void)setB
{
    // Alle Tankungen
    double tanking = 0;
    for(int i = 0; i < unfilteredCar.refuelings.count; i++)
    {
        tanking += [[unfilteredCar.refuelings objectAtIndex:i] amount];
    }
    tanking = tanking / unfilteredCar.refuelings.count;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [labelB setText:[formatter stringFromNumber:[NSNumber numberWithDouble:tanking]]];
	[lB setText:[NSString stringWithFormat:@"Ø %@ / %@", amountUnit, NSLocalizedString(@"fill-up", nil)]];
}
-(void)setC
{
    // Alle Preise
    double cost = 0;
    for(int i = 0; i < unfilteredCar.refuelings.count; i++)
    {
        cost += [[unfilteredCar.refuelings objectAtIndex:i] costs];
    }
    
    double result = cost / unfilteredCar.refuelings.count;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [labelC setText:[formatter stringFromNumber:[NSNumber numberWithDouble:result]]];
	[lC setText:[NSString stringWithFormat:@"Ø %@ / %@", currency, amountUnit]];
}
-(void)setD
{
    // Alle Preise Addiert
    double cost = 0;
    for(int i = 1; i < car.refuelings.count; i++)
    {
        if(![[car.refuelings objectAtIndex:i] starts]) cost += ([[car.refuelings objectAtIndex:i] costs] * [[car.refuelings objectAtIndex:i] amount]);
    }
    
    // Alle km addiert
    NSMutableArray * distances = [NSMutableArray array];
    for(int i = 1; i < car.refuelings.count; i++)
    {
        Refueling* refA = (Refueling*)[car.refuelings objectAtIndex:(i-1)];
        int distanceA = refA.milage;
        
        Refueling* refB = (Refueling*)[car.refuelings objectAtIndex:(i)];
        int distanceB = refB.milage;
        
        if(![[car.refuelings objectAtIndex:i] starts]) [distances addObject:[NSNumber numberWithInt:(distanceB-distanceA)]];
    }
    double distance = 0;
    for(int i = 0; i < distances.count; i++)
    {
        distance += [[distances objectAtIndex:i] doubleValue];
    }

    double result;
    result = cost / distance;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [labelD setText:[formatter stringFromNumber:[NSNumber numberWithDouble:result]]];
	[lD setText:[NSString stringWithFormat:@"Ø %@ / %@", currency, distanceUnit]];
}
-(void)setE
{
    // Alle Preise Addiert
    double cost = 0;
    for(int i = 1; i < car.refuelings.count; i++)
    {
        if(![[car.refuelings objectAtIndex:i] starts]) cost += ([[car.refuelings objectAtIndex:i] costs] * [[car.refuelings objectAtIndex:i] amount]);
    }
    
    // anzahl tage addiert
    /*NSDate* firstDate = [[car.refuelings objectAtIndex:0] date];
    NSDate* lastDate = [[car.refuelings lastObject] date];
    NSInteger days = [[[NSCalendar currentCalendar] components: NSDayCalendarUnit
                                                       fromDate: firstDate
                                                         toDate: lastDate
                                                        options: 0] day];*/
	// Alle tage addiert
    double days = 0;
    for(int i = 1; i < car.refuelings.count; i++)
    {
        Refueling* refA = (Refueling*)[car.refuelings objectAtIndex:(i-1)];
        NSDate* dateA = refA.date;
        
        Refueling* refB = (Refueling*)[car.refuelings objectAtIndex:(i)];
        NSDate* dateB = refB.date;
        
        if(![[car.refuelings objectAtIndex:i] starts])
		{
			days += [[[NSCalendar currentCalendar] components: NSCalendarUnitDay
											 fromDate: dateA
											   toDate: dateB
											  options: 0] day];
		}
	}
	
    
    double result = cost / days;

    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [labelE setText:[formatter stringFromNumber:[NSNumber numberWithDouble:result]]];
	[lE setText:[NSString stringWithFormat:@"Ø %@ / %@", currency, NSLocalizedString(@"day", nil)]];
}
-(void)setF
{
	if(car.refuelings.count == 0) return;
    double distance = 0;
	double countofstartings = 0;
	for(int i = 0; i < car.refuelings.count - 1; i++)
	{
		if(![[car.refuelings objectAtIndex:i+1] starts]) distance += [(Refueling*)[car.refuelings objectAtIndex:(i+1)] milage] - [(Refueling*)[car.refuelings objectAtIndex:(i)]milage];
		
		if([[car.refuelings objectAtIndex:i+1] starts]) countofstartings += 1;
	}
	
    double result = distance / (car.refuelings.count-1-countofstartings);
	
	
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [labelF setText:[formatter stringFromNumber:[NSNumber numberWithDouble:result]]];
	[lF setText:[NSString stringWithFormat:@"Ø %@ / %@", distanceUnit, NSLocalizedString(@"fill-up", nil)]];
}
-(void)setG
{
	if(car.refuelings.count == 0) return;
    double distance = 0;
	double countofstartings = 0;
	for(int i = 0; i < car.refuelings.count - 1; i++)
	{
		if(![[car.refuelings objectAtIndex:i+1] starts]) distance += [(Refueling*)[car.refuelings objectAtIndex:(i+1)] milage] - [(Refueling*)[car.refuelings objectAtIndex:(i)]milage];
		
		if([[car.refuelings objectAtIndex:i+1] starts]) countofstartings += 1;
	}
    
    // Alle tage addiert
    double days = 0;
    for(int i = 1; i < car.refuelings.count; i++)
    {
        Refueling* refA = (Refueling*)[car.refuelings objectAtIndex:(i-1)];
        NSDate* dateA = refA.date;
        
        Refueling* refB = (Refueling*)[car.refuelings objectAtIndex:(i)];
        NSDate* dateB = refB.date;
        
        if(![[car.refuelings objectAtIndex:i] starts])
		{
			days += [[[NSCalendar currentCalendar] components: NSCalendarUnitDay
													 fromDate: dateA
													   toDate: dateB
													  options: 0] day];
		}
	}
    
    double result = distance / days;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [labelG setText:[formatter stringFromNumber:[NSNumber numberWithDouble:result]]];
	[lG setText:[NSString stringWithFormat:@"Ø %@ / %@", distanceUnit, NSLocalizedString(@"day", nil)]];
}
-(void)setH
{
    double tanking = 0;
    for(int i = 0; i < unfilteredCar.refuelings.count; i++)
    {
        tanking += [[unfilteredCar.refuelings objectAtIndex:i] amount];
    }
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [labelH setText:[formatter stringFromNumber:[NSNumber numberWithDouble:tanking]]];
	[lH setText:[NSString stringWithFormat:@"Σ %@", amountUnit]];
}
-(void)setI
{
    double cost = 0;
    for(int i = 0; i < unfilteredCar.refuelings.count; i++)
    {
        cost += ([[unfilteredCar.refuelings objectAtIndex:i] costs] * [[unfilteredCar.refuelings objectAtIndex:i] amount]);
    }
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [labelI setText:[formatter stringFromNumber:[NSNumber numberWithDouble:cost]]];
	[lI setText:[NSString stringWithFormat:@"Σ %@", currency]];
}
-(void)setJ
{
    NSMutableArray * distances = [NSMutableArray array];
    for(int i = 1; i < unfilteredCar.refuelings.count; i++)
    {
        Refueling* refA = (Refueling*)[unfilteredCar.refuelings objectAtIndex:(i-1)];
        int distanceA = refA.milage;
        
        Refueling* refB = (Refueling*)[unfilteredCar.refuelings objectAtIndex:(i)];
        int distanceB = refB.milage;
        
        if(![[unfilteredCar.refuelings objectAtIndex:i] starts]) [distances addObject:[NSNumber numberWithInt:(distanceB-distanceA)]];
    }
    double distance = 0;
    for(int i = 0; i < distances.count; i++)
    {
        distance += [[distances objectAtIndex:i] doubleValue];
    }
	
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [labelJ setText:[formatter stringFromNumber:[NSNumber numberWithDouble:distance]]];
	[lJ setText:[NSString stringWithFormat:@"Σ %@", distanceUnit]];
}
-(void)setK
{
    NSMutableArray * distances = [NSMutableArray array];
    for(int i = 1; i < car.refuelings.count; i++)
    {
        Refueling* refA = (Refueling*)[car.refuelings objectAtIndex:(i-1)];
        int distanceA = refA.milage;
        
        Refueling* refB = (Refueling*)[car.refuelings objectAtIndex:(i)];
        int distanceB = refB.milage;
        
        if(![[car.refuelings objectAtIndex:i] starts]) [distances addObject:[NSNumber numberWithInt:(distanceB-distanceA)]];
    }
    double distance = 0;
    for(int i = 0; i < distances.count; i++)
    {
        distance += [[distances objectAtIndex:i] doubleValue];
    }
	
	double tank = 0;
    for(int i = 1; i < car.refuelings.count; i++)
    {
        if(![[car.refuelings objectAtIndex:i] starts]) tank += [[car.refuelings objectAtIndex:i] amount];
    }
	
	double result = distance / tank;
	
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [labelK setText:[formatter stringFromNumber:[NSNumber numberWithDouble:result]]];
	if([distanceUnit isEqual:@"mi"] && [amountUnit isEqual:@"gal"])
	{
		[lK setText:[NSString stringWithFormat:@"Ø %@ / %@ (mpg)", distanceUnit, amountUnit]];
	}
	else
	{
		[lK setText:[NSString stringWithFormat:@"Ø %@ / %@", distanceUnit, amountUnit]];
	}
}

- (void) setCar:(Car*)_car
{
	car = [_car copy];
	unfilteredCar = [_car copy];
	if(car.refuelings.count == 0) {
		NSLog(@"COUNT = 0");
	}
	
	// Teilbetankungen verrechnen
	for(int i = 0; i < car.refuelings.count - 1; i++) {
		if([[car.refuelings objectAtIndex:i]partly]) {
			[[car.refuelings objectAtIndex:i+1]setAmount:[[car.refuelings objectAtIndex:i]amount] + [[car.refuelings  objectAtIndex:i+1]amount]];
			
			if([[car.refuelings objectAtIndex:i]starts]) {
				[[car.refuelings objectAtIndex:i+1]setStarts:YES];
			}
			[car.refuelings removeObjectAtIndex:i];
			i--;
		}
	}
	if([[car.refuelings lastObject]partly]) {
		[car.refuelings removeLastObject];
	}
	
	// Zeit entfernen
	for (Refueling* ref in car.refuelings) {
		[ref setDate:[self dateWithOutTime:[ref date]]];
	}
}

- (NSDate *)dateWithOutTime:(NSDate *)datDate {
	if( datDate == nil ) {
		datDate = [NSDate date];
	}
	NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:datDate];
	return [[NSCalendar currentCalendar] dateFromComponents:comps];
}


@end
