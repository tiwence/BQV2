//
//  BurgerDetailViewController.h
//  BurgerQuestV2
//
//  Created by Térence Marill on 20/03/2014.
//  Copyright (c) 2014 BurgerQuest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILabel+dynamicSizeMe.h"
#import "UIImageView+WebCache.h"
#import "Place.h"
#import "Rating.h"
#import "BurgerQuestAppDelegate.h"
#import "Burger.h"
#import "User.h"
#import "BQSession.h"
#import "DetailGalleryCell.h"
#import "UIImage+RoundedCorner.h"
#import <Social/Social.h>
#import <Twitter/Twitter.h>
#import <FacebookSDK/FacebookSDK.h>
#import "NSDate+TimeAgo.h"
#import "BQActivityProvider.h"
#import "UIColor+UIColor_PXExtentions.h"
#import "BackgroundLayer.h"

@interface BurgerDetailViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UIActionSheetDelegate> {
    Burger *burger;
    BQAPIEngine *apiEngine;
    NSMutableArray *commentsList;
    CALayer *bgLayer;
    UIImage *mainBurgerPic;
}


@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UIImageView *pictoAddress;

@property (nonatomic, strong) IBOutlet UIImageView *userPic;
@property (nonatomic, strong) IBOutlet UILabel *burgerNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *restaurantNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *ratingsInfosLabel;
@property (nonatomic, strong) IBOutlet UILabel *ratingLabel;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UICollectionView *imagesCollectionView;
@property (nonatomic, strong) IBOutlet UITextField *addCommentTextField;
@property (nonatomic, strong) IBOutlet UIView *navigationTitleView;
@property (nonatomic, strong) IBOutlet UIView *infosView;
@property (nonatomic, strong) IBOutlet UIPageControl *burgerPicsPageControl;
@property (nonatomic, strong) IBOutlet UIButton *hateButton;
@property (nonatomic, strong) IBOutlet UIButton *likeButton;
@property (nonatomic, strong) IBOutlet UIButton *loveButton;


- (id)initWithBurger:(Burger*)_burger;

- (void)displayBurgerInfos;

- (IBAction)performCamera:(id)sender;
- (IBAction)performMediaFiles:(id)sender;
- (IBAction)performRating:(id)sender;
- (void)performAddRating:(id)sender;
- (void)requestData;
- (void)setupCollectionView;
- (void)performSharing:(id)sender;
- (void)performOldSharing:(id)sender;


@end
