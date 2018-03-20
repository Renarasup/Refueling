//
//  EmptyRefuelingCell.m
//  Refueling
//
//  Created by Samuel on 19.06.13.
//  Copyright (c) 2013 Samuel Schepp. All rights reserved.
//

#import "EmptyRefuelingCell.h"

@implementation EmptyRefuelingCell

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

    // Configure the view for the selected state
}

@end
