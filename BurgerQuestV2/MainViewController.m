//
//  MainViewController.m
//  BurgerQuestV2
//
//  Created by Térence Marill on 24/02/2014.
//  Copyright (c) 2014 BurgerQuest. All rights reserved.
//

#import "MainViewController.h"

#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE

@interface MainViewController ()

@end

@implementation MainViewController

//@synthesize leftMenuSideController;
@synthesize apiEngine;
@synthesize mkMapView;
@synthesize burgersListMapTableView;
@synthesize searchView, searchHereButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    UIImage *navImage = [UIImage imageNamed:@"HeaderLogo@2x.png"];
    if ([UIScreen mainScreen].scale < 2.0) {
        navImage = [UIImage imageNamed:@"HeaderLogo.png"];
    }
    
    UIImageView *titleView = [[UIImageView alloc] initWithImage:navImage];
    self.navigationItem.titleView = titleView;
    titleView = nil;
    
    [[FontUtils instance] customizeWithFonts:[NSArray arrayWithObjects:searchHereButton, nil]];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor pxColorWithHexValue:@"503D2E"]];
    
    [self hideSearchView:YES];
    
    //Setting up left menu
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"LeftMenuIcon.png"]  style:UIBarButtonItemStyleBordered target:self action:@selector(presentLeftMenuViewController:)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.burgersListMapTableView = [[DBParalaxMapTableView alloc] initWithFrame:self.view.frame];
    self.burgersListMapTableView.delegate = self;
    self.burgersListMapTableView.dataSource = self;
    self.burgersListMapTableView.bqAnnotationDelegate = self;
    [self.view addSubview:burgersListMapTableView];
    
    self.mkMapView = burgersListMapTableView.mapView;
    self.mkMapView.delegate = self;
    [self.mkMapView setShowsUserLocation:YES];
    
    //Set click handler
    tapRec = [[UITapGestureRecognizer alloc]
              initWithTarget:self action:@selector(didTapMap:)];
    [mkMapView addGestureRecognizer:tapRec];
    
    //Get API engine
    apiEngine = [[BurgerQuestAppDelegate sharedAppDelegate] apiEngine];
    
    annotationIndex = 0;
    lastOffset = 0;
    
    //Getting user location
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    [locationManager requestAlwaysAuthorization];
    
    //[locationManager startUpdatingLocation];
    
    memoryAnnotations = [[NSMutableDictionary alloc] init];
    
    /*if (opened) {
        NSArray *selectedAnnotations = self.mkMapView.selectedAnnotations;
        for(id annotation in selectedAnnotations) {
            [self.mkMapView deselectAnnotation:annotation animated:NO];
        }
        
        tapRec = [[UITapGestureRecognizer alloc]
                  initWithTarget:self action:@selector(didTapMap:)];
        [mkMapView addGestureRecognizer:tapRec];
    } else {
        if (tapRec != nil) {
            [mkMapView removeGestureRecognizer:tapRec];
            tapRec = nil;
        }
    }*/
    
    isFirstLoad = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    self.burgersListMapTableView = nil;
    self.searchView = nil;
    self.searchHereButton = nil;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorized) {
        [locationManager startUpdatingLocation];
    }
}

- (void)didTapMap:(id)sender {
    /*if ([pullUpView opened]) {
        [pullUpView setOpened:NO animated:YES];
    }*/
    
    // scroll to row!
    if ([self.burgersListMapTableView isOpened] && [topList count] > 0) {
        CGPoint offset = self.burgersListMapTableView.tableView.contentOffset;
        offset.y = 0;
        self.burgersListMapTableView.tableView.contentOffset = offset;
        /*[self.burgersListMapTableView.tableView scrollToRowAtIndexPath: // use the method
         [NSIndexPath indexPathForRow:0     // get 2nd row (nth row...)
                            inSection:0]    // in 1st section (...)
         // set position: you can use bottom, middle or top.
                                                      atScrollPosition:UITableViewScrollPositionBottom
                                                              animated:YES];*/
    }
}

#pragma mark - Location Manager Interactions

- (void)pullableView:(PullableView *)pView didChangeState:(BOOL)opened {
    if (opened) {
        NSArray *selectedAnnotations = self.mkMapView.selectedAnnotations;
        for(id annotation in selectedAnnotations) {
            [self.mkMapView deselectAnnotation:annotation animated:NO];
        }
        
        tapRec = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(didTapMap:)];
        [mkMapView addGestureRecognizer:tapRec];
    } else {
        if (tapRec != nil) {
            [mkMapView removeGestureRecognizer:tapRec];
            tapRec = nil;
        }
    }
}

