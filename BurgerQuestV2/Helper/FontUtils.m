//
//  FontUtils.m
//  BurgerQuestV2
//
//  Created by Térence Marill on 24/04/2014.
//  Copyright (c) 2014 BurgerQuest. All rights reserved.
//

#import "FontUtils.h"

@implementation FontUtils

static FontUtils *_instance;

+ (FontUtils *) instance {
    if (_instance == nil) {
        _instance = [[self alloc] init];
    }
    return _instance;
}

+(id) alloc {
	@synchronized([FontUtils class]) {
		NSAssert(_instance == nil, @"Attempted to allocate a second instance of a singleton.");
		_instance = [super alloc];
		return _instance;
	}
	return nil;
}

-(id) init {
	self = [super init];
	if (self != nil) {
        
	}
	
	return self;
}

- (void)customizeWithFonts:(NSArray *)views {
    for (NSObject *view in views) {
        UIFont *customFont = nil;
        UILabel *label = nil;
        if ([view class] == [UILabel class] || [view class] == [MDHTMLLabel class]) {
            label = (UILabel *) view;
        } else if ([view class] == [UIButton class]) {
            label = ((UIButton *) view).titleLabel;
        } else if ([view class] == [UITextField class]) {
            ((UITextField *)view).attributedPlaceholder =
            [[NSAttributedString alloc] initWithString:((UITextField *)view).placeholder
                                            attributes:@{
                                                         NSForegroundColorAttributeName: [UIColor whiteColor],
                                                         NSFontAttributeName : [UIFont fontWithName:@"DINReg" size:14.0]
                                                         }];
        }
        
        if (label != nil) {
            if (label.font.isBold) {
                customFont = [UIFont fontWithName:@"DINBol" size:label.font.pointSize];
            } else if (label.font.isItalic){
                customFont = [UIFont fontWithName:@"Dense-Regular" size:label.font.pointSize];
            } else {
                customFont = [UIFont fontWithName:@"DINReg" size:label.font.pointSize];
            }
            
            [label setFont:customFont];
        }
    }
}

- (void) customizeTextField:(NSArray *)views {
    for (NSObject *view in views) {
        UITextField *textField = (UITextField *) view;
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
        textField.leftView = paddingView;
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.rightView = paddingView;
        textField.rightViewMode = UITextFieldViewModeAlways;
        paddingView = nil;
    }
}

- (void) addRoundedCornersToView:(UIView *)view withTop:(CGFloat)t right:(CGFloat)r left:(CGFloat)l bottom:(CGFloat)b {
    UIImage *mask = MTDContextCreateRoundedMask(view.bounds, t, r, l, b);
    CALayer *layerMask = [CALayer layer];
    layerMask.frame = view.bounds;
    // Put the mask image as content of the layer
    layerMask.contents = (id)mask.CGImage;
    // set the mask layer as mask of the view layer
    view.layer.mask = layerMask;
}

- (void)addOnclickLayers:(NSArray *)views {
    for (NSObject *view in views) {
        UIButton *button = (UIButton *)view;
        [button setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    }
}

static inline UIImage* MTDContextCreateRoundedMask( CGRect rect, CGFloat radius_tl, CGFloat radius_tr, CGFloat radius_bl, CGFloat radius_br ) {
    
    CGContextRef context;
    CGColorSpaceRef colorSpace;
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create a bitmap graphics context the size of the image
    context = CGBitmapContextCreate( NULL, rect.size.width, rect.size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast );
    
    // free the rgb colorspace
    CGColorSpaceRelease(colorSpace);
    
    if ( context == NULL ) {
        return NULL;
    }
    
    // cerate mask
    
    CGFloat minx = CGRectGetMinX( rect ), midx = CGRectGetMidX( rect ), maxx = CGRectGetMaxX( rect );
    CGFloat miny = CGRectGetMinY( rect ), midy = CGRectGetMidY( rect ), maxy = CGRectGetMaxY( rect );
    
    CGContextBeginPath( context );
    CGContextSetGrayFillColor( context, 1.0, 0.0 );
    CGContextAddRect( context, rect );
    CGContextClosePath( context );
    CGContextDrawPath( context, kCGPathFill );
    
    CGContextSetGrayFillColor( context, 1.0, 1.0 );
    CGContextBeginPath( context );
    CGContextMoveToPoint( context, minx, midy );
    CGContextAddArcToPoint( context, minx, miny, midx, miny, radius_bl );
    CGContextAddArcToPoint( context, maxx, miny, maxx, midy, radius_br );
    CGContextAddArcToPoint( context, maxx, maxy, midx, maxy, radius_tr );
    CGContextAddArcToPoint( context, minx, maxy, minx, midy, radius_tl );
    CGContextClosePath( context );
    CGContextDrawPath( context, kCGPathFill );
    
    // Create CGImageRef of the main view bitmap content, and then
    // release that bitmap context
    CGImageRef bitmapContext = CGBitmapContextCreateImage( context );
    CGContextRelease( context );
    
    // convert the finished resized image to a UIImage
    UIImage *theImage = [UIImage imageWithCGImage:bitmapContext];
    // image is retained by the property setting above, so we can
    // release the original
    CGImageRelease(bitmapContext);
    
    // return the image
    return theImage;
}

-(NSString *)stringForRating:(float)_rating {
    NSString *ratingString = [NSString stringWithFormat:@"%.1f", _rating];
    if ([ratingString rangeOfString:@".0"].location > 0 && [ratingString rangeOfString:@".0"].location < ratingString.length) {
        return [ratingString substringToIndex:[ratingString rangeOfString:@".0"].location];
    } else {
        return ratingString;
    }
}

@end
