//
//  BackgroundLayer.m
//  BurgerQuestV2
//
//  Created by Térence Marill on 11/05/2014.
//  Copyright (c) 2014 BurgerQuest. All rights reserved.
//

#import "BackgroundLayer.h"

@implementation BackgroundLayer

+ (CAGradientLayer*) greyGradient {
    
    UIColor *colorOne = [UIColor colorWithWhite:0.0 alpha:0.5];
    UIColor *colorTwo = [UIColor colorWithWhite:0.0 alpha:0.0];
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:0.6];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
}

@end