#pragma mark - Location Manager Interactions

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    if (userLocation.coordinate.longitude != newLocation.coordinate.longitude
        || userLocation.coordinate.latitude != newLocation.coordinate.latitude) {
        
        userLocation = newLocation;
        
        // Center map on user location
        MKCoordinateSpan span;
        span.latitudeDelta = 0.01;
        span.longitudeDelta = 0.01;
        //region.span = span;
        
        MKCoordinateRegion region;
        region.span = span;
        region.center = userLocation.coordinate;
        region.span = span;
        region.center = userLocation.coordinate;
        
        [mkMapView setRegion:region animated:YES];
        
        [locationManager stopUpdatingLocation];
        
        if (userPositionCircle != nil)
            [mkMapView removeOverlay:userPositionCircle];
        else
            userPositionCircle = nil;
        
        NSLog(@"User location %f, %f", userLocation.coordinate.latitude, userLocation.coordinate.longitude);
        
        CLLocationCoordinate2D coord = userLocation.coordinate;
        coord.latitude = coord.latitude + (0.560 / 6378) * (180/3.14);
        
        if (distanceAnnotation != nil) {
            [mkMapView removeAnnotation:distanceAnnotation];
            distanceAnnotation = nil;
        }
        
        distanceAnnotation = [[BQDistanceAnnotation alloc] initWithLocation:coord];
        
        [mkMapView addAnnotation:distanceAnnotation];
        
        userPositionCircle = [MKCircle circleWithCenterCoordinate:userLocation.coordinate radius:500];
        [mkMapView addOverlay:userPositionCircle];
        
        mapChangeTimer = [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(requestMapData) userInfo:nil repeats:NO];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location manager error %@", error);
}

- (IBAction)performNewSearch:(id)sender {
    isNewSearch = YES;
    [self requestMapData];
}

- (IBAction)performRelocation:(id)sender {
    [locationManager startUpdatingLocation];
}

-(void)requestLastBurger {
    [mkMapView removeAnnotations:annotations];
    
    // Params
    NSString *coords = [[NSString alloc] initWithFormat:@"%f,%f", userLocation.coordinate.latitude, userLocation.coordinate.longitude];
    NSTimeZone *localTime = [NSTimeZone systemTimeZone];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:coords forKey:@"geocode"];
    [params setObject:[localTime name] forKey:@"timezone"];
    [params setObject:@"10" forKey:@"limit"];
    [params setObject:[NSString stringWithFormat:@"%i", lastOffset] forKey:@"offset"];
    
    // Requête
    [apiEngine getPath:@"burger/last"
            withParams:params onCompletion:^(NSMutableDictionary *status, NSMutableDictionary *events, NSMutableArray *response) {
                
                // Si il y'a déjà des burger, on les ajoutes
                /*if ([lastList count] > 0 && lastOffset > 0) {
                    [lastList addObjectsFromArray:response];
                }
                else {
                    lastList = response;
                }*/
                
                //lastLoaded = YES;
                topList = [[NSMutableArray alloc] init];
                //[BQNotif showDoneWithStatus:nil];
                [self burgerDataProcessed:response];
                
            } onError:^(NSError *error) {
                //[self performSelector:@selector(doneLoadingTableViewData) withObject:self afterDelay:1.2];
                //loading = NO;
            }];
}

-(void)requestTop10Burger {
    [mkMapView removeAnnotations:annotations];
    
    CLLocationCoordinate2D newCoord = [self.mkMapView centerCoordinate];
    
    //NSString *coords = [[NSString alloc] initWithFormat:@"%f,%f", userLocation.coordinate.latitude, userLocation.coordinate.longitude];
    
    NSString *coords = [[NSString alloc] initWithFormat:@"%f,%f", newCoord.latitude, newCoord.longitude];
    
    //NSString *coords = [[NSString alloc] initWithFormat:@"%f,%f", userLocation.coordinate.latitude, userLocation.coordinate.longitude];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:coords forKey:@"geocode"];
    NSTimeZone *localTime = [NSTimeZone systemTimeZone];
    [params setObject:[localTime name] forKey:@"timezone"];
    
    [apiEngine getPath:@"burger/top"
            withParams:params onCompletion:^(NSMutableDictionary *status, NSMutableDictionary *events, NSMutableArray *response) {
                
                // On ramène l'utilisateur en haut de la tableView
                //[table setContentOffset:CGPointMake(0, 0) animated:YES];
                
                //top10Loaded = YES;
                topList = [[NSMutableArray alloc] init];
                //[BQNotif showDoneWithStatus:nil];
                [self burgerDataProcessed:response];
            } onError:^(NSError *error) {
                //[self performSelector:@selector(doneLoadingTableViewData) withObject:self afterDelay:1.2];
                //loading = NO;
            }];
}

