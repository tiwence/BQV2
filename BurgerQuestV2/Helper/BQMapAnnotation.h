//
//  BQMapAnnotation.h
//  BurgerQuest
//
//  Created by Laurent Menu on 27/04/12.
//  Copyright (c) 2012 BurgerQuest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Burger.h"

@interface BQMapAnnotation : NSObject<MKAnnotation> {
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithLocation:(CLLocationCoordinate2D)coord;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic) int numberOfBurgers;
@property (nonatomic) NSString *fqID;
@property (retain, nonatomic) Burger *burger;
@property (retain, nonatomic) NSMutableArray *burgers;
@property (nonatomic, readonly) UIView *contentView;
@property (nonatomic) int number;

@end