//
//  BurgerGalleryCell.m
//  BurgerQuestV2
//
//  Created by Térence Marill on 18/05/2014.
//  Copyright (c) 2014 BurgerQuest. All rights reserved.
//

#import "BurgerGalleryCell.h"

@implementation BurgerGalleryCell
@synthesize burgerButton, delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"BurgerGalleryCell" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
    }
    
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.delegate = nil;
}

- (void)configureGalleryCell: (Burger*) _burger {
    burger = _burger;
    NSString *imagePath = @"";
    
    if ([burger picture] != nil && [burger picture].count > 0) {
        if ([UIScreen mainScreen].scale == 2.0) {
            imagePath = [[[burger picture] objectAtIndex:0] single_2x];
        } else {
            imagePath = [[[burger picture] objectAtIndex:0] single];
        }
    }
    [burgerButton setBackgroundImageWithURL:[NSURL URLWithString:imagePath] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"MapPictureBackground.png"]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(performShowBurger:)];
    tap.numberOfTapsRequired = 1;
    [burgerButton addGestureRecognizer:tap];
}

- (void)performShowBurger:(id)sender {
    if ([self.delegate respondsToSelector:@selector(delegateForCell:)])
        [self.delegate delegateForCell:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
