//
//  SignUpViewController.h
//  BurgerQuestV2
//
//  Created by Térence Marill on 01/04/2014.
//  Copyright (c) 2014 BurgerQuest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "JSONKit.h"
#import "NSString+CheckEmail.h"
#import "BQAPIEngine.h"
#import "FontUtils.h"

@interface SignUpViewController : UIViewController <UITextFieldDelegate> {
    BQAPIEngine *apiEngine;
    CGFloat animatedDistance;
}

@property (nonatomic, strong) IBOutlet UIButton *createButton;
@property (nonatomic, strong) IBOutlet UIButton *registerFBButton;
@property (nonatomic, strong) IBOutlet UIButton *alreadyHaveAccountButton;
@property (nonatomic, strong) IBOutlet UILabel *headerLabel;
@property (nonatomic, strong) IBOutlet UIImageView *bgImageView;

@property (nonatomic, strong) IBOutlet UITextField *userNameTextField;
@property (nonatomic, strong) IBOutlet UITextField *emailTextField;
@property (nonatomic, strong) IBOutlet UITextField *passwordTextField;
@property (nonatomic, strong) IBOutlet UITextField *confirmPasswordTextField;

@property (nonatomic, copy) void (^loggedInHandler)(void);

- (IBAction)performRegister:(id)sender;
- (IBAction)performRegisterWithFacebook:(id)sender;
- (IBAction)performGotoLogin:(id)sender;

- (void)backTo:(id)sender;
@end
