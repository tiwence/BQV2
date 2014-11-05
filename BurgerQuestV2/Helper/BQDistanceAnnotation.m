//
//  BQDistanceAnnotation.m
//  BurgerQuestV2
//
//  Created by Térence Marill on 03/11/2014.
//  Copyright (c) 2014 BurgerQuest. All rights reserved.
//

#import "BQDistanceAnnotation.h"

@implementation BQDistanceAnnotation

@synthesize coordinate;
@synthesize title;

- (id)initWithLocation:(CLLocationCoordinate2D)coord {
    self = [super init];
    if (self) {
        coordinate = coord;
    }
    
    return self;
}

@end
