//
//  GraphViewController.m
//  Refueling
//
//  Created by Samuel on 07.07.13.
//  Copyright (c) 2013 Samuel Schepp. All rights reserved.
//

#import "GraphViewController.h"

@interface GraphViewController ()



@end

NSMutableArray* imageViews;
NSMutableArray* labelXs;
NSMutableArray* labelYs;
double animationIndex;

double nullpointP;
double maxHeightP;
double max;
double min;

double barMargin = 20;
double barWidth = 40;

BOOL scrolled; // Wurde der Graph bereits automatisch gescrollt?

@implementation GraphViewController
@synthesize dataX, dataY, scrollView, unitXLabel, unitYLabel, unitX, unitY, patterImageView, averageImageView, average, minImageView, maxImageView, maxLabel, minLabel, averageLabel, dateLabel, detailView, animationDone;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	imageViews = [NSMutableArray array];
	labelXs = [NSMutableArray array];
	labelYs = [NSMutableArray array];
	animationIndex = 0;
	scrolled = NO;
	[detailView setFrame:CGRectMake(detailView.frame.origin.x, detailView.frame.origin.y-44, detailView.frame.size.width, detailView.frame.size.height)];
	[detailView setAlpha:0];
	
	//[patterImageView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"raster_texture"]]];
}

