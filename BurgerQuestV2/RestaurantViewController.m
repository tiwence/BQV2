//
//  RestaurantViewController.m
//  BurgerQuestV2
//
//  Created by Térence Marill on 26/03/2014.
//  Copyright (c) 2014 BurgerQuest. All rights reserved.
//

#import "RestaurantViewController.h"

@interface RestaurantViewController ()

@end

@implementation RestaurantViewController

@synthesize burgersTableView, navigationTitleView, distanceLabel, burgersNumberLabel, restaurantNameLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithBurgers:(NSMutableArray *)_burgers {
    self = [super initWithNibName:@"RestaurantViewController" bundle:nil];
    if (self) {
        burgers = _burgers;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavigationBack.png"]  style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
    
    [[FontUtils instance] customizeWithFonts:[NSArray arrayWithObjects:restaurantNameLabel, burgersNumberLabel, distanceLabel, nil]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Get API engine
    apiEngine = [[BurgerQuestAppDelegate sharedAppDelegate] apiEngine];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView = navigationTitleView;
    
    Burger *burger = [[Burger alloc] initWithData:[burgers objectAtIndex:0]];
    self.restaurantNameLabel.text = burger.place.name;
    self.distanceLabel.text = [burger.place getDistanceInMeter];
    if (burgers.count > 1) self.burgersNumberLabel.text = [NSString stringWithFormat:@"%lu burgers", (unsigned long)burgers.count];
    else self.burgersNumberLabel.text = [NSString stringWithFormat:@"%lu burger ", (unsigned long)burgers.count];
    
    if (burgers != nil && [burgers count] > 0) {
        Burger *burger = [[Burger alloc] initWithData:[burgers objectAtIndex:0]];
        self.navigationItem.title = burger.place.name;
    }
    
    self.burgersTableView.dataSource = self;
    self.burgersTableView.delegate = self;
    
    [burgersTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    self.burgersTableView = nil;
    self.navigationTitleView = nil;
    self.distanceLabel = nil;
    self.burgersNumberLabel = nil;
    self.restaurantNameLabel = nil;
}

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)performAction:(id)sender {
    
}

/*-(void)requestData {
    NSString *coords = [[NSString alloc] initWithFormat:@"%f,%f", userLocation.coordinate.latitude, userLocation.coordinate.longitude];
    NSTimeZone *localTime = [NSTimeZone systemTimeZone];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[localTime name] forKey:@"timezone"];
    [params setValue:coords forKey:@"geocode"];
    
    NSString *path = [NSString stringWithFormat:@"place/%@/burger", fqID];
    //[[GANTracker sharedTracker] trackPageview:path withError:nil];
    
    [BQNotif show];
    
    [apiEngine getPath:path
            withParams:params onCompletion:^(NSMutableDictionary *status, NSMutableDictionary *events, NSMutableArray *response) {
                
                burgers = response;
                
                [self dataProcessed];
                
            } onError:^(NSError *error) {
                
            }];
}

-(void)dataProcessed {
    [BQNotif showDoneWithStatus:nil];
    [burgersTableView reloadData];
}*/

#pragma marks UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (burgers != nil)
        return [burgers count];
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Burger *burger = [[Burger alloc] initWithData:[burgers objectAtIndex:indexPath.row]];
    
    static NSString *simpleTableIdentifier = @"BurgerRestaurantCell";
    
    BurgerRestaurantCell *cell = (BurgerRestaurantCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BurgerRestaurantCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        [cell configureCell:burger];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    Burger* burger = [[Burger alloc] initWithData:[burgers objectAtIndex:indexPath.row]];
    burger.place.numberOfBurgersInPlace = [NSNumber numberWithInt:[burgers count]];
    BurgerDetailViewController *detailController = [[BurgerDetailViewController alloc] initWithBurger:burger];
    [self.navigationController pushViewController:detailController animated:YES];
    detailController = nil;
}

@end
