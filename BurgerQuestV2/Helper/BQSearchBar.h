//
//  BQSearchBar.h
//  BurgerQuest
//
//  Created by Laurent Menu on 24/04/12.
//  Copyright (c) 2012 BurgerQuest. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BQSearchBarDelegate <NSObject>

@required
- (void)searchButtonClicked:(UISearchBar *)aSearchBar;

@end

@interface BQSearchBar : UISearchBar <UISearchBarDelegate>
{
    UIButton *clearButton;
    UITextField *searchBarTextField;
    UITapGestureRecognizer *tap;
    
    id <BQSearchBarDelegate> customDelegate;
}

@property (retain) id customDelegate;

- (void)dismissKeyboard;

- (IBAction)clearButtonAction:(id)sender;

@end