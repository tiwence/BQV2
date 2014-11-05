//
//  Place.h
//  BurgerQuest
//
//  Created by Sébastien POUDAT on 05/03/12.
//  Copyright (c) 2012 BurgerQuest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Place : NSObject
{
    NSString *placeID;
    NSString *fqID;
    NSString *name;
    NSString *address;
    NSString *cross_street;
    NSString *city;
    NSString *state;
    NSString *postcode;
    NSString *phone;
    NSString *currency;
    NSString *distance;
    NSNumber *numberOfBurgersInPlace;
    CLLocationCoordinate2D geocode;
}

-(id)initWithData:obj;
- (NSString *)getShortAddress;
- (NSString *)getCompleteAddress;
- (NSString *)getDistanceInMeter;

@property (nonatomic) NSString *placeID;
@property (nonatomic) NSString *fqID;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *address;
@property (nonatomic) NSString *cross_street;
@property (nonatomic) NSString *city;
@property (nonatomic) NSString *state;
@property (nonatomic) NSString *postcode;
@property (nonatomic) NSString *phone;
@property (nonatomic) NSString *currency;
@property (nonatomic) NSNumber *numberOfBurgersInPlace;
@property (nonatomic) NSString *distance;
@property (nonatomic) CLLocationCoordinate2D geocode;

@end