- (void)requestMapData {
    
    [self hideSearchView:YES];
    
    [mkMapView removeAnnotations:annotations];
    loadingImageView.hidden = NO;

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    // Récupère le radius
    MKCircle *circle = [MKCircle circleWithMapRect:self.mkMapView.visibleMapRect];
    [params setObject:[NSString stringWithFormat:@"%f", circle.radius] forKey:@"radius"];
    
    // Request places around user
    //CLLocationCoordinate2D newCoord = [self.mkMapView centerCoordinate];
    
    NSString *coords = [[NSString alloc] initWithFormat:@"%f,%f", userLocation.coordinate.latitude, userLocation.coordinate.longitude];
    
    //NSString *coords = [[NSString alloc] initWithFormat:@"%f,%f", newCoord.latitude, newCoord.longitude];
    NSLog(@"New coordinate : %@", coords);
    [params setValue:coords forKey:@"geocode"];
    
    NSTimeZone *localTime = [NSTimeZone systemTimeZone];
    [params setObject:[localTime name] forKey:@"timezone"];
    
    //[BQNotif show];
    
    if (placesDict == nil)
        placesDict = [[NSMutableDictionary alloc] init];
    
    [apiEngine getPath:@"place"
            withParams:params onCompletion:^(NSMutableDictionary *status, NSMutableDictionary *events, NSMutableArray *response) {
                
                [self hideSearchView:YES];
                
                // Reset la liste des burgers
                topList = [[NSMutableArray alloc] init];
                
                //listLoaded = YES;
                loadingImageView.hidden = YES;
                [self dataProcessed:response];
            } onError:^(NSError *error) {
                [self hideSearchView:NO];
                isNewSearch = NO;
                NSLog(@"Map data error %@", error);
            }];
}

- (void)burgerDataProcessed:(NSMutableArray *) response {
    annotations = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *item in response) {
        Burger *burger = [[Burger alloc] initWithData:item];
        if (burger) {
            [topList addObject:burger];
            BQMapAnnotation *annotation = [[BQMapAnnotation alloc] initWithLocation:burger.place.geocode];
            annotation.burger = burger;
            annotation.numberOfBurgers = 1;
            //annotation.subtitle = burger.place.name;
            annotation.title = burger.name;
            
            [annotations addObject:annotation];
            
            [annotationsToAdd setObject:annotation forKey:burger.place.placeID];
            [memoryAnnotations setObject:annotation forKey:burger.place.placeID];
            
            annotationIndex++;
        }
    }
    
    // If no annotations yet
    if ([[self.mkMapView annotations] count] <= 1) {
        [self.mkMapView addAnnotations:annotations];
        [self.mkMapView showAnnotations:annotations animated:YES];
    } else {
        for (BQMapAnnotation *annotation in annotations) {
            [mkMapView addAnnotation:annotation];
        }
        // Empty array
        annotationsToAdd = [[NSMutableDictionary alloc] init];
    }
    
    //[BQNotif showDoneWithStatus:nil];
    [self.burgersListMapTableView.tableView reloadData];
}