-(void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	if(dataX.count == 0) {
		[self dismissViewControllerAnimated:NO completion:nil];
	}
	if(!animationDone)
	{
		if(dataX.count < 3)
		{
			[maxImageView setHidden:YES];
			[minImageView setHidden:YES];
			[averageImageView setHidden:YES];
		}
		[self prepareGraph];
		/*
		 CGPoint bottomOffset = CGPointMake(self.scrollView.contentSize.width - self.scrollView.bounds.size.width, 0);
		 [self.scrollView setContentOffset:bottomOffset animated:YES];
		 */
		[self animateGraph];
		animationDone = YES;
	}
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareGraph
{
	nullpointP = scrollView.frame.size.height-30;
	maxHeightP = nullpointP-detailView.frame.size.height-detailView.frame.size.height/2;
    max = [[dataY valueForKeyPath:@"@max.doubleValue"]doubleValue];
	min = [[dataY valueForKeyPath:@"@min.doubleValue"]doubleValue];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[formatter setMaximumFractionDigits:3];
	[maxLabel setText:[NSString stringWithFormat:@"%@", [formatter stringFromNumber:[NSNumber numberWithDouble:max]]]];
	[averageLabel setText:[NSString stringWithFormat:@"%@", [formatter stringFromNumber:average]]];
	[minLabel setText:[NSString stringWithFormat:@"%@", [formatter stringFromNumber:[NSNumber numberWithDouble:min]]]];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	[dateLabel setText:[NSString stringWithFormat:@"%@ %@ %@", [dateFormatter stringFromDate:[dataX objectAtIndex:0]], NSLocalizedString(@"to", nil), [dateFormatter stringFromDate:[dataX objectAtIndex:dataX.count-1]]]];
	
    [formatter setMaximumFractionDigits:2];
	
    [[self unitYLabel] setText:unitY];
    [unitXLabel setText:unitX];
    
	CGRect imageViewRect = CGRectMake(0, nullpointP + 10, 320, 0.5);
	[averageImageView setFrame:imageViewRect];
	[minImageView setFrame:imageViewRect];
	[maxImageView setFrame:imageViewRect];
	   
    for(int i = 0; i < dataX.count; i++)
    {
        UIImage *image = [[UIImage imageNamed:@"graph_texture.png"]
                          resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
        CGRect imageBounds = CGRectZero;
        imageBounds.size.width = barWidth;
        imageBounds.origin.x = barMargin + (i*barWidth) + (i*barMargin);
        [imageView setFrame:imageBounds];
        
        UILabel* labelY = [[UILabel alloc] init];
        [labelY setText:[NSString stringWithFormat:@"%@", [formatter stringFromNumber:[NSNumber numberWithDouble:[[dataY objectAtIndex:i] doubleValue]]]]];
        CGRect labelYBounds;
        labelYBounds.size.height = barWidth*0.7;
        labelYBounds.size.width = barWidth;
        labelYBounds.origin.x = barMargin + (i*barWidth) + (i*barMargin);
        labelYBounds.origin.y = nullpointP - 2*labelYBounds.size.height;
        [labelY setFrame:labelYBounds];
        [labelY setFont:[UIFont systemFontOfSize:12]];
        [labelY setTextAlignment:NSTextAlignmentCenter];
        [labelY setTextColor:[UIColor whiteColor]];
        [labelY setBackgroundColor:[UIColor clearColor]];
        
        UILabel* labelX = [[UILabel alloc] init];
        
        [formatter setMaximumFractionDigits:2];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [labelX setText:[dateFormatter stringFromDate:[dataX objectAtIndex:i]]];
        CGRect labelXBounds;
        labelXBounds.size.height = 20;
        labelXBounds.size.width = barWidth + barMargin;
        labelXBounds.origin.x = barMargin + (i*barWidth) + (i*barMargin) - barMargin/2;
        labelXBounds.origin.y = nullpointP+5;
        [labelX setFrame:labelXBounds];
        [labelX setFont:[UIFont systemFontOfSize:12]];
        [labelX setTextAlignment:NSTextAlignmentCenter];
        [labelX setTextColor:[UIColor whiteColor]];
        [labelX setBackgroundColor:[UIColor clearColor]];
		
		
		[imageView setAlpha:0];
        [labelY setAlpha:0];
		[labelX setAlpha:0];
		
		[imageView setFrame:CGRectMake(imageView.frame.origin.x, nullpointP, imageView.frame.size.width, 0)];
		[labelX setFrame:CGRectMake(labelX.frame.origin.x, labelX.frame.origin.y + 50, labelX.frame.size.width, labelX.frame.size.height)];
		[labelY setFrame:CGRectMake(labelY.frame.origin.x, labelY.frame.origin.y + 50, labelY.frame.size.width, labelY.frame.size.height)];
		
		
		
		[imageViews addObject:imageView];
		[labelXs addObject:labelX];
		[labelYs addObject:labelY];
		 
		/*
		[scrollView addSubview:imageView];
        [scrollView addSubview:labelY];
        [scrollView addSubview:labelX];
		 */
    }
    
    CGSize content;
    content.height = scrollView.contentSize.height;
    content.width = barMargin + (dataX.count*barWidth) + (dataX.count*barMargin);
    [scrollView setContentSize:content];
	
	[unitXLabel setFrame:CGRectMake(unitXLabel.frame.origin.x, unitXLabel.frame.origin.y + 40, unitXLabel.frame.size.width, unitXLabel.frame.size.height)];
}

-(void) animateGraph
{
	[[NSRunLoop currentRunLoop] addTimer:[NSTimer scheduledTimerWithTimeInterval:0.06
																		  target:self
																		selector:@selector(timerFired:)
																		userInfo:nil
																		 repeats:YES] forMode:NSRunLoopCommonModes];
	
	[UIView animateWithDuration:0.7
						  delay:0
						options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction |UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 [unitXLabel setFrame:CGRectMake(unitXLabel.frame.origin.x, unitXLabel.frame.origin.y - 40, unitXLabel.frame.size.width, unitXLabel.frame.size.height)];
						 
						 CGRect averageImageViewRect = CGRectMake(0, (int) (nullpointP - ((maxHeightP / max) * [average doubleValue])) + 64, 1000, 1);
						 [averageImageView setFrame:averageImageViewRect];
						 
						 CGRect maxImageViewRect = CGRectMake(0, (int) (nullpointP - ((maxHeightP / max) * max)) + 64, 1000, 1);
						 [maxImageView setFrame:maxImageViewRect];
														  
						 CGRect minImageViewRect = CGRectMake(0, (int) (nullpointP - ((maxHeightP / max) * min)) + 64, 1000, 1);
						 [minImageView setFrame:minImageViewRect];
						 
						 [detailView setFrame:CGRectMake(detailView.frame.origin.x, + 64, detailView.frame.size.width, detailView.frame.size.height)];
						 [detailView setAlpha:1];
					 }
					 completion:^(BOOL finished) {
						 if(dataX.count > 5) {
							 CGPoint bottomOffset = CGPointMake(self.scrollView.contentSize.width - self.scrollView.bounds.size.width, 0);
							 [self.scrollView setContentOffset:bottomOffset animated:YES];
							 scrolled = YES;
							 NSLog(@"Started Scrolling");
						 }
					 }];
}

- (void) timerFired:(NSTimer*)theTimer
{
	[UIView animateWithDuration:0.4
						  delay:0
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 [[imageViews objectAtIndex:animationIndex] setAlpha:1];
						 [[labelYs objectAtIndex:animationIndex] setAlpha:1];
						 [[labelXs objectAtIndex:animationIndex] setAlpha:1];
						 
						 CGRect imageBounds = [[imageViews objectAtIndex:animationIndex] frame];
						 imageBounds.size.height = (int) ((maxHeightP / max) * [[dataY objectAtIndex:animationIndex] doubleValue]);
						 if(imageBounds.size.height < 0)
						 {
							 imageBounds.size.height = 0;
						 }
						 imageBounds.origin.y = nullpointP-imageBounds.size.height;
						 [[imageViews objectAtIndex:animationIndex] setFrame:imageBounds];

						 
						 CGRect labelYBounds = [[labelYs objectAtIndex:animationIndex] frame];
						 labelYBounds.origin.y = nullpointP - imageBounds.size.height;
						 if(imageBounds.size.height < labelYBounds.size.height)
						 {
							 labelYBounds.origin.y = nullpointP - imageBounds.size.height - labelYBounds.size.height;
						 }
						 [[labelYs objectAtIndex:animationIndex] setFrame:labelYBounds];
						 
						 
						 [[labelXs objectAtIndex:animationIndex] setFrame:CGRectMake(((UILabel* )[labelXs objectAtIndex:animationIndex]).frame.origin.x, ((UILabel* )[labelXs objectAtIndex:animationIndex]).frame.origin.y - 50, ((UILabel* )[labelXs objectAtIndex:animationIndex]).frame.size.width, ((UILabel* )[labelXs objectAtIndex:animationIndex]).frame.size.height)];
					 }
					 completion:^(BOOL finished){
						 if(animationIndex > 5 && animationIndex >= dataX.count && !scrolled) {
							 
						 }
					 }];
	
	[scrollView addSubview:[imageViews objectAtIndex:animationIndex]];
	[scrollView addSubview:[labelYs objectAtIndex:animationIndex]];
	[scrollView addSubview:[labelXs objectAtIndex:animationIndex]];
	
	animationIndex++;
	
	
	if(animationIndex >= imageViews.count)
	{
		[theTimer invalidate];
		return;
	}
	if(animationIndex > 5)
	{
		[theTimer invalidate];
		[self timerFired:theTimer];
	}
}

- (void) didTapBackButton:(id)sender
{
    [[self navigationController]popViewControllerAnimated:YES];
}
- (void) didTapShareButton:(id)sender
{
	
}

@end
