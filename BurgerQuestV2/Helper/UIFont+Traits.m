//
//  UIFont+Traits.m
//  BurgerQuestV2
//
//  Created by Térence Marill on 24/04/2014.
//  Copyright (c) 2014 BurgerQuest. All rights reserved.
//

#import "UIFont+Traits.h"

@implementation UIFont (Traits)

- (CTFontSymbolicTraits)traits
{
    CTFontRef fontRef = (__bridge CTFontRef)self;
    CTFontSymbolicTraits symbolicTraits = CTFontGetSymbolicTraits(fontRef);
    return symbolicTraits;
}

- (BOOL)isBold
{
    CTFontSymbolicTraits symbolicTraits = [self traits];
    return (symbolicTraits & kCTFontBoldTrait);
}

- (BOOL)isItalic
{
    CTFontSymbolicTraits symbolicTraits = [self traits];
    return (symbolicTraits & kCTFontItalicTrait);
}

@end
