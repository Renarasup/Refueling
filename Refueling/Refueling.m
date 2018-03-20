//
//  Refueling.m
//  Refueling
//
//  Created by Samuel on 19.06.13.
//  Copyright (c) 2013 Samuel Schepp. All rights reserved.
//

#import "Refueling.h"

@implementation Refueling
@synthesize date, amount, costs, milage, starts, partly;

-(id) init{
    self = [super init];
    if(self){
        self.date = [NSDate date];
        self.amount = 0;
        self.costs = 0;
        self.milage = 0;
        self.starts = NO;
		self.partly = YES;
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.date forKey:@"date"];
    [encoder encodeDouble:self.amount forKey:@"amount"];
    [encoder encodeDouble:self.costs forKey:@"costs"];
    [encoder encodeInt:self.milage forKey:@"milage"];
    [encoder encodeBool:self.starts forKey:@"starts"];
	[encoder encodeBool:self.partly forKey:@"partly"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self.date = [decoder decodeObjectForKey:@"date"];
    self.amount = [decoder decodeDoubleForKey:@"amount"];
    self.costs = [decoder decodeDoubleForKey:@"costs"];
    self.milage = [decoder decodeIntForKey:@"milage"];
    self.starts = [decoder decodeBoolForKey:@"starts"];
	self.partly = [decoder decodeBoolForKey:@"partly"];
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    Refueling *ref = [[[self class] allocWithZone:zone] init];
    ref->date = [date copy];
	ref->amount = amount;
	ref->costs=costs;
	ref->milage=milage;
	ref->starts=starts;
	ref->partly=partly;
    return ref;
}
@end
