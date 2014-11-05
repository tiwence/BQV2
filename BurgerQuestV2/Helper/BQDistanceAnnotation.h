//
//  BQDistanceAnnotation.h
//  BurgerQuestV2
//
//  Created by Térence Marill on 03/11/2014.
//  Copyright (c) 2014 BurgerQuest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BQDistanceAnnotation : NSObject<MKAnnotation> {
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString* title;

- (id)initWithLocation:(CLLocationCoordinate2D)coord;


@end
