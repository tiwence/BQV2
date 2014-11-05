//
//  BurgerRestaurantCell.m
//  BurgerQuestV2
//
//  Created by Térence Marill on 25/04/2014.
//  Copyright (c) 2014 BurgerQuest. All rights reserved.
//

#import "BurgerRestaurantCell.h"

@implementation BurgerRestaurantCell

@synthesize burgerImageView, burgerNameLabel, ratingLabel, usersLabel, userWhoDiscoverLabel, userPicture, restaurantInfosView;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCell:(Burger *)_burger {

    [[FontUtils instance] customizeWithFonts:[NSArray arrayWithObjects:burgerNameLabel, ratingLabel, usersLabel, nil]];
    
    burgerNameLabel.text = _burger.name;
    float rating = [_burger.rating floatValue] * 2.0;
    ratingLabel.text = [NSString stringWithFormat:@"%.1f", rating];
    usersLabel.text = [NSString stringWithFormat:@"%d", [_burger.count_rating integerValue]];
    
    NSString *userN = @"";
    if (_burger.user.firstname.length > 0) userN = _burger.user.firstname;
    else if (_burger.user.tw_uid.length > 0) userN = _burger.user.tw_uid;
    else userN = _burger.user.username;
    
    userWhoDiscoverLabel.htmlText = [NSString stringWithFormat:@"<font face='DINReg' size='12' color='#30b4b6'>Discover by </font><font face='DINBol' size='12' color='#30b4b6'>%@</font><font face='DINReg' size='12' color='#b0b0b0'>, %@</font>", userN, [[_burger.date timeAgo] lowercaseString]];
    [userWhoDiscoverLabel setNumberOfLines:0];
    [userWhoDiscoverLabel sizeToFit];
    
    // User picture
    CALayer *l = userPicture.layer;
    [l setMasksToBounds:YES];
    [l setCornerRadius:18.0f];
    
    NSString *imagePath;
    if ([UIScreen mainScreen].scale == 2.0) {
        imagePath =  [_burger.user thumbnail_2x];
    } else {
        imagePath =  [_burger.user thumbnail];
    }
    
    if (imagePath.length > 0) {
        NSURL *avatarUrl = [NSURL URLWithString:imagePath];
        userPicture.clipsToBounds = YES;
        [userPicture setImageWithURL:avatarUrl placeholderImage:[UIImage imageNamed:@"AvatarNoSignIn.png"]];
    }
    
    //Customizing uiviews
    [[FontUtils instance] addRoundedCornersToView:restaurantInfosView withTop:0.0 right:0.0 left:4.0 bottom:4.0];
    // Add a bottomBorder.
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, restaurantInfosView.frame.size.height - 2.0f, restaurantInfosView.frame.size.width, 2.0f);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                     alpha:1.0f].CGColor;
    [restaurantInfosView.layer addSublayer:bottomBorder];
    
    //Burger picture
    imagePath = @"";
    if ([UIScreen mainScreen].scale == 2.0) {
        imagePath =  [_burger.user thumbnail_2x];
    } else {
        imagePath =  [_burger.user thumbnail];
    }
    
    l = [self.burgerImageView layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:4.0];
    
    burgerImageView.clipsToBounds = YES;
    if ([[_burger picture] count] >= 1) {
        if ([UIScreen mainScreen].scale == 2.0) {
            imagePath = [[[_burger picture] objectAtIndex:0] single_2x];
        } else {
            imagePath = [[[_burger picture] objectAtIndex:0] single];
        }
        [burgerImageView setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"MapPictureBackground.png"]];
    }
}

@end
