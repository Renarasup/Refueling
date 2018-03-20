//
//  Car.m
//  Refueling
//
//  Created by Samuel on 17.06.13.
//  Copyright (c) 2013 Samuel Schepp. All rights reserved.
//

#import "Car.h"

@implementation Car
@synthesize name, image, refuelings, fuelType;

-(id) init{
    self = [super init];
    if(self){ 
        self.name = @"";
        self.fuelType = @"";
        self.refuelings = [NSMutableArray array];
        self.image = [[UIImage alloc] init];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.image forKey:@"image"];
    [encoder encodeObject:self.refuelings forKey:@"refuelings"];
    [encoder encodeObject:self.fuelType forKey:@"fuelType"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self.name = [decoder decodeObjectForKey:@"name"];
    self.image = [decoder decodeObjectForKey:@"image"];
    self.refuelings = [decoder decodeObjectForKey:@"refuelings"];
    self.fuelType = [decoder decodeObjectForKey:@"fuelType"];
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    Car *car = [[[self class] allocWithZone: zone] init];
    [car setName:[name copyWithZone:zone]];
	[car setFuelType:[fuelType copyWithZone:zone]];
	car->refuelings = [[NSMutableArray alloc]initWithArray:refuelings copyItems:YES];
	NSLog(@"Copied car");
	[car setImage:nil];
    return car;
}
@end