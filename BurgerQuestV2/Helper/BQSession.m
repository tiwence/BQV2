//
//  BQSession.m
//  BurgerQuest
//
//  Created by Sébastien POUDAT on 09/04/12.
//  Copyright (c) 2012 Milky-Interactive. All rights reserved.
//

#import "DictionaryHelper.h"
#import "BQSession.h"
#import "JSONKit.h"
#import "BurgerQuestAppDelegate.h"

@implementation BQSession

//@synthesize facebook;
@synthesize twitter;
@synthesize currentUser;
@synthesize activeToken;
@synthesize isAnUpdate;
@synthesize loggedOutHandler = _loggedOutHandler;
@synthesize facebookCompletionBlock = _facebookCompletionBlock;
@synthesize twitterCompletionBlock = _twitterCompletionBlock;
@synthesize loggedInHandler = _loggedInHandler;
@synthesize apiEngine;

#pragma mark - Singleton methods

static BQSession *_sharedSession = nil;

+ (BQSession *)sharedSession
{    
    if(_sharedSession != nil) {
        return _sharedSession;
    }
    
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedSession = [[BQSession alloc] init];
    });
    
    return _sharedSession;
}

- (id)copyWithZone:(NSZone *)zone 
{
    return self;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        [self setup];
        [self setIsAnUpdate:NO];
    }
    
    return self;
}

#pragma mark - Custom singleton methods

- (void)setup
{
    apiEngine = [[BurgerQuestAppDelegate sharedAppDelegate] apiEngine];
    currentUser = [[User alloc] init];

    //facebook = [[Facebook alloc] initWithAppId:FBSession.activeSession.appID andDelegate:nil];
    twitter = [[RSTwitterEngine alloc] initWithStatusChangedHandler:^(NSString *newStatus) {
        if(MODE_DEBUG) NSLog(@"TW Status : %@", newStatus);
    }];
}

#pragma mark - Auth

-(void)authWithFacebook:(NSArray *)permissions {
    if (MODE_DEBUG) NSLog(@"FB LOGIN : %@", permissions);
    
    //if ([apiEngine isReachable]) {
        
            // If the session state is any of the two "open" states when the button is clicked
            if (FBSession.activeSession.state == FBSessionStateOpen
                || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
                
                // Close the session and remove the access token from the cache
                // The session state handler (in the app delegate) will be called automatically
                [FBSession.activeSession closeAndClearTokenInformation];
                
                // If the session state is not any of the two "open" states when the button is clicked
            } else {
                // Open a session showing the user the login UI
                // You must ALWAYS ask for basic_info permissions when opening a session
                [FBSession openActiveSessionWithReadPermissions:permissions
                                                   allowLoginUI:YES
                                              completionHandler:
                 ^(FBSession *session, FBSessionState state, NSError *error) {
                     
                     // Retrieve the app delegate
                     //AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
                     // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
                     //[appDelegate sessionStateChanged:session state:state error:error];
                     NSLog(@"%@", session);
                
                     if (!error) {
                         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                         if (isAnUpdate == NO) {
                             [defaults setObject:@"FB" forKey:@"OAuthType"];
                             [defaults setObject:FBSession.activeSession.accessTokenData.accessToken forKey:@"token"];
                             [self setActiveToken:FBSession.activeSession.accessTokenData.accessToken];
                         }
                         
                         [defaults synchronize];
                         
                         if (FBSession.activeSession.isOpen) {
                             [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *result, NSError *error) {
                                 if (!error) {
                                     if(MODE_DEBUG) NSLog(@"FB REQUEST FOR ME : %@", result);
                                     
                                     if (isAnUpdate == NO) {
                                         [self setupUser:result];
                                     } else {
                                         currentUser.fb_uid = result.objectID;
                                         currentUser.fb_token = FBSession.activeSession.accessTokenData.accessToken;
                                         currentUser.email = [result objectForKey:@"email"];
                                         currentUser.firstname = result.first_name;
                                         currentUser.lastname = result.last_name;
                                         currentUser.thumbnail = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture", result.objectID];
                                         currentUser.thumbnail_2x = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", result.objectID];
                                         
                                         [defaults setObject:[currentUser toJSON] forKey:@"loggedInUser"];
                                         [defaults synchronize];
                                     }
                                     
                                     // Requête à l'API BQ
                                     [self grantOverAPI:NO onCompletion:_facebookCompletionBlock];
                                     
                                     //[self grantOverHullonCompletion:_facebookCompletionBlock];
                                     
                                     //_facebookCompletionBlock();
                                 }
                                 else {
                                     [self logoutWithFacebook];
                                 }
                             }];
                         }
                         
                     }
                     //Create or login user ?
                 }];
            }
        
    //} else {
        
    //}
    
}

-(void)authWithTwitter
{            
    //if ([apiEngine isReachable]) {
        
        [BQNotif show];
        
        [twitter authenticateWithCompletionBlock:^(NSError *error) {            
            if([twitter isAuthenticated])
            {
                if(MODE_DEBUG) NSLog(@"AUTH WITH TWITTER : TWITTER LOGGED");
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                
                if (isAnUpdate == NO) [defaults setObject:@"TW" forKey:@"OAuthType"];
                
                [self twDidLogin];
            }
        }];
    /*}
    else {
        [BQNotif showErrorWithStatus:@"You must be connected"];
    }*/
}

