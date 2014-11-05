//
//  PopView.m
//  BurgerQuest
//
//  Created by Laurent MENU on 03/05/12.
//  Copyright (c) 2012 BurgerQuest. All rights reserved.
//

#import "PopView.h"

@implementation PopView

@synthesize background;
@synthesize popView;
@synthesize contentView;
@synthesize contentViewBackground;
@synthesize closeButton;
@synthesize titleLabel;
@synthesize textLabel;
@synthesize badgeImage;
@synthesize badgeImageView;

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    
}

- (void)viewDidUnload
{
    [self setBackground:nil];
    [self setPopView:nil];
    [self setContentView:nil];
    [self setContentViewBackground:nil];
    [self setCloseButton:nil];
    [self setTitleLabel:nil];
    [self setTextLabel:nil];
    [self setBadgeImage:nil];
    [self setBadgeImageView:nil];
}

- (id)init
{
    if ((self = [super initWithFrame:CGRectZero])) {
        // Background
        background = [[UIView alloc] init];
        [background setBackgroundColor:[UIColor blackColor]];
        [background setAlpha:0.];
        
        // Content background view
        contentViewBackground = [[UIView alloc] init];
        [contentViewBackground setBackgroundColor:[UIColor clearColor]];
        
        // Content view
        contentView = [[UIView alloc] init];
        
        // Top content background
        UIImage *contentTopImage = [UIImage imageNamed:@"PopBackgroundTop.png"];
        UIImageView *contentTop = [[UIImageView alloc] initWithImage:contentTopImage];
        [contentTop setFrame:CGRectMake(0, 0, contentTopImage.size.width, contentTopImage.size.height)];
        [contentViewBackground addSubview:contentTop];
        
        // Content background
        UIImage *contentBackgroundImage = [UIImage imageNamed:@"PopBackground.png"];
        contentBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, contentTop.frame.size.height, contentBackgroundImage.size.width, 0)];
        [contentBackground setImage:contentBackgroundImage];
        [contentBackground setContentMode:UIViewContentModeScaleToFill];
        [contentViewBackground addSubview:contentBackground];        
        
        // Bottom content background
        UIImage *contentBottomImage = [UIImage imageNamed:@"PopBackgroundBottom.png"];
        contentBottom = [[UIImageView alloc] initWithImage:contentBottomImage];
        [contentBottom setFrame:CGRectMake(0, (contentBackground.frame.origin.y + contentBackground.frame.size.height), contentBottomImage.size.width, contentBottomImage.size.height)];
        [contentViewBackground addSubview:contentBottom];
        
        [contentViewBackground setFrame:CGRectMake(0, 0, contentTopImage.size.width, 0)];
        
        // Close button
        UIImage *closeButtonImage = [UIImage imageNamed:@"CloseButton.png"];
        closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setFrame:CGRectMake(224, 10, closeButtonImage.size.width, closeButtonImage.size.height)];
        [closeButton setImage:closeButtonImage forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closePopAction:) forControlEvents:UIControlEventTouchUpInside];
        
        // Label
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 40, 150, 22.)];
        titleLabel.text = @"Congratulation!";
        [titleLabel setTextAlignment:UITextAlignmentRight];
        [titleLabel setFont:[UIFont fontWithName:@"TrebuchetMS" size:20.]];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        
        // Text        
        textLabel = [[UILabel alloc] init];
        [textLabel setFont:[UIFont fontWithName:@"TrebuchetMS" size:15.]];
        [textLabel setTextColor:[UIColor whiteColor]];
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setNumberOfLines:0];
        
        // Badge image
        badgeImageView = [[UIImageView alloc] init];
        
        [contentView addSubview:closeButton];
        [contentView addSubview:titleLabel];
        [contentView addSubview:textLabel];
        [contentView addSubview:badgeImageView];
        
        [self updateSize];
    }
    
    return self;
}

- (void)updateSize
{
    float contentHeight = (textLabel.frame.origin.y + textLabel.frame.size.height) + 15;
    
    // Set background size
    [contentBackground setFrame:CGRectMake(0, contentBackground.frame.origin.y, contentBackground.frame.size.width, contentHeight)];
    [contentBottom setFrame:CGRectMake(0, (contentBackground.frame.origin.y + contentHeight), contentBottom.frame.size.width, contentBottom.frame.size.height)];
    
    [contentViewBackground setFrame:CGRectMake(0, 0, contentViewBackground.frame.size.width, contentView.frame.size.height)];
    
    // Set content size
    [contentView setFrame:CGRectMake(0, 0, contentViewBackground.frame.size.width, contentHeight)];
    
    // Insert background and content in pop view
    popView = [[UIView alloc] initWithFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.width / 2) - (contentView.frame.size.width / 2), ([[UIScreen mainScreen] bounds].size.height / 2) - (contentHeight / 2), contentView.frame.size.width, contentView.frame.size.height)];
    
    [popView addSubview:contentViewBackground];
    [popView addSubview:contentView];
}

- (void)setPopupText:(NSString *)text
{
    [[self textLabel] setText:text];
    
    CGSize maxLabelSize = CGSizeMake(212, 99999);
    
    CGSize expectedSize = [textLabel.text sizeWithFont:textLabel.font constrainedToSize: maxLabelSize lineBreakMode:UILineBreakModeWordWrap];
    
    [textLabel setFrame:CGRectMake(20, 83, 212, expectedSize.height)];
    
    [self updateSize];
}

- (void)setBadgeImageWithIDAndType:(NSString *)ID type:(NSString *)type
{
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Badge%@%@Pop.png", ID, type]];
    [self setImageForBadge:image];
}

- (void)setImageForBadge:(UIImage *)image
{
    [badgeImageView setFrame:CGRectMake(20, 15, image.size.width, image.size.height)];
    [badgeImageView setImage:image];
}

- (void)showPopView 
{    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;	
    if (!window) {	
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];	
    }	
    self.frame = window.frame;	
	
    [background setFrame:window.frame];
    [self addSubview:background];
    [self addSubview:popView];
    
    [popView setTransform:CGAffineTransformMakeScale(0.001, 0.001)];
    
    // Animate background
    [UIView animateWithDuration:0.3 animations:^{
        [background setAlpha:0.5];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            [popView setTransform:CGAffineTransformIdentity];
        }];
    }];
    
    [window addSubview:self];
    
    [self viewWillAppear:NO];
}

- (IBAction)closePopAction:(id)sender {
    [self viewWillDisappear:NO];
    
    [self removeFromSuperview];
}

@end
