//
//  BurgerGalleryCell.h
//  BurgerQuestV2
//
//  Created by Térence Marill on 18/05/2014.
//  Copyright (c) 2014 BurgerQuest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+WebCache.h"
#import "Burger.h"

@protocol MyBurgerCellDelegate;

@interface BurgerGalleryCell : UICollectionViewCell {
    Burger *burger;
}
@property (assign, nonatomic) id <MyBurgerCellDelegate> delegate;


@property (nonatomic, strong) IBOutlet UIButton *burgerButton;

- (void)configureGalleryCell:(Burger*) _burger ;

@end

@protocol MyBurgerCellDelegate <NSObject>

@optional

- (void)delegateForCell:(BurgerGalleryCell *)cell;

@end


