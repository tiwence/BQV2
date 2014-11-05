//
//  FontUtils.h
//  BurgerQuestV2
//
//  Created by Térence Marill on 24/04/2014.
//  Copyright (c) 2014 BurgerQuest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIFont+Traits.h"
#import "MDHTMLLabel.h"

@interface FontUtils : NSObject

+ (FontUtils *) instance;

- (void)customizeWithFonts:(NSArray *)views;
- (void) customizeTextField:(NSArray *)views;
- (void) addOnclickLayers:(NSArray *)views;
- (void) addRoundedCornersToView:(UIView *)view withTop:(CGFloat)t right:(CGFloat)r left:(CGFloat)l bottom:(CGFloat)b;

@end
