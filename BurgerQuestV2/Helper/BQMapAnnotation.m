//
//  BQMapAnnotation.m
//  BurgerQuest
//
//  Created by Laurent Menu on 27/04/12.
//  Copyright (c) 2012 BurgerQuest. All rights reserved.
//

#import "BQMapAnnotation.h"

@implementation BQMapAnnotation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;
@synthesize numberOfBurgers;
@synthesize fqID;
@synthesize burger;
@synthesize burgers;
@synthesize number;

- (id)initWithLocation:(CLLocationCoordinate2D)coord {
    self = [super init];
    if (self) {
        coordinate = coord;
    }
    
    return self;
}

@end