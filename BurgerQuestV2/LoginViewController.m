//
//  SignInViewController.m
//  BurgerQuestV2
//
//  Created by Térence Marill on 01/04/2014.
//  Copyright (c) 2014 BurgerQuest. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@synthesize loggedInHandler = _loggedInHandler;
@synthesize emailTextField, passwordTextField;
@synthesize signinButton, headerLabel, signinWithFBButton, registerButton, forgotPasswordButton, bgImageView, scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setNavBarToTranslucent {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTranslucent:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.navigationController.navigationBar.translucent == NO) {
        [self setNavBarToTranslucent];
    }
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 170, 80)];
    titleLabel.text = @"Sign in";
    titleLabel.textColor = [UIColor pxColorWithHexValue:@"EA531C"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [titleLabel.font fontWithSize:17.0f];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavigationBack.png"]  style:UIBarButtonItemStyleBordered target:self action:@selector(backTo:)];
    
    [[FontUtils instance] customizeWithFonts:[NSArray arrayWithObjects:signinWithFBButton, headerLabel, signinButton, registerButton, forgotPasswordButton, titleLabel, emailTextField, passwordTextField, nil]];
    [[FontUtils instance] customizeTextField:[NSArray arrayWithObjects:emailTextField, passwordTextField, nil]];
    
    self.navigationItem.titleView = titleLabel;
    
    titleLabel = nil;
    
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
    UIImage *bgImg = bgImageView.image;
    bgImg = [bgImg stackBlur:20];
    [bgImageView setImage:bgImg];
    
    // Set le callback des connexion de manière générique
    if (self.loggedInHandler == nil) {
        __block LoginViewController *lc = self;
        [self setLoggedInHandler:^{
            [BQNotif showSuccessWithStatus:@"You are logged in"];
            MainViewController *mvc = [[MainViewController alloc] init];
            [[[BurgerQuestAppDelegate sharedAppDelegate] leftMenuViewController] displayUserInfos];
            [[BurgerQuestAppDelegate sharedAppDelegate] leftMenuViewController].sidebarDelegate = mvc.self;
            [lc.navigationController pushViewController:mvc animated:YES];
            mvc = nil;
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backTo:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)performGoToRegister:(id)sender {
    NSInteger numberOfControllers = self.navigationController.viewControllers.count;
    if (numberOfControllers >= 2) {
        UIViewController *backViewController = [self.navigationController.viewControllers objectAtIndex:numberOfControllers - 2];
        if ([backViewController class] == [SignUpViewController class]) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            SignUpViewController *signUpController = [[SignUpViewController alloc] init];
            [self.navigationController pushViewController:signUpController animated:YES];
            signUpController = nil;
        }
    } else {
        SignUpViewController *signUpController = [[SignUpViewController alloc] init];
        [self.navigationController pushViewController:signUpController animated:YES];
        signUpController = nil;
    }
}

- (IBAction)performLogin:(id)sender {
    if ([passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        [passwordTextField becomeFirstResponder];
        [BQNotif showErrorWithStatus:@"You must enter your password"];
    } else if ([emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        [emailTextField becomeFirstResponder];
        [BQNotif showErrorWithStatus:@"You must enter your user name / email"];
    } else {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:emailTextField.text forKey:@"username"];
        [params setObject:passwordTextField.text forKey:@"password"];
        [BQSession sharedSession].currentUser = [[User alloc] initWithData:params];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"BQ" forKey:@"OAuthType"];
        [defaults setObject:[[BQSession sharedSession].currentUser toJSON] forKey:@"loggedInUser"];
        [defaults synchronize];
        
        // On interroge l'API pour avoir l'user et le connecté
        [[BQSession sharedSession] grantOverAPI:NO onCompletion:self.loggedInHandler];
    }
}

- (IBAction)performLoginWithFacebook:(id)sender {
    [[BQSession sharedSession] setIsAnUpdate:NO];
    [[BQSession sharedSession] setFacebookCompletionBlock:self.loggedInHandler];
    [[BQSession sharedSession] authWithFacebook:@[@"email", @"public_profile", @"user_friends"]];
}

- (IBAction)performForgotPassword:(id)sender {
    ResetPasswordViewController *pwdViewController = [[ResetPasswordViewController alloc] initWithNibName:@"ResetPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:pwdViewController animated:YES];
    pwdViewController = nil;
}

#pragma marks FBLoginDialogDelegate methods

- (void) loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
    
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
    midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
    * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0) heightFraction = 0.0;
    else if (heightFraction > 1.0) heightFraction = 1.0;
    
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown) {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    } else {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

@end
