//
//  BurgerDetailViewController.m
//  BurgerQuestV2
//
//  Created by Térence Marill on 20/03/2014.
//  Copyright (c) 2014 BurgerQuest. All rights reserved.
//

#import "BurgerDetailViewController.h"

@interface BurgerDetailViewController ()

@end

@implementation BurgerDetailViewController

@synthesize burgerNameLabel, addressLabel, restaurantNameLabel, ratingsInfosLabel,  ratingLabel, addCommentTextField, navigationTitleView, imagesCollectionView, userPic, scrollView, infosView, pictoAddress, burgerPicsPageControl, hateButton, likeButton, loveButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithBurger:(Burger*)_burger {
    
    self = [super initWithNibName:@"BurgerDetailViewController" bundle:nil];
    if (self) {
        burger = _burger;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NavigationBack.png"]  style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
    
    [[FontUtils instance] customizeWithFonts:[NSArray arrayWithObjects:restaurantNameLabel, burgerNameLabel, ratingLabel, ratingsInfosLabel, nil]];
    
    hateButton.imageView.image = [UIImage imageNamed:@"IhateButtonOff.png"];
    likeButton.imageView.image = [UIImage imageNamed:@"IlikeButtonOff.png"];
    loveButton.imageView.image = [UIImage imageNamed:@"IloveButtonOff.png"];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    bgLayer = [BackgroundLayer greyGradient];
    CGRect bgFrame = self.navigationController.navigationBar.frame;
    bgFrame.origin.x = 0;
    bgFrame.origin.y = -20;
    bgFrame.size.height = bgFrame.size.height + 20;
    bgLayer.frame = bgFrame;
    [self.navigationController.navigationBar.layer insertSublayer:bgLayer atIndex:0];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButtonItem;
    
    //Set navigation bar button
    UIBarButtonItem *shareBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"PictoShare.png"] style:UIBarButtonItemStylePlain target:self action:@selector(performOldSharing:)];
    self.navigationItem.rightBarButtonItem = shareBarButton;
    shareBarButton = nil;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                             forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView = navigationTitleView;
    
    //Get API engine
    apiEngine = [[BurgerQuestAppDelegate sharedAppDelegate] apiEngine];
    
    [self setupCollectionView];
    self.imagesCollectionView.dataSource = self;
    self.imagesCollectionView.delegate = self;

    self.scrollView.delegate = self;
    [self.scrollView addParallaxWithView:self.imagesCollectionView andHeight:220.0f];
    
    commentsList = [[NSMutableArray alloc] init];
    [self displayBurgerInfos];
    
    [self.imagesCollectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    self.userPic = nil;
    self.burgerNameLabel = nil;
    self.restaurantNameLabel = nil;
    self.ratingsInfosLabel = nil;
    self.ratingLabel = nil;
    self.scrollView = nil;
    self.imagesCollectionView = nil;
    self.addCommentTextField = nil;
    self.navigationTitleView = nil;
    self.infosView = nil;
    self.burgerPicsPageControl = nil;
}

