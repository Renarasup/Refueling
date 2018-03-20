//
//  NoCarCell.m
//  Refueling
//
//  Created by Samuel Schepp on 11.08.13.
//  Copyright (c) 2013 Samuel Schepp. All rights reserved.
//

#import "NoEntryCell.h"

@implementation NoEntryCell
@synthesize titleLabel, importButton;

- (id)initWithType:(NSString*)typeIdentifier
{
    self = [super init];
    if (self) {
		[self setUserInteractionEnabled:YES];
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"NoEntryCell" owner:self options:nil];
        self = [topLevelObjects objectAtIndex:0];
		[importButton setTitle:NSLocalizedString(@"Import cars", nil) forState:UIControlStateNormal];
		
		if([typeIdentifier isEqualToString:@"car"])
		{
			[titleLabel setText:NSLocalizedString(@"Add your first car to get started.", nil)];
		}
		if([typeIdentifier isEqualToString:@"refueling"])
		{
			[titleLabel setText:NSLocalizedString(@"Enter your first fill-up.", nil)];
			[importButton setHidden:YES];
		}
		//[titleLabel sizeToFit];

		//[titleLabel setFrame:CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y, 280, titleLabel.frame.size.height)];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)importButtonPushed:(id)sender {
}
@end
