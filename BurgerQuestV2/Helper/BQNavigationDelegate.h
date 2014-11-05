//
//  BQNavigationDelegate.h
//  BurgerQuest
//
//  Created by Sébastien POUDAT on 04/03/12.
//  Copyright (c) 2012 BurgerQuest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BQNavigationDelegate : NSObject <UINavigationControllerDelegate>
{
    UINavigationController *navigationControllerQuest;
    UINavigationController *navigationControllerDiscover;
    UINavigationController *navigationControllerTaste;
    UINavigationController *navigationControllerActivity;
    UINavigationController *navigationControllerProfile;
}

@property (nonatomic, retain) IBOutlet UINavigationController *navigationControllerQuest;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationControllerDiscover;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationControllerTaste;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationControllerActivity;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationControllerProfile;

@end