- (void)back:(id) sender {
    [bgLayer removeFromSuperlayer];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor pxColorWithHexValue:@"503D2E"]];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)displayBurgerInfos {
    self.burgerNameLabel.text = burger.name;
    self.restaurantNameLabel.text = burger.place.name;
    
    float rating = [burger.rating floatValue] * 2.0;
    
    self.ratingLabel.text = [NSString stringWithFormat:@"%.1f", rating];
    self.ratingsInfosLabel.text = [NSString stringWithFormat:@"%@", burger.count_rating];
    
    //address
    addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 29, 194, 16)];
    addressLabel.font = [UIFont fontWithName:@"DINReg" size:12.0f];
    addressLabel.textColor = [UIColor whiteColor];
    addressLabel.textAlignment = NSTextAlignmentCenter;
    self.addressLabel.text = [NSString stringWithFormat:@"%@", burger.place.address];
    CGSize stringSize = [burger.place.address sizeWithFont:addressLabel.font];
    CGRect addressFrame = addressLabel.frame;
    addressFrame.size = stringSize;
    addressFrame.origin.x = (navigationTitleView.frame.size.width / 2) - (addressFrame.size.width / 2) + pictoAddress.frame.size.width + 10;
    addressLabel.frame = addressFrame;
    [navigationTitleView addSubview:addressLabel];
    
    //picto address
    pictoAddress = [[UIImageView alloc] initWithFrame:CGRectMake(7, 32, 8, 10)];
    pictoAddress.image = [UIImage imageNamed:@"PictoPointer.png"];
    CGRect pictoAddressFrame =  pictoAddress.frame;
    pictoAddressFrame.origin.x = addressFrame.origin.x - pictoAddressFrame.size.width - 5.0f;
    pictoAddress.frame = pictoAddressFrame;
    [navigationTitleView addSubview:pictoAddress];
    
    addressLabel = nil;
    pictoAddress = nil;
    
    //Discover username
    NSString *userN = @"";
    if (burger.user.firstname.length > 0) userN = burger.user.firstname;
    else if (burger.user.tw_uid.length > 0) userN = burger.user.tw_uid;
    else userN = burger.user.username;
    
    MDHTMLLabel *userInfoLabel = [[MDHTMLLabel alloc] initWithFrame:CGRectMake(69, 34, 166, 32)];
    userInfoLabel.htmlText = [NSString stringWithFormat:@"<font face='DINReg' size='12' color='#30b4b6'>Discover by </font><font face='DINBol' size='12' color='#30b4b6'>%@</font><font face='DINReg' size='12' color='#b0b0b0'>, %@</font>", userN, [[burger.date timeAgo] lowercaseString]];
    userInfoLabel.font = [UIFont fontWithName:@"DINReg" size:12];
    userInfoLabel.numberOfLines = 2;
    [infosView addSubview:userInfoLabel];
    userInfoLabel = nil;
    
    // User picture
    CALayer *l = userPic.layer;
    [l setMasksToBounds:YES];
    [l setCornerRadius:18.0f];
    
    NSString *imagePath;
    if ([UIScreen mainScreen].scale == 2.0) imagePath =  [burger.user thumbnail_2x];
    else imagePath =  [burger.user thumbnail];
    
    if (imagePath.length > 0) {
        NSURL *avatarUrl = [NSURL URLWithString:imagePath];
        userPic.clipsToBounds = YES;
        [userPic setImageWithURL:avatarUrl placeholderImage:[UIImage imageNamed:@"AvatarNoSignIn.png"]];
    }
    
    // Add a bottomBorder to the header view
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, infosView.frame.size.height - 2.0f, infosView.frame.size.width, 2.0f);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                     alpha:1.0f].CGColor;
    [infosView.layer addSublayer:bottomBorder];
    
    [self requestData];
}

- (IBAction)performCamera:(id)sender {
    
}

- (IBAction)performMediaFiles:(id)sender {
    
}

- (IBAction)performRating:(id)sender {
    if ([[BQSession sharedSession] currentUser] != nil) {
        UIButton *senderButton = (UIButton *)sender;
        int rating = 5;
        if ([senderButton.titleLabel.text isEqualToString:@"Hate"]) {
            rating = 1;
            [hateButton setImage:[UIImage imageNamed:@"IhateButtonOn.png"] forState:UIControlStateNormal];
            [likeButton setImage:[UIImage imageNamed:@"IlikeButtonOff.png"] forState:UIControlStateNormal];
            [loveButton setImage:[UIImage imageNamed:@"IloveButtonOff.png"] forState:UIControlStateNormal];
        } else if ([senderButton.titleLabel.text isEqualToString:@"Like"]) {
            rating = 3;
            [hateButton setImage:[UIImage imageNamed:@"IhateButtonOff.png"] forState:UIControlStateNormal];
            [likeButton setImage:[UIImage imageNamed:@"IlikeButtonOn.png"] forState:UIControlStateNormal];
            [loveButton setImage:[UIImage imageNamed:@"IloveButtonOff.png"] forState:UIControlStateNormal];
            
        } else {
            [hateButton setImage:[UIImage imageNamed:@"IhateButtonOff.png"] forState:UIControlStateNormal];
            [likeButton setImage:[UIImage imageNamed:@"IlikeButtonOff.png"] forState:UIControlStateNormal];
            [loveButton setImage:[UIImage imageNamed:@"IloveButtonOn.png"] forState:UIControlStateNormal];
        }
        
        NSMutableDictionary *ratingParams = [[NSMutableDictionary alloc] init];
        [ratingParams setObject:[NSString stringWithFormat:@"%i", rating] forKey:@"note"];
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setValue:[ratingParams JSONString] forKey:@"rating"];
        
        NSString *path = [NSString stringWithFormat:@"burger/%@/rating", burger.burgerID];
        
        [apiEngine postPath:path
                 withParams:params onCompletion:^(NSMutableDictionary *status, NSMutableDictionary *events, NSMutableDictionary *response) {
                     
                     //Perform share actions
                     //[self performShare];
                     
                     [BQNotif showSuccessWithStatus:nil];
                     [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(requestData) userInfo:nil repeats:NO];
                     
                 } onError:^(NSError *error) {
                     if (error == nil) {
                         //Error from API
                         if (senderButton == hateButton)
                             [hateButton setImage:[UIImage imageNamed:@"IhateButtonOff.png"] forState:UIControlStateNormal];
                         else if (senderButton == likeButton)
                             [likeButton setImage:[UIImage imageNamed:@"IlikeButtonOff.png"] forState:UIControlStateNormal];
                         else if (senderButton == loveButton)
                             [loveButton setImage:[UIImage imageNamed:@"IloveButtonOff.png"] forState:UIControlStateNormal];
                     } else {
                         [BQNotif showErrorWithStatus:@"A problem occured. Retry."];
                     }
                 }];
    } else {
        [NSTimer scheduledTimerWithTimeInterval:1.2f target:self selector:@selector(performAuthent:) userInfo:nil repeats:NO];
    }
    
}

