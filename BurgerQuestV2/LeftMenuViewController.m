//
//  LeftMenuViewController.m
//  BurgerQuestV2
//
//  Created by Térence Marill on 25/02/2014.
//  Copyright (c) 2014 BurgerQuest. All rights reserved.
//

#import "LeftMenuViewController.h"

@interface LeftMenuViewController ()

@end

@implementation LeftMenuViewController

@synthesize sidebarDelegate;
@synthesize userImageView, userNameLabel;
@synthesize top10Button, lastButton, homeButton, helpusButton, aboutButton, authentView, logoutButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self displayUserInfos];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[FontUtils instance] customizeWithFonts:[NSArray arrayWithObjects:userNameLabel, helpusButton, aboutButton, homeButton, aboutButton, top10Button, lastButton, nil]];
    
    [homeButton setTitleColor:[UIColor pxColorWithHexValue:@"ea521d"] forState:UIControlStateHighlighted];
    
    if ([[UIScreen mainScreen] bounds].size.height < 568.0f) {
        CGRect logoutFrame = logoutButton.frame;
        logoutFrame.origin.y = 436.0f;
        logoutButton.frame = logoutFrame;
    }
    
    //[homeButton setImage:<#(UIImage *)#> forState:<#(UIControlState)#>]
    
    /*if ([self.sidebarDelegate respondsToSelector:@selector(lastSelectedIndexPathForSidebarViewController:)]) {
        NSIndexPath *indexPath = [self.sidebarDelegate lastSelectedIndexPathForSidebarViewController:self];
    }*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.sidebarDelegate) {
        NSObject *object = [NSString stringWithFormat:@"ViewController%d", indexPath.row];
        [self.sidebarDelegate sidebarViewController:self didSelectObject:object atIndexPath:indexPath];
    }
}*/

- (void)displayUserInfos {
    BQSession *session = [BQSession sharedSession];
    User *user = [session currentUser];
    if (user != nil) {
        self.authentView.hidden = YES;
        self.logoutButton.hidden = NO;
        NSString *userN = @"";
        
        if (user.firstname.length > 0) userN = user.firstname;
        else if (user.tw_uid.length > 0) userN = user.tw_uid;
        else userN = user.username;
        
        self.userNameLabel.text = userN;
        
        // User picture
        NSString *imagePath;
        
        if ([UIScreen mainScreen].scale == 2.0) {
            imagePath =  [user thumbnail_2x];
        } else {
            imagePath =  [user thumbnail];
        }
        
        if (imagePath.length > 0) {
            NSURL *avatarUrl = [NSURL URLWithString:imagePath];
            userImageView.clipsToBounds = YES;
            [userImageView setImageWithURL:avatarUrl placeholderImage:[UIImage imageNamed:@"MapPictureBackground.png"]];
        }
    } else {
        self.authentView.hidden = NO;
        self.logoutButton.hidden = YES;
    }
}

- (IBAction)performTop10:(id)sender {
    if (self.sidebarDelegate) {
        [self.sidebarDelegate sideBarViewController:self performAction:@"Top 10"];
    }
}

- (IBAction)performLast:(id)sender {
    if (self.sidebarDelegate) {
        [self.sidebarDelegate sideBarViewController:self performAction:@"Last"];
    }
}

- (IBAction)performHome:(id)sender {
    if (self.sidebarDelegate) {
        [self.sidebarDelegate sideBarViewController:self performAction:@"Home"];
    }
}

- (IBAction)performSignIn:(id)sender {
    if (self.sidebarDelegate) {
        [self.sidebarDelegate sideBarViewController:self performAction:@"Signin"];
    }
}

- (IBAction)performRegister:(id)sender {
    if (self.sidebarDelegate) {
        [self.sidebarDelegate sideBarViewController:self performAction:@"Register"];
    }
}

- (IBAction)performLogout:(id)sender {
    if (self.sidebarDelegate) {
        [self.sidebarDelegate sideBarViewController:self performAction:@"Logout"];
    }
}


- (IBAction)performAbout:(id)sender {
    
}

@end
