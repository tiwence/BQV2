//
//  BQAnnotationView.h
//  BurgerQuestV2
//
//  Created by Térence Marill on 13/05/2014.
//  Copyright (c) 2014 BurgerQuest. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UIButton+WebCache.h"
#import "BQMapAnnotation.h"
#import "Burger.h"
#import "UIColor+UIColor_PXExtentions.h"
#import "FontUtils.h"
#import "BurgerDetailViewController.h"
#import "BurgerGalleryCell.h"

@interface BQAnnotationView : MKAnnotationView <UICollectionViewDataSource, UICollectionViewDelegate, MyBurgerCellDelegate>

@property (nonatomic, strong) UIView *calloutView;
@property (nonatomic, strong) UIView *superCalloutView;
@property (nonatomic, strong) UICollectionView *imagesCollectionView;

- (void)performShowBurger:(id)sender;
- (void)setupCollectionView;

@end
