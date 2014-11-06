//
//  DetailGalleryCell.m
//  BurgerQuestV2
//
//  Created by Térence Marill on 12/04/2014.
//  Copyright (c) 2014 BurgerQuest. All rights reserved.
//

#import "DetailGalleryCell.h"

@implementation DetailGalleryCell

@synthesize imagePath, burgerImageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"DetailGalleryCell" owner:self options:nil];
        
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

- (void)configureGalleryCell {
    burgerImageView.clipsToBounds = YES;
    [burgerImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[burgerImageView]|" options:0 metrics:nil views:@{@"burgerImageView" : burgerImageView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[burgerImageView]|" options:0 metrics:nil views:@{@"burgerImageView" : burgerImageView}]];
    [burgerImageView setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"MapPictureBackground.png"]];
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
