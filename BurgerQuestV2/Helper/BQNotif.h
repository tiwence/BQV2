//
//  BQNotif.h
//  BurgerQuest
//
//  Created by Laurent Menu on 11/06/12.
//  Copyright (c) 2012 BurgerQuest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BQNotif : UIView
{
    UIWindow *window;
    UIView *containerView;
    UIView *contentView;
    UIImageView *backgroundView;
    UIImageView *picto;
    UIImageView *loader;
    UILabel *titleLabel;
    UILabel *textLabel;
    BOOL isVisible;
    NSTimer *timer;
}

+ (void)show;
+ (void)showDoneWithStatus:(NSString*)string;
+ (void)showErrorWithStatus:(NSString*)string;
+ (void)showSuccessWithStatus:(NSString*)string;

+ (void)dismiss;
+ (void)dismissWithDelay;

+ (void)setStatus:(NSString*)string;

- (void)show;
- (void)showWithStatus:(NSString*)string type:(NSString*)type;
- (void)dismiss;
- (void)dismissWithDelay:(NSTimeInterval)seconds;
- (void)setStatus:(NSString*)string;
- (void)alignViews;
- (void)startLoader;
- (void)stopLoader;


@end