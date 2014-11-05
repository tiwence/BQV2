//
//  SignInViewController.h
//  BurgerQuestV2
//
//  Created by Térence Marill on 27/03/2014.
//  Copyright (c) 2014 BurgerQuest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "FontUtils.h"
#import "MainViewController.h"
#import "LoginViewController.h"
#import "SignUpViewController.h"

@interface AuthentViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *welcomeLabel;
@property (nonatomic, strong) IBOutlet UIButton *registerButton;
@property (nonatomic, strong) IBOutlet UIButton *signinButton;
@property (nonatomic, strong) IBOutlet UIButton *continueButton;

- (IBAction)performRegister:(id)sender;
- (IBAction)performSignIn:(id)sender;
- (IBAction)performWithoutSignIn:(id)sender;


@end
