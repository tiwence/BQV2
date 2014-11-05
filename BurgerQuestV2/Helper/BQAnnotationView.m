//
//  BQAnnotationView.m
//  BurgerQuestV2
//
//  Created by Térence Marill on 13/05/2014.
//  Copyright (c) 2014 BurgerQuest. All rights reserved.
//

#import "BQAnnotationView.h"

@implementation BQAnnotationView

@synthesize calloutView, imagesCollectionView, superCalloutView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (selected) {
        if (superCalloutView != nil)
            superCalloutView = nil;
        if (superCalloutView == nil) {
            //Drawing view
            BQMapAnnotation *bqAnnotation = (BQMapAnnotation *)self.annotation;
            
            calloutView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 134)];
            superCalloutView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 163)];
            superCalloutView.backgroundColor = [UIColor clearColor];
            
            calloutView.backgroundColor = [UIColor whiteColor];
            UILabel *restaurantLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 170, 20)];
            restaurantLabel.textColor = [UIColor pxColorWithHexValue:@"EA531C"];
            [restaurantLabel setFont:[UIFont systemFontOfSize:17]];
            restaurantLabel.text = [bqAnnotation burger].place.name;
            UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(32, 40, 50, 20)];
            distanceLabel.textColor = [UIColor pxColorWithHexValue:@"8E8E8E"];
            distanceLabel.text = [NSString stringWithFormat:@"%@", [[bqAnnotation burger].place getDistanceInMeter]];
            [distanceLabel setFont:[UIFont systemFontOfSize:13]];
            UILabel *numberOfBurgersLabel = [[UILabel alloc] initWithFrame:CGRectMake(108, 40, 172, 20)];
            numberOfBurgersLabel.textColor = [UIColor pxColorWithHexValue:@"8E8E8E"];
            if ([bqAnnotation numberOfBurgers] > 1)
                numberOfBurgersLabel.text = [NSString stringWithFormat:@"%d burger(s)", [bqAnnotation numberOfBurgers]];
            else
                numberOfBurgersLabel.text = @"1 burger";

            [numberOfBurgersLabel setFont:[UIFont systemFontOfSize:13]];
            
            [[FontUtils instance] customizeWithFonts:[NSMutableArray arrayWithObjects:restaurantLabel, distanceLabel, numberOfBurgersLabel, nil]];
            
            UIImageView *distancePicto = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PictoPointerGrey.png"]];
            CGRect distanceFrame = distancePicto.frame;
            distanceFrame.origin = CGPointMake(20, 45);
            distanceFrame.size = CGSizeMake(8, 10);
            distancePicto.frame = distanceFrame;
            
            UIImageView *burgerPicto = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PictoBurgerGrey.png"]];
            CGRect burgerFrame = distancePicto.frame;
            burgerFrame.origin = CGPointMake(94, 45);
            burgerFrame.size = CGSizeMake(10, 10);
            burgerPicto.frame = burgerFrame;
            
            UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(216, 20, 24, 24)];
            UIImage *annotationArrowDown = nil;
            if ([UIScreen mainScreen].scale < 2.0) {
                [rightButton setImage:[UIImage imageNamed:@"RightGreenArrow.png"] forState:UIControlStateNormal];
                annotationArrowDown = [UIImage imageNamed:@"AnnotationArrow.png"];
            } else {
                [rightButton setImage:[UIImage imageNamed:@"RightGreenArrow@2x.png"] forState:UIControlStateNormal];
                annotationArrowDown = [UIImage imageNamed:@"AnnotationArrow@2x.png"];
            }
            
            [self setupCollectionView];
            self.imagesCollectionView.dataSource = self;
            self.imagesCollectionView.delegate = self;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self action:@selector(performShowBurger:)];
            tap.numberOfTapsRequired = 1;
            [rightButton addGestureRecognizer:tap];
            
            UIImageView *arrowView = [[UIImageView alloc] initWithImage:annotationArrowDown];
            CGRect frame = arrowView.frame;
            frame.origin.x = (calloutView.frame.size.width / 2) - (frame.size.width / 2);
            frame.origin.y = calloutView.frame.size.height - (frame.size.height / 2);
            arrowView.frame = frame;
            
            [calloutView addSubview:restaurantLabel];
            [calloutView addSubview:distanceLabel];
            [calloutView addSubview:numberOfBurgersLabel];
            [calloutView addSubview:rightButton];
            [calloutView addSubview:burgerPicto];
            [calloutView addSubview:distancePicto];
            [superCalloutView addSubview:arrowView];
            [calloutView addSubview:imagesCollectionView];
            
            calloutView.layer.cornerRadius = 5;
            calloutView.layer.masksToBounds = YES;
        }
        
        [imagesCollectionView reloadData];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
           superCalloutView.center = CGPointMake(self.bounds.origin.x / 2 + 20.0f, - superCalloutView.bounds.size.height / 2 - 10.0f);
        } else {
            superCalloutView.center = CGPointMake(self.bounds.origin.x / 2 + 12.0f, - superCalloutView.bounds.size.height / 2 + 10.0f);
        }
        
        [superCalloutView addSubview:calloutView];
        superCalloutView.alpha = 0.0f;
        
        [self addSubview:superCalloutView];
        [UIView animateWithDuration:0.25 animations:^{superCalloutView.alpha = 1.0;}];
    } else {
        [UIView animateWithDuration:0.25 animations:^{superCalloutView.alpha = 0.0;} completion:^(BOOL finished){
            [superCalloutView removeFromSuperview];
        }];
    }
}

