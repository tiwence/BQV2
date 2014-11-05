//
//  Picture.m
//  BurgerQuest
//
//  Created by Sébastien POUDAT on 05/03/12.
//  Copyright (c) 2012 BurgerQuest. All rights reserved.
//

#import "Picture.h"
#import "BQConfig.h"
#import "JSONKit.h"
#import "DictionaryHelper.h"

@implementation Picture

@synthesize single;
@synthesize single_2x;
@synthesize thumbnail;
@synthesize thumbnail_2x;
@synthesize map;
@synthesize map_2x;
@synthesize user;

- (id)initWithData:obj
{   
    NSMutableDictionary *data;
    
    if ([obj isKindOfClass:[NSString class]]) {
        data = [obj objectFromJSONString];
    }
    else {
        data = obj;
    }
    
    self.single = [NSString stringWithFormat:@"http://%@/%@", API_URL, [data objectForKey:@"image"]];
    self.single_2x = [NSString stringWithFormat:@"http://%@/%@", API_URL, [data objectForKey:@"image_2x"]];
    self.thumbnail = [NSString stringWithFormat:@"http://%@/%@", API_URL, [data objectForKey:@"thumbnail"]];
    self.thumbnail_2x = [NSString stringWithFormat:@"http://%@/%@", API_URL, [data objectForKey:@"thumbnail_2x"]];
    self.map = [NSString stringWithFormat:@"http://%@/%@", API_URL, [data objectForKey:@"map"]];
    self.map_2x = [NSString stringWithFormat:@"http://%@/%@", API_URL, [data objectForKey:@"map_2x"]];
    self.user = [[User alloc] initWithData:[data objectForKey:@"user"]];
    
    return self;
}

@end
