//
//  Rating.m
//  BurgerQuest
//
//  Created by Sébastien POUDAT on 05/03/12.
//  Copyright (c) 2012 BurgerQuest. All rights reserved.
//

#import "Rating.h"
#import "DictionaryHelper.h"
#import "JSONKit.h"
#import "NSDate+TimeAgo.h"

@implementation Rating

@synthesize ratingID;
@synthesize note;
@synthesize comment;
@synthesize date;
@synthesize timeAgo;
@synthesize user;
@synthesize burger_id;

-(id)initWithData:obj
{       
    NSMutableDictionary *data;
    
    if ([obj isKindOfClass:[NSString class]]) {
        data = [obj objectFromJSONString];
    }
    else {
        data = obj;
    }
    
    self.ratingID = [data objectForKey:@"id"];
    self.note = [data objectForKey:@"note"];
    self.comment = [data stringForKey:@"comment"];
    self.user = [[User alloc] initWithData:[data objectForKey:@"user"]];
    self.burger_id = [data objectForKey:@"burger_id"];
    
    // Date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.date = [dateFormatter dateFromString:[data stringForKey:@"date"]];
    self.timeAgo = [date timeAgo];
    
    return self;
}

@end
