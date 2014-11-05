//
//  ALTabBarController.m
//  ALCommon
//
//  Created by Andrew Little on 10-08-17.
//  Copyright (c) 2010 Little Apps - www.myroles.ca. All rights reserved.
//

#import "ALTabBarController.h"


@implementation ALTabBarController

@synthesize customTabBarView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self hideExistingTabBar];
    
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"TabBarView" owner:self options:nil];
    self.customTabBarView = [nibObjects objectAtIndex:0];
    
    [self.customTabBarView setCenter:CGPointMake(160., [UIScreen mainScreen].bounds.size.height - 30)];
    
    [self.view addSubview:self.customTabBarView];
}


- (void)hideExistingTabBar
{
	for(UIView *view in self.view.subviews)
	{
		if([view isKindOfClass:[UITabBar class]])
		{
			view.hidden = YES;
			break;
		}
	}
}


@end
