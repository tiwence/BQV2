//
//  SignInViewController.h
//  BurgerQuestV2
//
//  Created by Térence Marill on 01/04/2014.
//  Copyright (c) 2014 BurgerQuest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "SignUpViewController.h"
#import "MainViewController.h"
#import "ResetPasswordViewController.h"
#import "BQSession.h"
#import "FontUtils.h"
#import "UIImage+StackBlur.h"

@interface LoginViewController : UIViewController <FBLoginViewDelegate, UITextFieldDelegate> {
    CGFloat animatedDistance;
}

@property (nonatomic, copy) void (^loggedInHandler)(void);

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UILabel *headerLabel;
@property (nonatomic, strong) IBOutlet UIButton *signinButton;
@property (nonatomic, strong) IBOutlet UIButton *signinWithFBButton;
@property (nonatomic, strong) IBOutlet UIButton *registerButton;
@property (nonatomic, strong) IBOutlet UIButton *forgotPasswordButton;
@property (nonatomic, strong) IBOutlet UIImageView *bgImageView;

@property (nonatomic, strong) IBOutlet UITextField *emailTextField;
@property (nonatomic, strong) IBOutlet UITextField *passwordTextField;

- (IBAction)performGoToRegister:(id)sender;
- (IBAction)performLogin:(id)sender;
- (IBAction)performLoginWithFacebook:(id)sender;
- (IBAction)performForgotPassword:(id)sender;

- (void)backTo:(id)sender;

@end
