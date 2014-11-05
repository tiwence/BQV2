//
//  User.m
//  BurgerQuest
//
//  Created by Sébastien POUDAT on 05/03/12.
//  Copyright (c) 2012 BurgerQuest. All rights reserved.
//

#import "User.h"
#import "DictionaryHelper.h"
#import "JSONKit.h"

@implementation User

@synthesize uid;
@synthesize username;
@synthesize password;
@synthesize email;
@synthesize token;
@synthesize fb_uid;
@synthesize tw_uid;
@synthesize fb_token;
@synthesize tw_token;
@synthesize tw_token_secret;
@synthesize firstname;
@synthesize lastname;
@synthesize thumbnail;
@synthesize thumbnail_2x; 
@synthesize sharingSettings;
@synthesize profileSettings;


-(id)initWithData:obj
{    
    NSMutableDictionary *data;
    
    if ([obj isKindOfClass:[NSString class]]) {
        data = [obj objectFromJSONString];
    }
    else {
        data = obj;
    }
    
    self.uid = [data objectForKey:@"id"];
    self.username = [data objectForKey:@"username"];
    self.password = [data objectForKey:@"password"];
    self.email = [data objectForKey:@"email_address"];
    self.token = [data objectForKey:@"token"];
    self.fb_uid = [data stringForKey:@"fb_uid"];
    self.tw_uid = [data stringForKey:@"tw_uid"];
    self.fb_token = [data stringForKey:@"fb_token"];
    self.tw_token = [data stringForKey:@"tw_token"];
    self.tw_token_secret = [data stringForKey:@"tw_token_secret"];
    self.firstname = [data stringForKey:@"firstname"];
    self.lastname = [data stringForKey:@"lastname"];
    self.thumbnail = [data stringForKey:@"thumbnail"];
    self.thumbnail_2x = [data stringForKey:@"thumbnail_2x"];
    
    if ([[data objectForKey:@"profile_settings"] mutableObjectFromJSONString]) {
        self.profileSettings = [[data objectForKey:@"profile_settings"] mutableObjectFromJSONString];
    }
    else {
        self.profileSettings = [[NSMutableDictionary alloc] init];
    }
    
    if ([[data objectForKey:@"sharing_settings"] mutableObjectFromJSONString]) {
        self.sharingSettings = [[data objectForKey:@"sharing_settings"] mutableObjectFromJSONString];
    }
    else {
        self.sharingSettings = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

-(id)toJSON
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];    
    if (uid)                [data setObject:uid forKey:@"id"];
    if (username)           [data setObject:username forKey:@"username"];
    if (password)           [data setObject:password forKey:@"password"];
    if (email)              [data setObject:email forKey:@"email_address"];
    if (token)              [data setObject:token forKey:@"token"];
    if (fb_uid)             [data setValue:fb_uid forKey:@"fb_uid"];
    if (tw_uid)             [data setValue:tw_uid forKey:@"tw_uid"];   
    if (fb_token)           [data setValue:fb_token forKey:@"fb_token"];
    if (tw_token)           [data setValue:tw_token forKey:@"tw_token"]; 
    if (tw_token_secret)    [data setValue:tw_token_secret forKey:@"tw_token_secret"];
    if (firstname)          [data setValue:firstname forKey:@"firstname"];  
    if (lastname)           [data setValue:lastname forKey:@"lastname"];  
    if (thumbnail)          [data setValue:thumbnail forKey:@"thumbnail"];  
    if (thumbnail_2x)       [data setValue:thumbnail_2x forKey:@"thumbnail_2x"]; 
    if (profileSettings)    [data setValue:[profileSettings JSONString] forKey:@"profile_settings"];
    if (sharingSettings)    [data setValue:[sharingSettings JSONString] forKey:@"sharing_settings"];
    
    return [data JSONString];
}

@end
