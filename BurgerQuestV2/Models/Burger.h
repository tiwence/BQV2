//
//  Burger.h
//  BurgerQuest
//
//  Created by Sébastien POUDAT on 05/03/12.
//  Copyright (c) 2012 BurgerQuest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Place.h"
#import "Picture.h"
#import "Rating.h"

@interface Burger : NSObject {
    NSNumber *burgerID;
    NSString *name;
    BOOL rated;
    NSNumber *rating;
    NSNumber *count_rating;
    NSString *rank;
    NSNumber *price;
    NSURL *url;
    NSDate *date;
    NSString *timeAgo;
    NSMutableArray *picture;
    Place *place;
    User *user;
}

- (id)initWithData:obj;
- (NSString *)showPriceForText;

@property (nonatomic) NSNumber *burgerID;
@property (nonatomic) NSString *name;
@property (nonatomic) BOOL rated;
@property (nonatomic) NSNumber *rating;
@property (nonatomic) NSNumber *count_rating;
@property (nonatomic) NSString *rank;
@property (nonatomic) NSNumber *price;
@property (nonatomic) NSURL *url;
@property (nonatomic) NSDate *date;
@property (nonatomic) NSString *timeAgo;
@property (retain, nonatomic) NSMutableArray *picture;
@property (retain, nonatomic) Place *place;
@property (retain, nonatomic) User *user;

@end