- (void)dataProcessed:(NSMutableArray *)response {
    // Remove current annotations
    
    annotations = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *item in response) {
        Place *place = [[Place alloc] initWithData:item];
        // If it's a new item
        //if ([memoryAnnotations objectForKey:place.placeID] == nil) {
            
            NSMutableArray *burgers = [item objectForKey:@"burger"];
            
            BQMapAnnotation *annotation = [[BQMapAnnotation alloc] initWithLocation:place.geocode];
            [annotation setNumber:annotationIndex];
            
            if (burgers) {
                [topList addObjectsFromArray:burgers];
                
                if (![placesDict objectForKey:place.fqID]) {
                    [placesDict setObject:[NSNumber numberWithInt:[burgers count]] forKey:place.fqID];
                }
                
                if ([burgers count] > 1) {
                    annotation.burger = [[Burger alloc] initWithData:[burgers objectAtIndex:0]];
                    annotation.burgers = [[NSMutableArray alloc] initWithArray:burgers];
                    annotation.numberOfBurgers = [burgers count];
                    annotation.fqID = place.fqID;
                    annotation.subtitle = [NSString stringWithFormat:@"%i burgers", [burgers count]];
                } else if ([burgers count] == 1) {
                    annotation.burger = [[Burger alloc] initWithData:[burgers objectAtIndex:0]];
                    annotation.numberOfBurgers = 1;
                    annotation.subtitle = @"1 burger";
                } else {
                    annotation.fqID = place.fqID;
                    annotation.numberOfBurgers = 0;
                    annotation.subtitle = @"No burger";
                }
            }
            
            annotation.title = place.name;
            [annotations addObject:annotation];
            
            [annotationsToAdd setObject:annotation forKey:place.placeID];
            [memoryAnnotations setObject:annotation forKey:place.placeID];
            
            annotationIndex++;
        //}
    }
    
    // If no annotations yet
    if ([[self.mkMapView annotations] count] <= 1) {
        [self.mkMapView addAnnotations:annotations];
        [self.mkMapView showAnnotations:annotations animated:YES];
    } else {
        for (BQMapAnnotation *annotation in annotations) {
            [mkMapView addAnnotation:annotation];
        }
        // Empty array
        annotationsToAdd = [[NSMutableDictionary alloc] init];
    }

    //[BQNotif showDoneWithStatus:nil];
    
    [burgersListMapTableView.tableView reloadData];
    self.burgersListMapTableView.hidden = NO;

    // Tell that de map has been update for first time
    //firstLoad = NO;
}

#pragma mark - Map region change
- (void)mapView:(MKMapView *)aMapView regionDidChangeAnimated:(BOOL)animated
{
    userLocation = [[CLLocation alloc] initWithLatitude:aMapView.region.center.latitude longitude:aMapView.region.center.longitude];
}

