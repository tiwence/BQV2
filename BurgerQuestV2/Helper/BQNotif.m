//
//  BQNotif.m
//  BurgerQuest
//
//  Created by Laurent Menu on 11/06/12.
//  Copyright (c) 2012 BurgerQuest. All rights reserved.
//

#import "BQNotif.h"

@implementation BQNotif

static UIImage *notifBgOrange = nil;
static UIImage *notifBgRed = nil;
static UIImage *notifBgGreen = nil;
static UIImage *notifPictoOrange = nil;
static UIImage *notifPictoGreen = nil;
static UIImage *notifPictoRed = nil;
static UIFont *titleLabelFont = nil;
static UIFont *textLabelFont = nil;
static UIColor *shadowGreenColor = nil;
static UIColor *shadowOrangeColor = nil;
static UIColor *shadowRedColor = nil;

static UIImage *loaderStep1 = nil;
static UIImage *loaderStep2 = nil;
static UIImage *loaderStep3 = nil;
static UIImage *loaderStep4 = nil;
static UIImage *loaderStep5 = nil;
static UIImage *loaderStep6 = nil;
static UIImage *loaderStep7 = nil;

static BQNotif *sharedView = nil;

#pragma mark - Initialize

+ (void)initialize
{
    if (self == [BQNotif class]) {
        notifBgOrange = [UIImage imageNamed:@"NotifBarOrange.png"];
        notifBgRed = [UIImage imageNamed:@"NotifBarRed.png"];
        notifBgGreen = [UIImage imageNamed:@"NotifBarGreen.png"];
        notifPictoOrange = [UIImage imageNamed:@"NotifPictoOrange.png"];
        notifPictoGreen = [UIImage imageNamed:@"NotifPictoGreen.png"];
        notifPictoRed = [UIImage imageNamed:@"NotifPictoRed.png"];
        titleLabelFont = [UIFont fontWithName:@"TrebuchetMS-Bold" size:15.];
        textLabelFont = [UIFont fontWithName:@"TrebuchetMS" size:15.];
        shadowGreenColor = [UIColor colorWithRed:(14./255.) green:(87./255.) blue:(7./255.) alpha:1.];
        shadowOrangeColor = [UIColor colorWithRed:(122./255.) green:(77./255.) blue:(0./255.) alpha:1.];
        shadowRedColor = [UIColor colorWithRed:(105./255.) green:(0./255.) blue:(0./255.) alpha:1.];
        
        loaderStep1 = [UIImage imageNamed:@"loaderStep1.png"];
        loaderStep2 = [UIImage imageNamed:@"loaderStep2.png"];
        loaderStep3 = [UIImage imageNamed:@"loaderStep3.png"];
        loaderStep4 = [UIImage imageNamed:@"loaderStep4.png"];
        loaderStep5 = [UIImage imageNamed:@"loaderStep5.png"];
        loaderStep6 = [UIImage imageNamed:@"loaderStep6.png"];
        loaderStep7 = [UIImage imageNamed:@"loaderStep7.png"];
    }
}

+ (BQNotif*)sharedView {
	
	if(sharedView == nil)
		sharedView = [[BQNotif alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	return sharedView;
}


+ (void)setStatus:(NSString *)string {
	[[BQNotif sharedView] setStatus:string];
}

#pragma mark - Show Methods

+ (void)show {
    //[[BQNotif sharedView] showWithStatus:nil type:@"loading"];
}

+ (void)showDoneWithStatus:(NSString*)string
{
    [[BQNotif sharedView] showWithStatus:string type:@"done"];
    [BQNotif dismissWithDelay];
}

+ (void)showErrorWithStatus:(NSString*)string
{
    [[BQNotif sharedView] showWithStatus:string type:@"error"];
    [BQNotif dismissWithDelay];
}

+ (void)showSuccessWithStatus:(NSString*)string
{
    [[BQNotif sharedView] showWithStatus:string type:@"success"];
    [BQNotif dismissWithDelay];
}


#pragma mark - Dismiss methods

+ (void)dismissWithDelay
{
    [[BQNotif sharedView] dismissWithDelay:1.5];
}

+ (void)dismiss
{
    [[BQNotif sharedView] dismiss];
}

#pragma mark - Instance Methods

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        window = [UIApplication sharedApplication].keyWindow;	
        if (!window) {	
            window = [[UIApplication sharedApplication].windows objectAtIndex:0];	
        }
        
        containerView = [[UIView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width / 2) - (notifBgGreen.size.width / 2), -20, notifBgGreen.size.width, notifBgGreen.size.height)];
        
        backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, notifBgGreen.size.width, notifBgGreen.size.height)];
        [containerView addSubview:backgroundView];
        
        // Picto
        picto = [[UIImageView alloc] initWithFrame:CGRectMake(0, 8., notifPictoGreen.size.width, notifPictoGreen.size.height)];
        
        // Loader
        loader = [[UIImageView alloc] initWithFrame:CGRectMake(0, 8., loaderStep1.size.width, loaderStep1.size.height)];
        [loader setImage:loaderStep1];
        loader.animationImages = [NSArray arrayWithObjects:loaderStep1, loaderStep2, loaderStep3, loaderStep4, loaderStep5, loaderStep6, loaderStep7, nil];
        loader.animationDuration = 0.8;
        
        // Content view
        contentView = [[UIView alloc] init];
        
        // Labels
        titleLabel = [[UILabel alloc] init];
        [titleLabel setFont:titleLabelFont];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setShadowOffset:CGSizeMake(0., 2.)];
        
        textLabel = [[UILabel alloc] init];
        [textLabel setFont:textLabelFont];
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setTextColor:[UIColor whiteColor]];
        [textLabel setShadowOffset:CGSizeMake(0., 2.)];
        
        [containerView addSubview:backgroundView];
        
        [contentView addSubview:picto];
        [contentView addSubview:loader];
        [contentView addSubview:titleLabel];
        [contentView addSubview:textLabel];
        
        [self alignViews];
        
        [containerView addSubview:contentView];
        
        [self addSubview:containerView];
    }
    
    return self;
}

