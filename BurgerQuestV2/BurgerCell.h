//
//  BurgerCell.h
//  BurgerQuestV2
//
//  Created by Térence Marill on 16/03/2014.
//  Copyright (c) 2014 BurgerQuest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "Burger.h"
#import "FontUtils.h"
#import "BackgroundLayer.h"

@interface BurgerCell : UITableViewCell <SDWebImageManagerDelegate> {
    
}

@property (nonatomic, retain) Burger *burger;

@property (nonatomic, strong) IBOutlet UIImageView *burgerImageView;
@property (nonatomic, strong) IBOutlet UILabel *burgerNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *restaurantLabel;
@property (nonatomic, strong) IBOutlet UILabel *distanceLabel;
@property (nonatomic, strong) IBOutlet UILabel *usersLabel;
@property (nonatomic, strong) IBOutlet UILabel *ratingLabel;
@property (nonatomic, strong) IBOutlet UILabel *burgersNumberLabel;
@property (nonatomic, strong) IBOutlet UIView *headerBackGroundView;
@property (nonatomic, strong) IBOutlet UIView *burgerInfosView;
@property (nonatomic, strong) IBOutlet UIImageView *pictoBurger;

- (void)configureCell:(Burger *)_burger;

@end

@interface UILabel (BPExtensions)
- (void)sizeToFitFixedWidth:(CGFloat)fixedWidth;
@end