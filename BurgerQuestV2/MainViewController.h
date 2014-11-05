//
//  MainViewController.h
//  BurgerQuestV2
//
//  Created by Térence Marill on 24/02/2014.
//  Copyright (c) 2014 BurgerQuest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "JTRevealSidebarV2Delegate.h"
#import "UIViewController+JTRevealSidebarV2.h"
#import "UINavigationItem+JTRevealSidebarV2.h"
#import "LeftMenuViewController.h"
#import "BQAPIEngine.h"
#import "Place.h"
#import "BurgerDetailViewController.h"
#import "BQMapAnnotation.h"
#import "StyledPullableView.h"
#import "BurgerQuestAppDelegate.h"
#import "BurgerCell.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "RestaurantViewController.h"
#import "UIColor+UIColor_PXExtentions.h"
#import "CalloutMapAnnotationView.h"
#import "BQAnnotationView.h"
#import "DBParalaxMapTableView.h"
#import "BQDistanceAnnotation.h"

@interface MainViewController : UIViewController <DBParalaxTableViewDataSource, DBParalaxTableViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate, PullableViewDelegate, SidebarViewControllerDelegate, BQAnnotationAndTableViewDelegate> {
    
    CLLocationManager *locationManager;
    CLLocation *userLocation;
    BQAPIEngine *apiEngine;
    BQDistanceAnnotation *distanceAnnotation;
    NSMutableArray *topList;
    NSMutableArray *annotations;
    NSMutableDictionary *memoryAnnotations;
    NSMutableDictionary *annotationsToAdd;
    NSMutableDictionary *objectList;
    NSMutableDictionary *placesDict;
    int annotationIndex;
    NSTimer *mapChangeTimer;
    UIImageView *loadingImageView;
    UITapGestureRecognizer* tapRec;
    bool isFirstLoad;
    int lastOffset;
    bool isNewSearch;
    MKCircle *userPositionCircle;
}

@property (nonatomic, retain) BQAPIEngine *apiEngine;
@property (nonatomic, strong) LeftMenuViewController *leftMenuSideController;

@property (nonatomic, strong) DBParalaxMapTableView *burgersListMapTableView;
@property (nonatomic, retain) MKMapView *mkMapView;

@property (nonatomic, strong) IBOutlet UIView *searchView;
@property (nonatomic, retain) IBOutlet UIButton *searchHereButton;

- (void)requestMapData;
- (void)requestTop10Burger;
- (void)didTapMap:(id)sender;
- (void)showBurgerDetails:(id)sender;
- (void)showPlaceBurgers:(id)sender;
- (IBAction)performNewSearch:(id)sender;
- (IBAction)performRelocation:(id)sender;
- (void)dataProcessed:(NSMutableArray *)response;

@end
