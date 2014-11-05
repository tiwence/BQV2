//
//  AppDelegate.h
//  BurgerQuestV2
//
//  Created by Térence Marill on 24/02/2014.
//  Copyright (c) 2014 BurgerQuest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "BQAPIEngine.h"
#import "BQSession.h"
#import "ALTabBarController.h"
#import "BQNavigationDelegate.h"
#import "RESideMenu.h"
#import "LeftMenuViewController.h"
#import "AuthentViewController.h"

@interface BurgerQuestAppDelegate : UIResponder <UIApplicationDelegate, RESideMenuDelegate, FBLoginViewDelegate>

@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (strong, nonatomic) IBOutlet UINavigationController *burgerQuestNavController;
@property (strong, nonatomic) LeftMenuViewController *leftMenuViewController;
@property (strong, nonatomic) RESideMenu *sideMenuViewController;
@property (nonatomic, strong) FBSessionTokenCachingStrategy *fbTokenCaching;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain) BQAPIEngine *apiEngine;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (BurgerQuestAppDelegate*) sharedAppDelegate;
- (void)displayMainViewController;
- (void)displayAuthentViewController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
