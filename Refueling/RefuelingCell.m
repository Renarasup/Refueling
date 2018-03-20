//
//  RefuelingCell.m
//  Refueling
//
//  Created by Samuel on 19.06.13.
//  Copyright (c) 2013 Samuel Schepp. All rights reserved.
//

#import "RefuelingCell.h"

@implementation RefuelingCell
@synthesize dateLabel, amountLabel, imageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) willTransitionToState:(UITableViewCellStateMask)state
{
	[super willTransitionToState:state];
	if ((state & UITableViewCellStateShowingDeleteConfirmationMask) == UITableViewCellStateShowingDeleteConfirmationMask) {
		
        for (UIView *subview in self.subviews) {
			
            if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationControl"]) {
				
                subview.hidden = YES;
                subview.alpha = 0.0;
            }
        }
    }
}

- (void) didTransitionToState:(UITableViewCellStateMask)state
{
	[super didTransitionToState:state];
	if (state == UITableViewCellStateShowingDeleteConfirmationMask || state == UITableViewCellStateDefaultMask) {
        for (UIView *subview in self.subviews) {
			
            if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationControl"]) {
				
                UIView *deleteButtonView = (UIView *)[subview.subviews objectAtIndex:0];
                CGRect f = deleteButtonView.frame;
				f.origin.y = 6;
                deleteButtonView.frame = f;
				
                subview.hidden = NO;
				
                [UIView beginAnimations:@"anim" context:nil];
                subview.alpha = 1.0;
                f.origin.x = -14;
				deleteButtonView.frame = f;
                [UIView commitAnimations];
            }
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [self setAlphaR:selected];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
	[super setHighlighted:highlighted animated:animated];
	[self setAlphaR:highlighted];
}

-(void)setAlphaR:(BOOL)alpha
{
	if (alpha) {
        [imageView setAlpha:0.2];
        [amountLabel setAlpha:0.2];
        [dateLabel setAlpha:0.2];
    } else {
        [imageView setAlpha:1];
        [amountLabel setAlpha:1];
        [dateLabel setAlpha:1];
    }
}

@end

