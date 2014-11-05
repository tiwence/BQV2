//
//  SignInViewController.m
//  BurgerQuestV2
//
//  Created by Térence Marill on 27/03/2014.
//  Copyright (c) 2014 BurgerQuest. All rights reserved.
//

#import "AuthentViewController.h"

@interface AuthentViewController ()

@end

@implementation AuthentViewController

@synthesize welcomeLabel, continueButton, signinButton, registerButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    
    [[FontUtils instance] customizeWithFonts:[NSArray arrayWithObjects:welcomeLabel, continueButton, signinButton, registerButton, nil]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)performRegister:(id)sender {
    SignUpViewController *signUpController = [[SignUpViewController alloc] init];
    [self.navigationController pushViewController:signUpController animated:YES];
    signUpController = nil;
}

- (IBAction)performSignIn:(id)sender {
    LoginViewController *signInController = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:signInController animated:YES];
    signInController = nil;
}

- (IBAction)performWithoutSignIn:(id)sender {
    MainViewController *mainController = [[MainViewController alloc] init];
    [[BurgerQuestAppDelegate sharedAppDelegate] leftMenuViewController].sidebarDelegate = mainController.self;
    [self.navigationController pushViewController:mainController animated:YES];
    mainController = nil;
}

@end
