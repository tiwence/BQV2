//
//  BQNavigationDelegate.m
//  BurgerQuest
//
//  Created by Sébastien POUDAT on 04/03/12.
//  Copyright (c) 2012 BurgerQuest. All rights reserved.
//

#import "BQNavigationDelegate.h"
#import "BurgerQuestAppDelegate.h"

@implementation BQNavigationDelegate

@synthesize navigationControllerQuest;
@synthesize navigationControllerTaste;
@synthesize navigationControllerProfile;
@synthesize navigationControllerActivity;
@synthesize navigationControllerDiscover;

- (void)navigationController:(UINavigationController *)navigationController 
      willShowViewController:(UIViewController *)viewController 
                    animated:(BOOL)animated
{        
    CGRect frame = CGRectMake(0, 0, 180, 44);
    UILabel* label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:24.0];
    label.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:(64./255.) green:(45./255.) blue:(6./255.) alpha:1.];
    
    //The two lines below are the only ones that have changed
    label.text = viewController.title;
    viewController.navigationItem.titleView = label;
}

@end
