//
//  BQSession.h
//  BurgerQuest
//
//  Created by Sébastien POUDAT on 09/04/12.
//  Copyright (c) 2012 Milky-Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "RSTwitterEngine.h"
#import "User.h"
#import "BQAPIEngine.h"
#import "FBSessionTokenStrategy.h"

@interface BQSession : NSObject
{
    //Facebook *facebook;
    RSTwitterEngine *twitter;
    User *currentUser;
    BQAPIEngine *apiEngine;
    NSString *activeToken;
    BOOL isAnUpdate;
}

+ (BQSession *)sharedSession;
- (BOOL)isAuthenticated;
- (BOOL)isBQLogged;
- (void)restoreAnySession;
- (void)setupUser:(id)data;
- (void)purgeUser;

- (void)authWithFacebook:(NSArray *)permissions;
- (void)logoutWithFacebook;
- (void)logoutForDialogs;

- (void)authWithTwitter;
- (void)twDidLogin;
- (void)twDidLogout;

- (void)grantOverAPI:(BOOL)isForRestore onCompletion:(void (^)(void))completionBlock;
- (void)revokeOverAPI;

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;

//@property (strong, nonatomic) Facebook *facebook;
@property (retain, nonatomic) BQAPIEngine *apiEngine;
@property (strong, nonatomic) RSTwitterEngine *twitter;
@property (strong, nonatomic) User *currentUser;
@property (strong, nonatomic) NSString *activeToken;
@property (nonatomic) BOOL isAnUpdate;
@property (nonatomic, copy) void (^loggedOutHandler)(void);
@property (nonatomic, copy) void (^loggedInHandler)(void);
@property (nonatomic, copy) void (^twitterCompletionBlock)(void);
@property (nonatomic, copy) void (^facebookCompletionBlock)(void);
@property (nonatomic, strong) FBSessionTokenCachingStrategy *fbTokenCaching;

@end
