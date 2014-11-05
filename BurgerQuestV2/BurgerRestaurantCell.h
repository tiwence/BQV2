//
//  BurgerRestaurantCell.h
//  BurgerQuestV2
//
//  Created by Térence Marill on 25/04/2014.
//  Copyright (c) 2014 BurgerQuest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Burger.h"
#import "FontUtils.h"
#import "UIImageView+WebCache.h"
#import "NSDate+TimeAgo.h"
#import "MDHTMLLabel.h"
#import "UIImage+RoundedCorner.h"

@interface BurgerRestaurantCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *burgerImageView;
@property (nonatomic, strong) IBOutlet UIImageView *userPicture;
@property (nonatomic, strong) IBOutlet UILabel *burgerNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *usersLabel;
@property (nonatomic, strong) IBOutlet MDHTMLLabel *userWhoDiscoverLabel;
@property (nonatomic, strong) IBOutlet UILabel *ratingLabel;
@property (nonatomic, strong) IBOutlet UIView *restaurantInfosView;

- (void)configureCell:(Burger *)_burger;

@end
