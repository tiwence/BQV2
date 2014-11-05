//
//  User.h
//  BurgerQuest
//
//  Created by Sébastien POUDAT on 05/03/12.
//  Copyright (c) 2012 BurgerQuest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
{    
    NSNumber *uid;
    NSString *username;
    NSString *password; // Utilisé uniquement pour le login via BQ
    NSString *email;
    NSString *token;
    NSString *fb_uid;
    NSString *tw_uid;
    NSString *fb_token;
    NSString *tw_token;
    NSString *tw_secret;
    NSString *firstname;
    NSString *lastname;
    NSString *thumbnail;
    NSString *thumbnail_2x;
    NSMutableDictionary *sharingSettings;
    NSMutableDictionary *profileSettings;
}

-(id)initWithData:obj;
-(id)toJSON;

@property (strong, nonatomic) NSNumber *uid;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *fb_uid;
@property (strong, nonatomic) NSString *tw_uid;    
@property (strong, nonatomic) NSString *fb_token;
@property (strong, nonatomic) NSString *tw_token;
@property (strong, nonatomic) NSString *tw_token_secret;
@property (strong, nonatomic) NSString *firstname;
@property (strong, nonatomic) NSString *lastname;
@property (strong, nonatomic) NSString *thumbnail;
@property (strong, nonatomic) NSString *thumbnail_2x;
@property (strong, nonatomic) NSMutableDictionary *sharingSettings;
@property (strong, nonatomic) NSMutableDictionary *profileSettings;

@end
