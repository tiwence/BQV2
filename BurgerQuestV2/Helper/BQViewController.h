//
//  BQViewController.h
//  BurgerQuest
//
//  Created by Sébastien POUDAT on 01/04/12.
//  Copyright (c) 2012 Milky-Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BQAPIEngine.h"
#import "BQNotif.h"

@interface BQViewController : UIViewController 
{
    BQAPIEngine *apiEngine;
}

@property (nonatomic, retain) BQAPIEngine *apiEngine;

@end
