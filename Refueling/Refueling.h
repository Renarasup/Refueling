//
//  Refueling.h
//  Refueling
//
//  Created by Samuel on 19.06.13.
//  Copyright (c) 2013 Samuel Schepp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Refueling : NSObject <NSCopying>

@property (nonatomic) NSDate * date;
@property (nonatomic) double amount;
@property (nonatomic) double costs;
@property (nonatomic) int milage;
@property (nonatomic) bool starts;
@property (nonatomic) bool partly;

-(id) init;
	
-(id)copyWithZone:(NSZone *)zone;
@end
