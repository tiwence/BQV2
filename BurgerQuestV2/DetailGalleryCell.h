//
//  DetailGalleryCell.h
//  BurgerQuestV2
//
//  Created by Térence Marill on 12/04/2014.
//  Copyright (c) 2014 BurgerQuest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface DetailGalleryCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIImageView *burgerImageView;
@property (nonatomic, strong) NSString *imagePath;

- (void)configureGalleryCell;

@end
