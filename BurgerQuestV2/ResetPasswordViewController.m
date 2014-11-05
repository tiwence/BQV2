//
//  ResetPasswordViewController.m
//  BurgerQuestV2
//
//  Created by Térence Marill on 12/04/2014.
//  Copyright (c) 2014 BurgerQuest. All rights reserved.
//

#import "ResetPasswordViewController.h"

@interface ResetPasswordViewController ()

@end

@implementation ResetPasswordViewController

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@synthesize emailTextField, resetButton, headerLabel, noticeLabel, bgImageView;

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
    
    UIImage *bgImg = bgImageView.image;
    bgImg = [bgImg stackBlur:40];
    [bgImageView setImage:bgImg];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    apiEngine = [[BurgerQuestAppDelegate sharedAppDelegate] apiEngine];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 170, 80)];
    titleLabel.text = @"Sign in";
    titleLabel.textColor = [UIColor pxColorWithHexValue:@"EA531C"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [titleLabel.font fontWithSize:17.0f];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavigationBack.png"]  style:UIBarButtonItemStyleBordered target:self action:@selector(backTo:)];
    self.navigationItem.titleView = titleLabel;
    
    [[FontUtils instance] customizeWithFonts:[NSArray arrayWithObjects:resetButton, headerLabel, noticeLabel, emailTextField, titleLabel, nil]];
    [[FontUtils instance] customizeTextField:[NSArray arrayWithObjects:emailTextField, nil]];
    
    titleLabel = nil;
    
    self.emailTextField.delegate = self;
}

- (void)backTo:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)performResetPassword:(id)sender {
    if (emailTextField.text.length > 0) {
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:emailTextField.text forKey:@"email"];
        
        [apiEngine postPath:@"user/resetPass" withParams:params onCompletion:^(NSMutableDictionary *status, NSMutableDictionary *events, NSMutableDictionary *response) {
            
            [BQNotif showSuccessWithStatus:@"Your password has been reset ! Check your email !"];
            [self.navigationController popViewControllerAnimated:YES];
            
        } onError:^(NSError *error) {
            
        }];
    } else {
        [BQNotif showErrorWithStatus:@"The email is empty"];
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
