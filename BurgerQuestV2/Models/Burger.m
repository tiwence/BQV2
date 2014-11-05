//
//  Burger.m
//  BurgerQuest
//
//  Created by Sébastien POUDAT on 05/03/12.
//  Copyright (c) 2012 BurgerQuest. All rights reserved.
//

#import "Burger.h"
#import "DictionaryHelper.h"
#import "JSONKit.h"
#import "BQConfig.h"
#import "NSDate+TimeAgo.h"

#define UPLOAD_DIR(__PATH__) [NSString stringWithFormat:@"%@/%@", API_URL, __PATH__]

@implementation Burger

@synthesize burgerID;
@synthesize name;
@synthesize rating;
@synthesize count_rating;
@synthesize rated;
@synthesize rank;
@synthesize price;
@synthesize url;
@synthesize date;
@synthesize timeAgo;
@synthesize picture;
@synthesize place;
@synthesize user;

-(id)initWithData:obj {
    NSMutableDictionary *data;
    
    if ([obj isKindOfClass:[NSString class]]) {
        data = [obj objectFromJSONString];
    } else if ([obj isKindOfClass:[Burger class]]) {
        return obj;
    } else {
        data = obj;
    }
    
    //NSLog(@"Burger : %@", obj);
    
    NSNumber *priceNumber = [NSNumber numberWithFloat:[[NSString stringWithFormat:@"%02.02f", [[data stringForKey:@"price"] floatValue]] floatValue]];
    
    NSMutableArray *pictures = [data objectForKey:@"picture"];
    self.picture = [[NSMutableArray alloc] init];
    for (NSDictionary *item in pictures) {
        [self.picture addObject:[[Picture alloc] initWithData:item]];
    }
    
    self.burgerID = [data objectForKey:@"id"];
    self.name = [data stringForKey:@"name"];
    self.rank = [data objectForKey:@"rank"];
    self.count_rating = [data objectForKey:@"count_rating"];
    self.rating = [data objectForKey:@"rating"];
    self.price = priceNumber;
    self.url = [data objectForKey:@"url"];
    self.place = [[Place alloc] initWithData:[data objectForKey:@"place"]];
    self.user = [[User alloc] initWithData:[data objectForKey:@"user"]];
    
    // Date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.date = [dateFormatter dateFromString:[data stringForKey:@"date"]];
    self.timeAgo = [date timeAgo];
    
    return self;
}

-(NSString *)showPriceForText
{
    NSString *priceLabel = [NSString stringWithFormat:@"%@", self.price];
    
    return priceLabel;
}

@end
