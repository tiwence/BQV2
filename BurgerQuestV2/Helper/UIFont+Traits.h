//
//  UIFont+Traits.h
//  BurgerQuestV2
//
//  Created by Térence Marill on 24/04/2014.
//  Copyright (c) 2014 BurgerQuest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface UIFont (Traits)

- (CTFontSymbolicTraits)traits;

- (BOOL)isBold;
- (BOOL)isItalic;

@end