- (void)performAuthent:(id)sender {
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginViewController animated:YES];
    loginViewController = nil;
}

- (void)performAddRating:(id)sender {
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *sharingName = [NSString stringWithFormat:@"Check %@ by %@. The quest continues on @burgerquestApp", burger.name, burger.place.name];
    NSString *sharingCaption = @"www.burgerquestapp.com";
    NSString *sharingDescription = @"BurgerQuest is an iPhone application to help you find and share the most delicious burgers in the world";
    NSString *imagePath = @"";
     if ([[burger picture] count] >= 1) {
         imagePath = [[[burger picture] objectAtIndex:0] single_2x];
     }
    
    if (buttonIndex == 0) {
        FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
        params.name = sharingName;
        params.link = [NSURL URLWithString:burger.url];
        params.picture = [NSURL URLWithString:imagePath];
        params.caption = sharingCaption;
        params.linkDescription = sharingDescription;
        
        // If the Facebook app is installed and we can present the share dialog
        if ([FBDialogs canPresentShareDialogWithParams:params]) {
            // Present the share dialog
            [FBDialogs presentShareDialogWithParams:params clientState:nil handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                if(error) {
                    // An error occurred, we need to handle the error
                    // See: https://developers.facebook.com/docs/ios/errors
                    NSLog(@"Error publishing story: %@", error.description);
                } else {
                    // Success
                    NSLog(@"result %@", results);
                }
            }];
    
        } else {
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           sharingName, @"name",
                                           sharingCaption, @"caption",
                                           sharingDescription, @"description",
                                           burger.url, @"link",
                                           imagePath, @"picture",
                                           nil];
            
            // Show the feed dialog
            [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                                   parameters:params
                                                      handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                          if (error) {
                                                              // An error occurred, we need to handle the error
                                                              // See: https://developers.facebook.com/docs/ios/errors
                                                              NSLog(@"Error publishing story: %@", error.description);
                                                          } else {
                                                              if (result == FBWebDialogResultDialogNotCompleted) {
                                                                  // User canceled.
                                                                  NSLog(@"User cancelled.");
                                                              } else {
                                                                  // Handle the publish feed callback
                                                                  NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                                  
                                                                  if (![urlParams valueForKey:@"post_id"]) {
                                                                      // User canceled.
                                                                      NSLog(@"User cancelled.");
                                                                      
                                                                  } else {
                                                                      // User clicked the Share button
                                                                      NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                      NSLog(@"result %@", result);
                                                                  }
                                                              }
                                                          }
                                                      }];
        }
    } else if (buttonIndex == 1) {
        SLComposeViewController *twitterComposer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [twitterComposer setInitialText:sharingName];
        [twitterComposer addURL:[NSURL URLWithString:burger.url]];
        UICollectionView *mainBurgerView = (UICollectionView *)[imagesCollectionView viewWithTag:0];
        DetailGalleryCell *cell = [mainBurgerView.subviews objectAtIndex:0];
        UIImage *imageAtt = nil;
        if (mainBurgerView != nil)
            imageAtt = cell.burgerImageView.image;
        [twitterComposer addImage:imageAtt];
        
        [self presentViewController:twitterComposer animated:YES completion:nil];
    }
}

// A function for parsing URL parameters returned by the Feed Dialog.
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

