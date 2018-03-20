//
//  CarCell.m
//  Refueling
//
//  Created by Samuel on 17.06.13.
//  Copyright (c) 2013 Samuel Schepp. All rights reserved.
//

#import "CarCell.h"

@implementation CarCell
@synthesize imageView, label, carFrame, editCarImageView, overlay;

-(void)awakeFromNib {
	[super awakeFromNib];
	[[label layer] setShadowColor:[[UIColor blackColor]CGColor]];
	[[label layer] setShadowRadius:1];
	[[label layer] setShadowOpacity:1];
	[[label layer]setShadowOffset:CGSizeZero];
	[label setClipsToBounds:NO];
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated
{
	[super setEditing:editing animated:NO];
	if(editing)
	{
		editCarImageView.alpha = 1;
		//imageView.alpha = 0.2;
    }
    else
    {
		editCarImageView.alpha = 0;
		//imageView.alpha = 1;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
	
	if (selected) {
		[imageView setAlpha:0.2];
		[label setAlpha:0.2];
	} else {
		[imageView setAlpha:1];
		[label setAlpha:1];
	}
	
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
	[super setHighlighted:highlighted animated:animated];
	if (highlighted) {
		[imageView setAlpha:0.2];
		[label setAlpha:0.2];
	} else {
		[imageView setAlpha:1];
		[label setAlpha:1];
	}
}

@end
