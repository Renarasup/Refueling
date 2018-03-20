//
//  InfoCell.m
//  Refueling
//
//  Created by Samuel Schepp on 14.08.13.
//  Copyright (c) 2013 Samuel Schepp. All rights reserved.
//

#import "InfoCell.h"

@implementation InfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)localize:(NSString *)identifier
{
	if([identifier isEqual:@"itunes"])
	{
		[self.label setText:NSLocalizedString(@"iTunes File Sharing", nil)];
	}
	if([identifier isEqual:@"icloud"])
	{
		[self.label setText:NSLocalizedString(@"iCloud", nil)];
	}
	if([identifier isEqual:@"no"])
	{
		[self.label setText:NSLocalizedString(@"No backups found.", nil)];
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
