//
//  BQActivityProvider.h
//  BurgerQuestV2
//
//  Created by Térence Marill on 19/05/2014.
//  Copyright (c) 2014 BurgerQuest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Burger.h"

@interface BQActivityProvider : UIActivityItemProvider {
    Burger *burger;
}

-(id)initWithBurger:(Burger *)_burger;

@end

@interface BQActivityIcon : UIActivity
@end