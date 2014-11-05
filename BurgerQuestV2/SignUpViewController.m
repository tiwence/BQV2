//
//  SignUpViewController.m
//  BurgerQuestV2
//
//  Created by Térence Marill on 01/04/2014.
//  Copyright (c) 2014 BurgerQuest. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@synthesize userNameTextField, passwordTextField, confirmPasswordTextField, emailTextField;
@synthesize alreadyHaveAccountButton, registerFBButton, createButton, headerLabel, bgImageView;

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
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 170, 80)];
    titleLabel.text = @"Register";
    titleLabel.textColor = [UIColor pxColorWithHexValue:@"07A8AA"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [titleLabel.font fontWithSize:17.0f];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavigationBack.png"]  style:UIBarButtonItemStyleBordered target:self action:@selector(backTo:)];
    self.navigationItem.titleView = titleLabel;
    
    [[FontUtils instance] customizeWithFonts:[NSArray arrayWithObjects:alreadyHaveAccountButton, registerFBButton, createButton, alreadyHaveAccountButton, titleLabel, headerLabel, emailTextField, passwordTextField, confirmPasswordTextField, userNameTextField, nil]];
    [[FontUtils instance] customizeTextField:[NSArray arrayWithObjects:emailTextField, passwordTextField, userNameTextField, confirmPasswordTextField, nil]];
    
    titleLabel = nil;
    
    //Get API engine
    apiEngine = [[BurgerQuestAppDelegate sharedAppDelegate] apiEngine];
    
    UIImage *bgImg = bgImageView.image;
    bgImg = [bgImg stackBlur:20];
    [bgImageView setImage:bgImg];
    
    // Set le callback des connexion de manière générique
    if (self.loggedInHandler == nil) {
        __block SignUpViewController *sc = self;
        [self setLoggedInHandler:^{
            [BQNotif showSuccessWithStatus:@"You are logged in"];
            MainViewController *mvc = [[MainViewController alloc] init];
            [[[BurgerQuestAppDelegate sharedAppDelegate] leftMenuViewController] displayUserInfos];
            [[BurgerQuestAppDelegate sharedAppDelegate] leftMenuViewController].sidebarDelegate = mvc.self;
            [sc.navigationController pushViewController:mvc animated:YES];
            mvc = nil;
        }];
    }
}

- (void)backTo:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)performRegister:(id)sender {
    // On vérifie que les champs sont remplis
    if (self.userNameTextField.text.length == 0) {
        [BQNotif showErrorWithStatus:@"You must enter a username"];
        [userNameTextField becomeFirstResponder];
    }
    else if (self.emailTextField.text.length == 0) {
        [BQNotif showErrorWithStatus:@"You must enter an email"];
        [emailTextField becomeFirstResponder];
    }
    else if (![self.emailTextField.text isValidEmail]) {
        [BQNotif showErrorWithStatus:@"You must enter a valid email"];
        [emailTextField becomeFirstResponder];
    }
    else if (self.passwordTextField.text.length == 0 && self.isEditing == NO) {
        [BQNotif showErrorWithStatus:@"You must enter a password"];
        [passwordTextField becomeFirstResponder];
    }
    else if (![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]  && self.isEditing == NO) {
        [BQNotif showErrorWithStatus:@"Your password isn't confirm"];
        [confirmPasswordTextField becomeFirstResponder];
    }
    else {
        //[self hideKeyboardAndScroll];
        
        NSMutableDictionary *paramUser = [[NSMutableDictionary alloc] init];
        [paramUser setObject:userNameTextField.text forKey:@"username"];
        [paramUser setObject:emailTextField.text forKey:@"email_address"];
        [paramUser setObject:passwordTextField.text forKey:@"password"];
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:[paramUser JSONString] forKey:@"user"];
        
        NSData *thumb = nil;
        //if (profilePicture.imageView.image) {
            //thumb = UIImageJPEGRepresentation(profilePicture.imageView.image, 1.0);
        //}
        //else {
          //  thumb = nil;
        //}
        
        // Modification
        if (self.isEditing) {
            [self.navigationController popViewControllerAnimated:YES];
            self.loggedInHandler();
        }
        // Ajout
        else {
            [apiEngine createUserWithParams:params andData:thumb onCompletion:^(NSMutableDictionary *status, NSMutableDictionary *events, NSMutableDictionary *response) {
                
                [BQNotif showSuccessWithStatus:@"Welcome on BurgerQuest!"];
                
                // Connexion de l'utilisateur
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:[response objectForKey:@"token"] forKey:@"token"];
                [defaults synchronize];
                
                /*[[GANTracker sharedTracker] trackEvent:@"register"
                                                action:@"bq"
                                                 label:@"/register/bq"
                                                 value:-1
                                             withError:nil];*/
                
                // Setup User
                [[BQSession sharedSession] setActiveToken:[response objectForKey:@"token"]];
                [defaults setObject:@"BQ" forKey:@"OAuthType"];
                [BQSession sharedSession].currentUser = [[User alloc] initWithData:response];
                [defaults setObject:[[BQSession sharedSession].currentUser toJSON] forKey:@"loggedInUser"];
                [defaults synchronize];
                
                [self.navigationController popViewControllerAnimated:NO];
                self.loggedInHandler();
                
            } onError:^(NSError *error) {
                
            }];
        }
    }
}

- (IBAction)performRegisterWithFacebook:(id)sender {
    [[BQSession sharedSession] setIsAnUpdate:NO];
    [[BQSession sharedSession] setFacebookCompletionBlock:self.loggedInHandler];
    [[BQSession sharedSession] authWithFacebook:[NSArray arrayWithObjects:@"email",nil]];
}

- (IBAction)performGotoLogin:(id)sender {
    NSInteger numberOfControllers = self.navigationController.viewControllers.count;
    if (numberOfControllers >= 2) {
        UIViewController *backViewController = [self.navigationController.viewControllers objectAtIndex:numberOfControllers - 2];
        if ([backViewController class] == [LoginViewController class]) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            [self.navigationController pushViewController:loginViewController animated:YES];
            loginViewController = nil;
        }
    } else {
        LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [self.navigationController pushViewController:loginViewController animated:YES];
        loginViewController = nil;
    }
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