#pragma mark - FBSession methods

- (void)logoutWithFacebook
{
    [FBSession.activeSession closeAndClearTokenInformation];
    [self logoutForDialogs];
    [self revokeOverAPI];
}


- (void)logoutForDialogs {
    
    //facebook.accessToken = nil;
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        NSString* domainName = [cookie domain];
        NSRange domainRange = [domainName rangeOfString:@"facebook"];
        if(domainRange.length > 0)
        {
            [storage deleteCookie:cookie];
        }
    }
}

#pragma mark - TwitterEngine Delegate Methods

- (void)twDidLogin
{
    if (MODE_DEBUG) { NSLog(@"TW DID LOGIN"); }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[twitter token] forKey:@"TWAccessTokenKey"];
    [defaults setObject:[twitter tokenSecret] forKey:@"TWAccessTokenSecret"];    
    [defaults setObject:[twitter token] forKey:@"token"];
    [defaults synchronize];
    
    /*[[GANTracker sharedTracker] trackEvent:@"auth"
                                    action:@"twitter"
                                     label:@"/auth/twitter"
                                     value:-1
                                 withError:nil]; */   
    
    // Setup User
    if (isAnUpdate == NO) {
        [self setActiveToken:[twitter token]];
        [defaults setObject:@"TW" forKey:@"OAuthType"];

        [self setupUser:nil];
    }
    else {        
        currentUser.tw_uid = [twitter screenName];
        currentUser.tw_token = [twitter token];
        currentUser.tw_token_secret = [twitter tokenSecret];
        
        [defaults setObject:[currentUser toJSON] forKey:@"loggedInUser"];  
        [defaults synchronize];
    }
    
    // Requête à l'API BQ
    [self grantOverAPI:NO onCompletion:_twitterCompletionBlock];
}

- (void)twDidLogout
{
    [self revokeOverAPI];
}

#pragma mark - Helpers methods

-(BOOL)isAuthenticated
{            
    if (FBSession.activeSession.isOpen || [twitter isAuthenticated] || [self isBQLogged]) {
        return YES;
    } else {        
        return NO;
    }
}

- (BOOL)isBQLogged
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([[defaults objectForKey:@"OAuthType"] isEqualToString:@"BQ"] && [defaults objectForKey:@"token"] && [defaults objectForKey:@"loggedInUser"]) {
        return YES;
    }
    else {
        return NO;
    }
}

-(void)setupUser:(id)data {
    currentUser = [[User alloc] init];
    
    if ([twitter isAuthenticated])
    {
        currentUser.tw_uid = [twitter screenName];
        currentUser.tw_token = [twitter token];
        currentUser.tw_token_secret = [twitter tokenSecret];
        currentUser.firstname = [twitter screenName];
        currentUser.lastname = @"";
        currentUser.thumbnail = [NSString stringWithFormat:@"https://api.twitter.com/1/users/profile_image?screen_name=%@&size=bigger", [twitter screenName]];
        currentUser.thumbnail_2x = [NSString stringWithFormat:@"https://api.twitter.com/1/users/profile_image?screen_name=%@&size=bigger", [twitter screenName]];                
    }
    
    if (FBSession.activeSession.isOpen)
    {
        currentUser.fb_uid = [data stringForKey:@"id"];
        currentUser.fb_token = FBSession.activeSession.accessToken;
        currentUser.email = [data stringForKey:@"email"];
        currentUser.firstname = [data stringForKey:@"first_name"];
        currentUser.lastname = [data stringForKey:@"last_name"];
        currentUser.thumbnail = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture", [data stringForKey:@"id"]];
        currentUser.thumbnail_2x = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", [data stringForKey:@"id"]];
    }
    
    if (MODE_DEBUG) NSLog(@"SETUP USER : %@", [currentUser toJSON]);

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[currentUser toJSON] forKey:@"loggedInUser"];  
    [defaults synchronize];
}

-(void)purgeUser {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"OAuthType"];    
    [defaults removeObjectForKey:@"TWAccessTokenKey"];
    [defaults removeObjectForKey:@"TWAccessTokenSecret"];    
    [defaults removeObjectForKey:@"loggedInUser"];
    [defaults removeObjectForKey:@"token"];
    [defaults synchronize];
    
    [FBSession.activeSession closeAndClearTokenInformation];
    
    currentUser = nil;
    
    activeToken = nil;
}

- (void)grantOverHullonCompletion:(void (^)(void))completionBlock {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"{\"access_token\":\"%@\"", currentUser.fb_token] forKey:@"facebook"];
    [params setValue:@"53a7eee95dcbe2f86e00156f" forKey:@"app_id"];
    
    dispatch_async(dispatch_get_main_queue(),^ {
        [apiEngine postHullPath:@"https://2fc96780.hullapp.io/api/v1/users" withParams:params onCompletion:^(NSMutableDictionary *status, NSMutableDictionary *events, NSMutableDictionary *response) {
            NSLog(@"Response : %@", response);
        } onError:^(NSError *error) {
            NSLog(@"Error : %@", error);
        }];
    });
}

