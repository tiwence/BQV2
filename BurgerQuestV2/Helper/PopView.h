//
//  PopView.h
//  BurgerQuest
//
//  Created by Laurent MENU on 03/05/12.
//  Copyright (c) 2012 BurgerQuest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopView : UIView
{
    UIImageView *contentBackground;
    UIImageView *contentBottom;
}

@property (strong, nonatomic) IBOutlet UIView *background;
@property (strong, nonatomic) IBOutlet UIView *popView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIView *contentViewBackground;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *textLabel;
@property (strong, nonatomic) IBOutlet UIImage *badgeImage;
@property (strong, nonatomic) IBOutlet UIImageView *badgeImageView;

- (void)updateSize;
- (void)showPopView;
- (void)setPopupText:(NSString *)text;
- (void)setBadgeImageWithIDAndType:(NSString *)ID type:(NSString *)type;
- (void)setImageForBadge:(UIImage *)image;

- (IBAction)closePopAction:(id)sender;

@end
