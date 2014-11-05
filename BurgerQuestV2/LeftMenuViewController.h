//
//  LeftMenuViewController.h
//  BurgerQuestV2
//
//  Created by Térence Marill on 25/02/2014.
//  Copyright (c) 2014 BurgerQuest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BQSession.h"
#import "UIImageView+WebCache.h"
#import "FontUtils.h"
#import "UIColor+UIColor_PXExtentions.h"

@protocol SidebarViewControllerDelegate;

@interface LeftMenuViewController : UIViewController

@property (nonatomic, assign) id <SidebarViewControllerDelegate> sidebarDelegate;
@property (nonatomic, strong) IBOutlet UIImageView *userImageView;
@property (nonatomic, strong) IBOutlet UILabel *userNameLabel;

@property (nonatomic, strong) IBOutlet UIView *authentView;
@property (nonatomic, strong) IBOutlet UIButton *top10Button;
@property (nonatomic, strong) IBOutlet UIButton *lastButton;
@property (nonatomic, strong) IBOutlet UIButton *homeButton;
@property (nonatomic, strong) IBOutlet UIButton *aboutButton;
@property (nonatomic, strong) IBOutlet UIButton *helpusButton;
@property (nonatomic, strong) IBOutlet UIButton *logoutButton;

- (IBAction)performTop10:(id)sender;
- (IBAction)performLast:(id)sender;
- (IBAction)performHome:(id)sender;
- (IBAction)performAbout:(id)sender;
- (IBAction)performSignIn:(id)sender;

- (void)displayUserInfos;

@end

@protocol SidebarViewControllerDelegate <NSObject>

- (void)sideBarViewController:(LeftMenuViewController *)sideBarViewController performAction:(NSString *)actionName;

@optional
- (NSIndexPath *)lastSelectedIndexPathForSidebarViewController:(LeftMenuViewController *)sidebarViewController;

@end
