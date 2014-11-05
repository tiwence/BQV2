//
//  BurgerCell.m
//  BurgerQuestV2
//
//  Created by Térence Marill on 16/03/2014.
//  Copyright (c) 2014 BurgerQuest. All rights reserved.
//

#import "BurgerCell.h"

@implementation BurgerCell

@synthesize burgerImageView, burgerNameLabel, restaurantLabel, ratingLabel, distanceLabel, usersLabel, burgersNumberLabel, headerBackGroundView, burgerInfosView, burger, pictoBurger;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCell:(Burger *)_burger {
    
    burger = _burger;
    
    //Customizing views
    [[FontUtils instance] customizeWithFonts:[NSArray arrayWithObjects:burgerNameLabel, restaurantLabel, ratingLabel, distanceLabel, usersLabel, nil]];
    
    CAGradientLayer *bgLayer = [BackgroundLayer greyGradient];
    CGRect bgFrame = headerBackGroundView.frame;
    bgFrame.origin.x = 0;
    bgFrame.origin.y = 0;
    bgLayer.frame = bgFrame;
    [self.headerBackGroundView.layer insertSublayer:bgLayer atIndex:0];
    
    [[FontUtils instance] addRoundedCornersToView:headerBackGroundView withTop:5.0 right:5.0 left:0.0 bottom:0.0];
    //Customizing uiviews
    [[FontUtils instance] addRoundedCornersToView:burgerInfosView withTop:0.0 right:0.0 left:4.0 bottom:4.0];
    // Add a bottomBorder.
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, burgerInfosView.frame.size.height - 2.0f, burgerInfosView.frame.size.width, 2.0f);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.8f
                                                     alpha:1.0f].CGColor;
    [burgerInfosView.layer addSublayer:bottomBorder];
    
    burgerNameLabel.text = _burger.name;
    restaurantLabel.text = _burger.place.name;
    float rating = [_burger.rating floatValue] * 2.0;
    
    ratingLabel.text = [NSString stringWithFormat:@"%.1f", rating];
    CGSize textSize = [[NSString stringWithFormat:@"%@", [_burger.place getDistanceInMeter]] sizeWithFont: distanceLabel.font
                         constrainedToSize:CGSizeMake(50.0f, CGFLOAT_MAX)
                             lineBreakMode:UILineBreakModeWordWrap];
    CGRect distanceLabelFrame = distanceLabel.frame;
    distanceLabelFrame.size.width = textSize.width;
    distanceLabel.frame = distanceLabelFrame;
    distanceLabel.text = [NSString stringWithFormat:@"%@", [_burger.place getDistanceInMeter]];
    
    usersLabel.text = [NSString stringWithFormat:@"%d", [_burger.count_rating integerValue]];
    if ([_burger.place.numberOfBurgersInPlace integerValue] <= 1)
        burgersNumberLabel.text = [NSString stringWithFormat:@"%d burger", [_burger.place.numberOfBurgersInPlace integerValue]];
    else
        burgersNumberLabel.text = [NSString stringWithFormat:@"%d burgers", [_burger.place.numberOfBurgersInPlace integerValue]];
    
    CGRect pictoBurgerFrame = pictoBurger.frame;
    pictoBurgerFrame.origin.x = distanceLabel.frame.size.width + distanceLabel.frame.origin.x + 10;
    pictoBurger.frame = pictoBurgerFrame;
    CGRect burgersNumberFrame = burgersNumberLabel.frame;
    burgersNumberFrame.origin.x = pictoBurger.frame.origin.x + pictoBurger.frame.size.width + 5;
    burgersNumberLabel.frame = burgersNumberFrame;
    
    //burger image
    NSString *imagePath = @"";
    CALayer *l = [burgerImageView layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:4.0];
    
    burgerImageView.clipsToBounds = YES;
    if ([[_burger picture] count] >= 1) {
        if ([UIScreen mainScreen].scale == 2.0) {
            imagePath = [[[_burger picture] objectAtIndex:0] single_2x];
        } else {
            imagePath = [[[_burger picture] objectAtIndex:0] single];
        }
                
        [burgerImageView setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"MapPictureBackground.png"]];
    }
}

@end

@implementation UILabel (BPExtensions)


- (void)sizeToFitFixedWidth:(CGFloat)fixedWidth
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, fixedWidth, 0);
    self.lineBreakMode = NSLineBreakByWordWrapping;
    self.numberOfLines = 0;
    [self sizeToFit];
}
@end
