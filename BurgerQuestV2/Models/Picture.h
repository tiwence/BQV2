//
//  Picture.h
//  BurgerQuest
//
//  Created by Sébastien POUDAT on 05/03/12.
//  Copyright (c) 2012 BurgerQuest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Picture : NSObject
{
    NSString *single;
    NSString *single_2x;
    NSString *thumbnail;
    NSString *thumbnail_2x;
    NSString *map;
    NSString *map_2x;
    User *user;
}

- (id)initWithData:obj;

@property (nonatomic) NSString *single;
@property (nonatomic) NSString *single_2x;
@property (nonatomic) NSString *thumbnail;
@property (nonatomic) NSString *thumbnail_2x;
@property (nonatomic) NSString *map;
@property (nonatomic) NSString *map_2x;
@property (nonatomic, retain) User *user;

@end