-(void)mapView:(MKMapView *)aMapView regionWillChangeAnimated:(BOOL)animated {
    /*userLocation = [[CLLocation alloc] initWithLatitude:aMapView.region.center.latitude longitude:aMapView.region.center.longitude];
    
    if (isFirstLoad) {
        isFirstLoad = NO;
        [self hideSearchView:YES];
    } else if (isNewSearch) {
        if(![self.burgersListMapTableView isOpened]) {
            [self hideSearchView:YES];
            isNewSearch = NO;
        }
    } else {
        if(![self.burgersListMapTableView isOpened])
            [self hideSearchView:NO];
        else
            [self hideSearchView:YES];
    }*/
 
    [self hideSearchView:NO];
    
    if (isFirstLoad) {
        isFirstLoad = NO;
    } else if (isNewSearch) {
        if(![self.burgersListMapTableView isOpened]) {
            isNewSearch = NO;
            [self hideSearchView:NO];
        }
    } else {
        if(![self.burgersListMapTableView isOpened]) {
            [self hideSearchView:NO];
        } else {
            [self hideSearchView:YES];
        }
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    MKMapRect r = [mapView visibleMapRect];
    MKMapPoint pt = MKMapPointForCoordinate([view.annotation coordinate]);
    r.origin.x = pt.x - r.size.width * 0.5;
    r.origin.y = pt.y - r.size.height * 0.5;
    [mapView setVisibleMapRect:r animated:YES];
}

// Design user circle distance
- (MKOverlayView *)mapView:(MKMapView *)map viewForOverlay:(id <MKOverlay>)overlay {
    MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
    circleView.strokeColor = [UIColor pxColorWithHexValue:@"07A8AA"];
    circleView.fillColor = [[UIColor pxColorWithHexValue:@"FFFFFF"] colorWithAlphaComponent:0.0];
    circleView.lineWidth = 3.0;
    
    return circleView;
}

// Design bulletpoints
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id)annotation {
    if (![annotation isKindOfClass:[MKUserLocation class]]) {
        
        static NSString *annotationIdentifier = @"annotationIdentifier";
        
        if ([annotation isKindOfClass:[BQDistanceAnnotation class]]) {
            MKAnnotationView *distanceView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
            
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(-50, 0, 100, 30)];
            lbl.backgroundColor = [UIColor clearColor];
            lbl.textColor = [UIColor pxColorWithHexValue:@"07A8AA"];
            lbl.alpha = 1.0;
            [lbl setFont:[UIFont italicSystemFontOfSize:18.0f]];
            lbl.textAlignment = NSTextAlignmentCenter;
            lbl.text = @"5 min";
            [[FontUtils instance] customizeWithFonts:[NSMutableArray arrayWithObjects:lbl, nil]];
            [distanceView addSubview:lbl];
            lbl = nil;
            
            return distanceView;
        }
        
        if (objectList == nil)
            objectList = [[NSMutableDictionary alloc] init];
        
        MKAnnotationView *pinView = (BQAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        
        //If PinView doesn't exist
        //if (pinView == nil) {
            pinView = [[BQAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
            float annotationRating = 0.0;
            if ([annotation numberOfBurgers] > 1) {
                for (NSObject *data in [annotation burgers]) {
                    Burger * b = [[Burger alloc] initWithData:data];
                    float rating = [b.rating floatValue] * 2.0;
                    annotationRating += rating;
                }
                annotationRating = annotationRating / [annotation numberOfBurgers];
            } else {
                annotationRating = [[annotation burger].rating floatValue] * 2.0;
            }
            
            if (annotationRating >= 8.5) {
                if ([UIScreen mainScreen].scale < 2.0)
                    [pinView setImage:[UIImage imageNamed:@"RedPin.png"]];
                else
                    [pinView setImage:[UIImage imageNamed:@"RedPin@2x.png"]];
            } else if (annotationRating >= 7.0 && annotationRating < 8.5) {
                if ([UIScreen mainScreen].scale < 2.0)
                    [pinView setImage:[UIImage imageNamed:@"OrangePin.png"]];
                else
                    [pinView setImage:[UIImage imageNamed:@"OrangePin@2x.png"]];
            } else {
                if ([UIScreen mainScreen].scale < 2.0)
                    [pinView setImage:[UIImage imageNamed:@"YellowPin.png"]];
                else
                    [pinView setImage:[UIImage imageNamed:@"YellowPin@2x.png"]];
            }
            
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, -2, pinView.frame.size.width, 30)];
            lbl.backgroundColor = [UIColor clearColor];
            lbl.textColor = [UIColor whiteColor];
            lbl.alpha = 1.0;
            [lbl setFont:[UIFont italicSystemFontOfSize:18.0f]];
            lbl.tag = annotationRating;
            lbl.textAlignment = NSTextAlignmentCenter;
            lbl.text = [NSString stringWithFormat:@"%.1f", annotationRating];
            [[FontUtils instance] customizeWithFonts:[NSMutableArray arrayWithObjects:lbl, nil]];
            [pinView addSubview:lbl];
            lbl = nil;
        //}
            
        [pinView setUserInteractionEnabled:YES];
        [pinView setCanShowCallout:NO];
        
        return pinView;
    } else {
        return nil;
    }
}

- (void)showPlaceBurgers:(id)sender {
    NSMutableArray* burgers = [objectList objectForKey:[NSString stringWithFormat:@"%li", (long)[sender tag]]];
    RestaurantViewController *restaurantController = [[RestaurantViewController alloc] initWithBurgers:burgers];
    [self.navigationController pushViewController:restaurantController animated:YES];
    restaurantController = nil;
}

- (void)showBurgerDetails:(id)sender {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    Burger* burger = [objectList objectForKey:[NSString stringWithFormat:@"%li", (long)[sender tag]]];
    burger.place.numberOfBurgersInPlace = [placesDict objectForKey:burger.place.fqID];
    BurgerDetailViewController *detailController = [[BurgerDetailViewController alloc] initWithBurger:burger];
    [self.navigationController pushViewController:detailController animated:YES];
    detailController = nil;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Burger *burger = [[Burger alloc] initWithData:[topList objectAtIndex:indexPath.row]];
    burger.place.numberOfBurgersInPlace = [placesDict objectForKey:burger.place.fqID];
    
    static NSString *simpleTableIdentifier = @"BurgerCell";
    
    BurgerCell *cell = (BurgerCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BurgerCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        [cell configureCell:burger];
        
        if ([burgersListMapTableView scrollingUp]) {
            dispatch_async(dispatch_get_main_queue(), ^{
            
                CALayer *layer = cell.layer;
                CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
                //rotationAndPerspectiveTransform.m34 = 1.0 / -500;
                
                rotationAndPerspectiveTransform = CATransform3DMakeTranslation(0, layer.bounds.size.height + layer.bounds.size.height, 0.0f);
                //rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, 45.0f * M_PI / 180.0f, 1.0f, 0.0f, 0.0f);
                layer.transform = rotationAndPerspectiveTransform;
                
                //CALayer *layer = cell.layer;
                //layer.transform = CATransform3DMakeRotation(M_PI / 6, 0.0f, 1.0f, 0.0f);
                //layer.transform = CATransform3DMakeTranslation(0, layer.bounds.size.height + layer.bounds.size.height / 4, 0.0f);
                
                NSTimeInterval animationDuration = 0.6;
                // The block-based equivalent doesn't play well with iOS 4
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:animationDuration];
                cell.layer.transform = CATransform3DIdentity;
                cell.layer.opacity = 1.0f;
                [UIView commitAnimations];
            });
        }
    }
    
    return cell;
}

