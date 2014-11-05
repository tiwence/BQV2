//
//  RestaurantViewController.h
//  BurgerQuestV2
//
//  Created by Térence Marill on 26/03/2014.
//  Copyright (c) 2014 BurgerQuest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Burger.h"
#import "BurgerRestaurantCell.h"
#import "BurgerDetailViewController.h"

@interface RestaurantViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *burgers;
    BQAPIEngine *apiEngine;
}

@property (nonatomic, strong) IBOutlet UITableView *burgersTableView;
@property (nonatomic, strong) IBOutlet UIView *navigationTitleView;
@property (nonatomic, strong) IBOutlet UILabel *distanceLabel;
@property (nonatomic, strong) IBOutlet UILabel *burgersNumberLabel;
@property (nonatomic, strong) IBOutlet UILabel *restaurantNameLabel;


- (id)initWithBurgers:(NSMutableArray *)_burgers;

@end
