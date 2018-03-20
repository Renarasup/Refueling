//
//  StatisticsButtonCell.m
//  Refueling
//
//  Created by Samuel on 19.06.13.
//  Copyright (c) 2013 Samuel Schepp. All rights reserved.
//

#import "ButtonCell.h"

@implementation ButtonCell
@synthesize imageView, label;

BOOL enabled = YES;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        [imageView setAlpha:0.2];
        [label setAlpha:0.2];
    } else {
        if(enabled)
        {
            [imageView setAlpha:1];
            [label setAlpha:1];
        }
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
	[super setHighlighted:highlighted animated:animated];
	if (highlighted) {
		[imageView setAlpha:0.2];
		[label setAlpha:0.2];
	} else {
		if(enabled)
		{
			[imageView setAlpha:1];
			[label setAlpha:1];
		}
	}
}

- (void) setEnabled:(BOOL)_enabled
{
    if(_enabled)
    {
        [imageView setAlpha:1];
        [label setAlpha:1];
        enabled = _enabled;
    }
    else
    {
        [imageView setAlpha:0.2];
        [label setAlpha:0.2];
        enabled = _enabled;
    }
}

@end
