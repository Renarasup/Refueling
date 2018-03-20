//
//  Car.h
//  Refueling
//
//  Created by Samuel on 17.06.13.
//  Copyright (c) 2013 Samuel Schepp. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Car : NSObject <NSCopying>
@property (nonatomic) NSString* name;
@property (nonatomic) NSString* fuelType;
@property (nonatomic) NSMutableArray* refuelings;
@property (nonatomic) UIImage* image;

-(id) init;
-(id)copyWithZone:(NSZone *)zone;
@end
