//
//  NoCarCell.h
//  Refueling
//
//  Created by Samuel Schepp on 11.08.13.
//  Copyright (c) 2013 Samuel Schepp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuartzCore/CALayer.h"

@interface NoEntryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

-(id)initWithType:(NSString*)typeIdentifier;
@property (weak, nonatomic) IBOutlet UIButton *importButton;
- (IBAction)importButtonPushed:(id)sender;

@end
