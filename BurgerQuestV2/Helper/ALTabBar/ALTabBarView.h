//
//  ALTabBarView.h
//  ALCommon
//
//  Created by Andrew Little on 10-08-17.
//  Copyright (c) 2010 Little Apps - www.myroles.ca. All rights reserved.
//
//  Simple custom TabBar view that is defined in the TabBarView nib and used to 
//  replace the standard iOS TabBar view.  By customizing TabBarView.xib, you can
//  create a tab bar that is unique to your application, but still has the tab
//  switching functionality you've come to expect out of UITabBarController.

#import <UIKit/UIKit.h>

//Delegate methods for responding to TabBar events
@protocol ALTabBarDelegate <NSObject>

//Handle tab bar touch events, sending the index of the selected tab
@required
-(void)tabWasSelected:(NSInteger)index withButton:(BOOL)withButton;

@end

@interface ALTabBarView : UIView {

    id<ALTabBarDelegate> _delegate;

    UIButton *selectedButton;
}

@property (nonatomic) id<ALTabBarDelegate> delegate;
@property (nonatomic) UIButton *selectedButton;
 

-(IBAction) touchButton:(id)sender;

@end