- (void)setStatus:(NSString *)string 
{
    if (string) {
        [textLabel setText:string];
        [textLabel sizeToFit];
    }
}

- (void)show
{    
    [self setFrame:CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height)];
    
    [window addSubview:self];
    
    
    // Animate view
    [UIView animateWithDuration:0.3 animations:^{
        [containerView setFrame:CGRectMake(containerView.frame.origin.x, 19, containerView.frame.size.width, containerView.frame.size.height)];
    } completion:^(BOOL finished) {
        isVisible = YES;
    }];
}

- (void)showWithStatus:(NSString*)string type:(NSString*)type
{
    [window setUserInteractionEnabled:YES];
    
    [timer invalidate];
    [self setStatus:string];
    
    if ([type isEqualToString:@"success"]) {
        [backgroundView setImage:notifBgGreen];
        
        [self stopLoader];
        
        [picto setImage:notifPictoGreen];
        [picto setFrame:CGRectMake(0, 8., notifPictoGreen.size.width, notifPictoGreen.size.height)];
        [titleLabel setText:@"Yeah!"];
        [textLabel setFont:[UIFont fontWithName:@"TrebuchetMS" size:13.]];
        
        if (string == nil) {
            [textLabel setText:@"Thank you for your participation"];
        }
    }
    else if ([type isEqualToString:@"error"]) {
        [backgroundView setImage:notifBgRed];
        
        [self stopLoader];
        
        [picto setImage:notifPictoRed];
        [picto setFrame:CGRectMake(0, 8., notifPictoRed.size.width, notifPictoRed.size.height)];
        [titleLabel setText:@"Oops!"];
        
        if (string == nil) {
            [textLabel setText:@"Something goes wrong"];
        }
    }
    else
    {
        [backgroundView setImage:notifBgOrange];
        
        if ([type isEqualToString:@"loading"]) {
            [self startLoader];
            [titleLabel setText:@"Loading..."];
            
            [window setUserInteractionEnabled:YES];
        }
        else {
            [self stopLoader];
            [picto setImage:notifPictoOrange];
            [picto setFrame:CGRectMake(0, 8., notifPictoOrange.size.width, notifPictoOrange.size.height)];
            [titleLabel setText:@"Done!"];
        }
        
        if (string == nil) {
            [textLabel setText:nil];
        }
    }
    
    [titleLabel sizeToFit];
    [textLabel sizeToFit];
    [self alignViews];
    
    [self show];
}

- (void)alignViews
{
    float width = 0.;
    
    for (UIView *item in [contentView subviews]) {
        width += item.frame.size.width;
    }
    
    [titleLabel setFrame:CGRectMake(picto.frame.size.width + 6., 0, titleLabel.frame.size.width, 39.)];
    [textLabel setFrame:CGRectMake((titleLabel.frame.size.width + titleLabel.frame.origin.x + 4.), 0, textLabel.frame.size.width, 39.)];
    [contentView setFrame:CGRectMake((notifBgGreen.size.width / 2) - (width / 2), 0, width, contentView.frame.size.height)];
}

- (void)dismissWithDelay:(NSTimeInterval)seconds
{
    timer = [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
}

- (void)dismiss
{    
    [window setUserInteractionEnabled:YES];
    
    // Animate view
    [UIView animateWithDuration:0.3 animations:^{
        [containerView setFrame:CGRectMake(containerView.frame.origin.x, -20, containerView.frame.size.width, containerView.frame.size.height)];
    } completion:^(BOOL finished) {
        isVisible = NO;
        [self removeFromSuperview];
    }];
}

#pragma mark - Loader methods
- (void)startLoader
{
    [picto setHidden:YES];
    [loader setHidden:NO];
    
    [loader startAnimating];
}

- (void)stopLoader
{
    [loader stopAnimating];
    
    [picto setHidden:NO];
    [loader setHidden:YES];
}

@end