- (void)hideSearchView:(BOOL)toHide {
    NSLog(@"Search view to hide ? %i", toHide);
    
    if (toHide) {
        [self.searchView removeFromSuperview];
    } else {
        CGRect searchFrame = self.searchView.frame;
        searchFrame.origin.x = 47;
        if (isiPhone5) searchFrame.origin.y = 400;
        else searchFrame.origin.y = 300;
        searchView.frame = searchFrame;
        [self.view addSubview:searchView];
    }
}

- (void)updateAnnotationMap {
    NSArray *indexPaths = [self.burgersListMapTableView.tableView indexPathsForVisibleRows];
    if (indexPaths.count > 0) {
        for (NSIndexPath *indexP in indexPaths) {
            CGRect cellRect = [burgersListMapTableView.tableView rectForRowAtIndexPath:indexP];
            cellRect = [burgersListMapTableView.tableView convertRect:cellRect toView:burgersListMapTableView.tableView.superview];
            BOOL completelyVisible = NO;
            if (cellRect.origin.y > 150 && cellRect.origin.y < 410)
                completelyVisible = YES;
            // = CGRectContainsRect(burgersListMapTableView.tableView.frame, cellRect);
            if (completelyVisible) {
                Burger *burger = [[Burger alloc] initWithData:[topList objectAtIndex:indexP.row]];
                [self showAnnotionAccordingToList:burger];
            }
        }
    }
}

- (void) showAnnotionAccordingToList:(Burger *) burger {
    BQMapAnnotation *annotationToShow  = [memoryAnnotations objectForKey:burger.place.placeID];
    if (annotationToShow != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MKMapPoint annotationPoint = MKMapPointForCoordinate(annotationToShow.coordinate);
            MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y + 560, 0.1, 0.1);
            [mkMapView setVisibleMapRect:pointRect animated:YES];
        });
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.title;
}

- (void)setNavBarToTranslucent {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTranslucent:YES];
}

#pragma mark - Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (topList != nil)
        return topList.count;
    else
        return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setNavBarToTranslucent];
    Burger* burger = [[Burger alloc] initWithData:[topList objectAtIndex:indexPath.row]];
    burger.place.numberOfBurgersInPlace = [placesDict objectForKey:burger.place.fqID];
    BurgerDetailViewController *detailController = [[BurgerDetailViewController alloc] initWithBurger:burger];
    [self.navigationController pushViewController:detailController animated:YES];
    detailController = nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 260.0f;
}

#pragma mark SideBar delegate

- (void)sideBarViewController:(LeftMenuViewController *)sideBarViewController performAction:(NSString *)actionName {
    [[BurgerQuestAppDelegate sharedAppDelegate].sideMenuViewController hideMenuViewController];
    if ([actionName isEqualToString:@"Top 10"]) {
        [self requestTop10Burger];
    } else if ([actionName isEqualToString:@"Last"]) {
        [self requestLastBurger];
    } else if ([actionName isEqualToString:@"Home"]) {
        [self requestMapData];
    } else {
        [self setNavBarToTranslucent];
        if ([actionName isEqualToString:@"Signin"]) {
            LoginViewController *signInController = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:signInController animated:YES];
            signInController = nil;
        } else if ([actionName isEqualToString:@"Register"]) {
            SignUpViewController *signUpController = [[SignUpViewController alloc] init];
            [self.navigationController pushViewController:signUpController animated:YES];
            signUpController = nil;
        } else if ([actionName isEqualToString:@"Logout"]) {
            BQSession *session = [BQSession sharedSession];
            [session purgeUser];
            [[BurgerQuestAppDelegate sharedAppDelegate] displayAuthentViewController];
        }
    }
}

@end
