//
//  CarCell.h
//  Refueling
//
//  Created by Samuel on 17.06.13.
//  Copyright (c) 2013 Samuel Schepp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *carFrame;
@property (weak, nonatomic) IBOutlet UIImageView *editCarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *overlay;

@end
