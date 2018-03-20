//
//  InfoCell.h
//  Refueling
//
//  Created by Samuel Schepp on 14.08.13.
//  Copyright (c) 2013 Samuel Schepp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;

- (void)localize:(NSString *)identifier;

@end