- (void)grantOverAPI:(BOOL)isForRestore onCompletion:(void (^)(void))completionBlock {
    
    // On récupère l'utilisateur qui s'est connecté avec FB ou TW ou BQ (via formulaire)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    currentUser = [[User alloc] initWithData:[defaults objectForKey:@"loggedInUser"]];
        
    // Paramètre pour envoi à l'API
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[currentUser toJSON] forKey:@"user"];
    
    BOOL animated;
    
    if (isAnUpdate == NO) {
        animated = YES;
        [params setValue:[defaults objectForKey:@"OAuthType"] forKey:@"OAuthType"];
    }
    
    NSString *path;
    if (isAnUpdate == YES) {
        animated = NO;
        path = [NSString stringWithFormat:@"user/%@/edit", currentUser.uid];
        
        [BQNotif show];
    }
    else {
        path = @"user/auth";
    }
        
    dispatch_async(dispatch_get_main_queue(),^ {        
        [apiEngine postPath:path
                 withParams: params
               onCompletion:^(NSMutableDictionary *status, NSMutableDictionary *events, NSMutableDictionary *response) {                  
                   
                   // Check if token is valid
                   if ([[status objectForKey:@"code"] isEqualToNumber:[NSNumber numberWithInt:0]]) {
                        for (NSString *error in [status objectForKey:@"error"]) {
                            if(MODE_DEBUG) NSLog(@"ERROR : %@", error);
                            if ([error isEqualToString:@"201"]) {
                                
                                if (MODE_DEBUG) NSLog(@"PURGE");
                                
                                [self revokeOverAPI];
                            }
                        }
                    }
                    else {
                           
                        // Save user id on defaults        
                        currentUser = [[User alloc] initWithData:response];
                        
                        // On réenregistre l'user avec toutes les infos récup depuis l'API
                        [defaults setObject:[currentUser toJSON] forKey:@"loggedInUser"];
                        
                        // Si on est connecté via BQ, on enregistre le token de l'user
                        if ([[defaults objectForKey:@"OAuthType"] isEqualToString:@"BQ"]) {
                            [defaults setObject:[response objectForKey:@"token"] forKey:@"token"];
                            
                            self.activeToken = [response objectForKey:@"token"];
                        }
                        
                        [defaults synchronize];
                        
                        if (isAnUpdate == YES) {
                            [BQNotif showDoneWithStatus:nil];
                        }

                        if (completionBlock) {
                            completionBlock();
                        }
                        
                    }
            
        } onError:^(NSError *error) {            
            [self purgeUser];
        }];
    });
}

-(void)revokeOverAPI {
    if(MODE_DEBUG) NSLog(@"CALL RevokeOverAPI");
    
    // Force deleting twitter token
    [twitter forgetStoredToken];
    
    if (activeToken.length > 0) {        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        
        [params setObject:activeToken forKey:@"token"];
        
        [BQNotif show];
        
        [apiEngine getPath:@"user/deauth"
            withParams: params
          onCompletion:^(NSMutableDictionary *status, NSMutableDictionary *events, NSMutableArray *response) {               
              
              [BQNotif dismiss];
              [self purgeUser];
              
              if (MODE_DEBUG)
                  NSLog(@"PURGE");
              
              self.loggedOutHandler();
              
          } onError:^(NSError *error) {
              [BQNotif dismiss];
              [self purgeUser];
              
              if (MODE_DEBUG)
                  NSLog(@"PURGE");
              
              self.loggedOutHandler();
          }];
    }
    else {
        [self purgeUser];
        
        self.loggedOutHandler();
    }
}

-(void)restoreAnySession { 
    if(MODE_DEBUG) { NSLog(@"Restore any session"); }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        if (MODE_DEBUG)
            NSLog(@"FB session trouvée => connexion");
        
        [self authWithFacebook:[NSArray arrayWithObjects:@"email",nil]];
    } else {
        if([self isAuthenticated] && [defaults objectForKey:@"loggedInUser"]) {
            currentUser = [currentUser initWithData:[defaults objectForKey:@"loggedInUser"]];
            
            // On vérifie si on a l'email de la personne
            if(FBSession.activeSession.isOpen && currentUser.email.length == 0) {
                if (MODE_DEBUG)
                    NSLog(@"FB session trouvée mais pas de mail => déconnexion");
                
                [self logoutWithFacebook];
            } else {
                if (FBSession.activeSession.isOpen) {
                    activeToken = FBSession.activeSession.accessTokenData.accessToken;
                }
                
                [BQNotif show];
                
                self.loggedInHandler();
                
                [self grantOverAPI:YES onCompletion:nil];
            }
        } else {
            if (MODE_DEBUG)
                NSLog(@"Pas de session => vide le cache");
            
            [self revokeOverAPI];
        }
    }
}

@end
