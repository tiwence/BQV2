//
//  ResetPasswordViewController.h
//  BurgerQuestV2
//
//  Created by Térence Marill on 12/04/2014.
//  Copyright (c) 2014 BurgerQuest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BurgerQuestAppDelegate.h"
#import "JSONKit.h"
#import "NSString+CheckEmail.h"
#import "BQAPIEngine.h"
#import "FontUtils.h"

@interface ResetPasswordViewController : UIViewController <UITextFieldDelegate> {
    BQAPIEngine *apiEngine;
    CGFloat animatedDistance;
}

@property (nonatomic, strong) IBOutlet UILabel *headerLabel;
@property (nonatomic, strong) IBOutlet UILabel *noticeLabel;
@property (nonatomic, strong) IBOutlet UIImageView *bgImageView;
@property (nonatomic, strong) IBOutlet UIButton *resetButton;

@property (nonatomic, strong) IBOutlet UITextField *emailTextField;

- (IBAction)performResetPassword:(id)sender;

@end
