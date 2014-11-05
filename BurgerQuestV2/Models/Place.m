//
//  Place.m
//  BurgerQuest
//
//  Created by Sébastien POUDAT on 05/03/12.
//  Copyright (c) 2012 BurgerQuest. All rights reserved.
//

#import "Place.h"
#import "DictionaryHelper.h"
#import "JSONKit.h"

@implementation Place

@synthesize placeID;
@synthesize fqID;
@synthesize name;
@synthesize address;
@synthesize cross_street;
@synthesize city;
@synthesize state;
@synthesize postcode;
@synthesize phone;
@synthesize currency;
@synthesize geocode;
@synthesize distance;
@synthesize numberOfBurgersInPlace;

-(id)initWithData:obj
{       
    NSMutableDictionary *data;
    
    if ([obj isKindOfClass:[NSString class]]) {
        data = [obj objectFromJSONString];
    }
    else {
        data = obj;
    }
    
    if ([data objectForKey:@"geocode"] && [data objectForKey:@"geocode"] != NULL) {
        CLLocationDegrees lat;
        CLLocationDegrees lng;
        
        if ([[data objectForKey:@"geocode"] objectForKey:@"latitude"]) {
            lat = [[[data objectForKey:@"geocode"] objectForKey:@"latitude"] doubleValue];
        }
        
        if ([[data objectForKey:@"geocode"] objectForKey:@"longitude"]) {
            lng = [[[data objectForKey:@"geocode"] objectForKey:@"longitude"] doubleValue];
        }
        
        if ([[data objectForKey:@"geocode"] objectForKey:@"latitude"] && [[data objectForKey:@"geocode"] objectForKey:@"longitude"]) {
            CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(lat, lng);
            self.geocode = coords;
        }
    }
    
    self.placeID = [data stringForKey:@"id"];
    self.fqID = [data objectForKey:@"fq_id"];
    self.name = [data stringForKey:@"name"];
    self.address = [data stringForKey:@"address"];
    self.cross_street = [data stringForKey:@"cross_street"];
    self.city = [data stringForKey:@"city"];
    self.state = [data stringForKey:@"state"];
    self.postcode = [data stringForKey:@"postcode"];
    self.phone = [data stringForKey:@"phone"];
    self.currency = [data stringForKey:@"currency"];
    self.distance = [data objectForKey:@"distance"];
    
    return self;
}

#pragma mark - Methods

- (NSString *)getShortAddress
{
    NSString *placeLabelText = [NSString stringWithFormat:@"%@, %@", self.name, self.city];
    
    return placeLabelText;
}

- (NSString *)getCompleteAddress 
{    
    if ([self.address length] > 0 && [self.postcode length] > 0) {
        NSString *completeAddress = [NSString stringWithFormat:@"%@, %@ %@", self.address, self.postcode, self.city];
        return completeAddress;
    }
    else if ([self.address length] > 0) {
        NSString *completeAddress = [NSString stringWithFormat:@"%@", self.address];
        return completeAddress;
    }
    else {
        return nil;
    }
}

- (NSString *)getDistanceInMeter
{
    NSString *distanceToShow;
    
    if ([self.distance floatValue] >= 1000.) {
        float newDistance = [self.distance floatValue] / 1000;
        distanceToShow = [NSString stringWithFormat:@"%2.f km", newDistance];
    }
    else {
        distanceToShow = [NSString stringWithFormat:@"%@ m", self.distance];
    }
    
    return distanceToShow;
}

@end