- (void)performOldSharing:(id)sender {
    UIActionSheet *sharingPopup = [[UIActionSheet alloc] initWithTitle:@"Share burger with" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Facebook", @"Twitter", nil];
    [sharingPopup showInView:self.view];
}

- (void)performSharing:(id)sender {
    BQActivityProvider *activityProvider = [[BQActivityProvider alloc] initWithBurger:burger];
    UICollectionView *mainBurgerView = (UICollectionView *)[imagesCollectionView viewWithTag:0];
    DetailGalleryCell *cell = [mainBurgerView.subviews objectAtIndex:0];
    
    UIImage *imageAtt = nil;
    if (mainBurgerView != nil) imageAtt = cell.burgerImageView.image;
    NSArray *Items = @[activityProvider, imageAtt, burger.url];
    activityProvider = nil;
    
    BQActivityIcon *ca = [[BQActivityIcon alloc] init];
    NSArray *Acts = @[ca];
    
    UIActivityViewController *activityView = [[UIActivityViewController alloc]
                                               initWithActivityItems:Items
                                               applicationActivities:Acts];
    [activityView setExcludedActivityTypes:
     @[UIActivityTypeAssignToContact,
       UIActivityTypeCopyToPasteboard,
       UIActivityTypePrint,
       UIActivityTypeSaveToCameraRoll,
       UIActivityTypePostToWeibo,
       UIActivityTypeMessage,
       UIActivityTypePostToFlickr,
       UIActivityTypePostToVimeo]];
    
    [self presentViewController:activityView animated:YES completion:nil];
    [activityView setCompletionHandler:^(NSString *act, BOOL done)
     {
         NSString *ServiceMsg = nil;
         if ( [act isEqualToString:UIActivityTypeMail] )           ServiceMsg = @"Mail envoyé !";
         if ( [act isEqualToString:UIActivityTypePostToTwitter] )  ServiceMsg = @"Tweet envoyé !";
         if ( [act isEqualToString:UIActivityTypePostToFacebook] ) ServiceMsg = @"Posté sur votre journal Facebook";
         if ( done )
         {
             UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:ServiceMsg message:@"" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
             [Alert show];
             Alert = nil;
         }
     }];
}

- (void)requestData {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSTimeZone *localTime = [NSTimeZone systemTimeZone];
    [params setObject:[localTime name] forKey:@"timezone"];
    
    NSString *path = [NSString stringWithFormat:@"burger/%@/rating", burger.burgerID];
    
    [BQNotif show];
    
    [apiEngine getPath:path withParams:params onCompletion:^(NSMutableDictionary *status, NSMutableDictionary *events, NSMutableArray *response) {
        
        if ([response count] > 0) {
            commentsList = response;
        }
        
        if([commentsList count] < 3) {
            //[extraCommentButton setHidden:YES];
        }
        
        //Adding cell manually
        float cy = 0.0f;
        float cheight = 0.0f;
        for (int i = 0; i < commentsList.count; i++) {
            Rating *rating = [[Rating alloc] initWithData:[commentsList objectAtIndex:i]];
            cy = 240.0f + 100.0f * i;
            UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, cy, 320.0f, 100.0f)];
            
            BOOL isCurrentUser = NO;
            if ([[[BQSession sharedSession] currentUser].uid intValue] == [rating.user.uid intValue]) {
                isCurrentUser = YES;
            }
            
            //Name
            NSString *userN = @"";
            if (rating.user.firstname.length > 0) userN = rating.user.firstname;
            else if (rating.user.tw_uid.length > 0) userN = rating.user.tw_uid;
            else userN = rating.user.username;
            
            //Rating
            UIImage *pictoUserLike;
            NSString *ratingString = @"has loved";
            if ([rating.note intValue] == 0) {
                ratingString = @"has commented";
            } else if ([rating.note intValue] < 2) {
                ratingString = @"has hated";
                if (isCurrentUser) hateButton.imageView.image = [UIImage imageNamed:@"IhateButtonOn.png"];
            } else if ([rating.note intValue] < 4) {
                ratingString = @"has liked";
                pictoUserLike = [UIImage imageNamed:@"picto_like@2x.png"];
                if (isCurrentUser) likeButton.imageView.image = [UIImage imageNamed:@"IlikeButtonOn.png"];
            } else {
                pictoUserLike = [UIImage imageNamed:@"picto_love@2x.png"];
                if (isCurrentUser) loveButton.imageView.image = [UIImage imageNamed:@"IloveButtonOn.png"];
            }
            
            MDHTMLLabel *userInfoLabel = [[MDHTMLLabel alloc] initWithFrame:CGRectMake(68, 10, 211, 21)];
            userInfoLabel.htmlText = [NSString stringWithFormat:@"<font face='DINReg' size='12' color='#30b4b6'>%@</font> <font face='DINReg' size='12' color='#000000'>%@</font>", userN, ratingString];
            userInfoLabel.font = [UIFont fontWithName:@"DINReg" size:13];
            CGFloat fontSize;
            CGSize textSize = [[NSString stringWithFormat:@"%@ %@", userN, ratingString] sizeWithFont:userInfoLabel.font minFontSize:13.0 actualFontSize:&fontSize  forWidth:211 lineBreakMode:UILineBreakModeMiddleTruncation];
            CGRect frame = userInfoLabel.frame;
            frame.size.width = textSize.width;
            userInfoLabel.frame = frame;
            NSLog(@"New width : %f", userInfoLabel.frame.size.width);
            [commentView addSubview:userInfoLabel];
            
            if (pictoUserLike != nil) {
                UIImageView *pictoView = [[UIImageView alloc] initWithFrame:CGRectMake(userInfoLabel.frame.origin.x + userInfoLabel.frame.size.width + 10, 15, 10, 11)];
                pictoView.image = pictoUserLike;
                [commentView addSubview:pictoView];
                pictoView = nil;
            }
            
            userInfoLabel = nil;
            
            // User picture
            UIImageView *userPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(16, 9, 36, 36)];
            CALayer *l = userPhoto.layer;
            [l setMasksToBounds:YES];
            [l setCornerRadius:18.0f];
            
            NSString *imagePath;
            if ([UIScreen mainScreen].scale == 2.0) imagePath =  [[rating user] thumbnail_2x];
            else imagePath =  [[rating user] thumbnail];
            if (imagePath.length > 0) {
                NSURL *avatarUrl = [NSURL URLWithString:imagePath];
                NSLog(@"%@", avatarUrl);
                userPhoto.contentMode = UIViewContentModeScaleAspectFill;
                userPhoto.clipsToBounds = YES;
                [userPhoto setImageWithURL:avatarUrl placeholderImage:[UIImage imageNamed:@"AvatarNoSignIn.png"]];
            }
            [commentView addSubview:userPhoto];
            
            //Date
            UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(68, 30, 240, 21)];
            dateLabel.numberOfLines = 1;
            dateLabel.textColor = [UIColor pxColorWithHexValue:@"B0B0B0"];
            [dateLabel setFont:[UIFont systemFontOfSize:12.0f]];
            dateLabel.text = [rating.date timeAgo];
            [commentView addSubview:dateLabel];
            
            //Comment
            UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(68, 52, 240, 42)];
            commentLabel.text = rating.comment;
            commentLabel.numberOfLines = 3;
            [commentLabel setFont:[UIFont systemFontOfSize:12.0f]];
            [commentView addSubview:commentLabel];
            
            [[FontUtils instance] customizeWithFonts:[NSArray arrayWithObjects:dateLabel, commentLabel, nil]];
            commentLabel = nil;
            dateLabel = nil;
            
            [self.scrollView addSubview:commentView];
            cheight = cy + commentView.frame.size.height;
            commentView = nil;
        }
        
        CGRect svFrame = self.scrollView.frame;
        svFrame.size.height = [UIScreen mainScreen].bounds.size.height;
        [self.scrollView setFrame:svFrame];
        [self.scrollView setContentSize:CGSizeMake(320.0f, cheight + 60)];
        
        [BQNotif showDoneWithStatus:nil];
        
        //[self dataProcessed];
        
    } onError:^(NSError *error) {
        NSLog(@"Error occured : %@", error);
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView {
    self.burgerPicsPageControl.currentPage = _scrollView.contentOffset.x / 320.0f;
}

- (void)scrollViewDidScroll:(UIScrollView *)_scrollView {

}

- (void)setupCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];
    [flowLayout setItemSize:CGSizeMake(320, 340)];
    [self.imagesCollectionView setCollectionViewLayout:flowLayout];
    [self.imagesCollectionView registerClass:[DetailGalleryCell class] forCellWithReuseIdentifier:@"detailCellIdentifier"];
}

#pragma  marks - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([burger picture] != nil) {
        self.burgerPicsPageControl.numberOfPages = [[burger picture] count];
        return [[burger picture] count];
    } else {
        return 0;
    }
}

#pragma marks - UICollectionViewDelegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DetailGalleryCell *cell = (DetailGalleryCell*) [self.imagesCollectionView dequeueReusableCellWithReuseIdentifier:@"detailCellIdentifier" forIndexPath:indexPath];
    
    NSString *imagePath = @"";
    if ([UIScreen mainScreen].scale == 2.0) {
        imagePath = [[[burger picture] objectAtIndex:indexPath.row] single_2x];
    } else {
        imagePath = [[[burger picture] objectAtIndex:indexPath.row] single];
    }
    
    [cell setImagePath:imagePath];
    [cell configureGalleryCell];
    
    return cell;
}


@end
