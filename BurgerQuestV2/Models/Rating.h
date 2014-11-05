//
//  Rating.h
//  BurgerQuest
//
//  Created by Sébastien POUDAT on 05/03/12.
//  Copyright (c) 2012 BurgerQuest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Rating : NSObject
{
    NSNumber *ratingID;
    NSNumber *note;
    NSString *comment;
    NSDate *date;
    NSString *timeAgo;
    User *user;
    NSNumber *burger_id;
}

-(id)initWithData:obj;

@property (nonatomic) NSNumber *ratingID;
@property (nonatomic) NSNumber *note;
@property (nonatomic) NSString *comment;
@property (nonatomic) NSDate *date;
@property (nonatomic) NSString *timeAgo;
@property (retain, nonatomic) User *user;
@property (nonatomic) NSNumber *burger_id;

@end