- (void)performShowBurger:(id)sender {
    BQMapAnnotation *bqAnnotation = (BQMapAnnotation *)self.annotation;
    BurgerQuestAppDelegate *del = (BurgerQuestAppDelegate *)[UIApplication sharedApplication].delegate;

    if ([bqAnnotation numberOfBurgers] > 1) {
        RestaurantViewController *restaurantController = [[RestaurantViewController alloc] initWithBurgers:[bqAnnotation burgers]];
        [del.burgerQuestNavController pushViewController:restaurantController animated:YES];
        restaurantController = nil;
    } else {
        Burger* burger = [bqAnnotation burger];
        burger.place.numberOfBurgersInPlace = [NSNumber numberWithInt:[bqAnnotation numberOfBurgers]];
        BurgerDetailViewController *detailController = [[BurgerDetailViewController alloc] initWithBurger:burger];
        
        [del.burgerQuestNavController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [del.burgerQuestNavController.navigationBar setShadowImage:[UIImage new]];
        [del.burgerQuestNavController.navigationBar setTranslucent:YES];
        
        [del.burgerQuestNavController  pushViewController:detailController animated:YES];
        detailController = nil;
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView* hitView = [super hitTest:point withEvent:event];
    if (hitView != nil)
    {
        [self.superview bringSubviewToFront:self];
    }
    return hitView;
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect rect = self.bounds;
    BOOL isInside = CGRectContainsPoint(rect, point);
    if(!isInside)
    {
        for (UIView *view in self.subviews)
        {
            isInside = CGRectContainsPoint(view.frame, point);
            if(isInside)
                break;
        }
    }
    return isInside;
}

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Set the frame size to the appropriate values.
        CGRect  myFrame = self.frame;
        myFrame.size.width = 260.0f;
        myFrame.size.height = 134.0f;
        self.frame = myFrame;
        self.calloutOffset = CGPointMake(0, - 10);
        
        // The opaque property is YES by default. Setting it to
        // NO allows map content to show through any unrendered parts of your view.
        self.opaque = NO;
    }
    return self;
}

#pragma  marks - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    BQMapAnnotation *bqAnnotation = (BQMapAnnotation *)self.annotation;
    if ([[bqAnnotation burger] picture] != nil) {
        return [bqAnnotation numberOfBurgers];
    } else {
        return 0;
    }
}

#pragma marks - UICollectionViewDelegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BurgerGalleryCell *cell = (BurgerGalleryCell*) [imagesCollectionView dequeueReusableCellWithReuseIdentifier:@"burgerGalleryCellIdentifier" forIndexPath:indexPath];
    
    BQMapAnnotation *bqAnnotation = (BQMapAnnotation *)self.annotation;
    Burger *b = [bqAnnotation burger];
    if (bqAnnotation.burgers) {
        b = [[Burger alloc] initWithData:[bqAnnotation.burgers objectAtIndex:indexPath.row]];
    }
    [cell setDelegate:self];
    [cell configureGalleryCell:b];
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(85, 50);
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumInteritemSpacing:5.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    [flowLayout setItemSize:CGSizeMake(80, 50)];
    imagesCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, 64, 240, 50) collectionViewLayout:flowLayout];
    imagesCollectionView.backgroundColor = [UIColor whiteColor];
    imagesCollectionView.backgroundView.backgroundColor = [UIColor whiteColor];
    [self.imagesCollectionView registerClass:[BurgerGalleryCell class] forCellWithReuseIdentifier:@"burgerGalleryCellIdentifier"];
}

#pragma mark collection view cell paddings
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0); // top, left, bottom, right
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10; // This is the minimum inter item spacing, can be more
}

- (void)delegateForCell:(BurgerGalleryCell *)cell {
    BQMapAnnotation *bqAnnotation = (BQMapAnnotation *)self.annotation;
    
    Burger *b = bqAnnotation.burger;
    if ([bqAnnotation numberOfBurgers] > 1) {
        if([[[bqAnnotation burgers] objectAtIndex:[self.imagesCollectionView indexPathForCell:cell].row] class] != [Burger class])
            b = [[Burger alloc] initWithData:[[bqAnnotation burgers] objectAtIndex:[self.imagesCollectionView indexPathForCell:cell].row]];
        else
           b = [[bqAnnotation burgers] objectAtIndex:[self.imagesCollectionView indexPathForCell:cell].row];
    }
    
    b.place.numberOfBurgersInPlace = [NSNumber numberWithInt:[bqAnnotation numberOfBurgers]];
    BurgerDetailViewController *detailController = [[BurgerDetailViewController alloc] initWithBurger:b];
    BurgerQuestAppDelegate *del = (BurgerQuestAppDelegate *)[UIApplication sharedApplication].delegate;
    
    [del.burgerQuestNavController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [del.burgerQuestNavController.navigationBar setShadowImage:[UIImage new]];
    [del.burgerQuestNavController.navigationBar setTranslucent:YES];
    
    [del.burgerQuestNavController  pushViewController:detailController animated:YES];
    detailController = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
