//
//  CarTableView.m
//  Refueling
//
//  Created by Samuel Schepp on 15.08.13.
//  Copyright (c) 2013 Samuel Schepp. All rights reserved.
//

#import "CarTableView.h"

@implementation CarTableView

- (void) didAddSubview:(UIView *)subview
{
	[super didAddSubview:subview];
	
	//	Hide any shadows
	if([[[subview class] description] isEqualToString:@"UIShadowView"])
	{
		//[subview setHidden:YES];
	}
}

@end
