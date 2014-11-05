//
//  BQSearchBar.m
//  BurgerQuest
//
//  Created by Laurent Menu on 24/04/12.
//  Copyright (c) 2012 BurgerQuest. All rights reserved.
//

#import "BQSearchBar.h"

@implementation BQSearchBar

@synthesize customDelegate;

- (id)initWithCoder:(NSCoder *)aDecoder
{    
    
    if (self = [super initWithCoder:aDecoder]) {
        self.delegate = self;
    }
    
    [self setDelegate:self];
    
    // SearchBar textField object
    searchBarTextField = [[self subviews] objectAtIndex:1];
    
    self.placeholder = @"Search";
    
    // Custom search bar background
    UIImage *backgroundImgSearchBar = [UIImage imageNamed:@"SearchFieldBackground.png"];
    
    // Custom search icon
    UIImage *searchBarIcon = [UIImage imageNamed:@"SearchBarIcon.png"];
    
    // Custom clear button
    UIImage *clearButtonImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SearchBarClearButton" ofType:@"png"]];
    UIImage *clearButtonImgOn = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SearchBarClearButtonOn" ofType:@"png"]];
    clearButton = [[UIButton alloc] initWithFrame:CGRectMake(280, 12, clearButtonImg.size.width, clearButtonImg.size.height)];
    [clearButton setBackgroundImage:clearButtonImg forState:UIControlStateNormal];
    [clearButton setBackgroundImage:clearButtonImgOn forState:UIControlStateHighlighted];
    
    // Hide default background
    [[[self subviews] objectAtIndex:0] setAlpha:0.0];
    
    // Custom textfield
    [self setSearchFieldBackgroundImage:backgroundImgSearchBar forState:UIControlStateNormal];
    [searchBarTextField setTextColor:[UIColor whiteColor]];
    
    // Set textfield left icon
    [self setImage:searchBarIcon forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    // Set clear button custom on basic clear button
    [self addSubview:clearButton];
    [clearButton setAlpha:0.];
    [clearButton addTarget:self action:@selector(clearButtonAction:) forControlEvents:UIControlEventTouchDown];
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [tap setNumberOfTapsRequired:1];
    
    return self;
}

// Show clear button on edit
- (void)searchBarTextDidBeginEditing:(BQSearchBar *)aSearchBar
{
    if (aSearchBar.text.length > 0) 
    {
        [clearButton setAlpha:1.];
    }
}

- (BOOL)searchBarShouldBeginEditing:(BQSearchBar *)aSearchBar
{
    [super addGestureRecognizer:tap];
    return YES;
}

- (void)searchBar:(BQSearchBar *)aSearchBar textDidChange:(NSString *)searchText
{
    if (aSearchBar.text.length > 0) {
        [clearButton setAlpha:1.];
    }
    else {
        [clearButton setAlpha:0.];
    }
}

#pragma mark - Clear button & hide keyboard

- (IBAction)clearButtonAction:(id)sender 
{
    self.text = @"";
    [sender setAlpha:0.];
}

- (void)dismissKeyboard
{
    [super removeGestureRecognizer:tap];
    [self resignFirstResponder];
}

#pragma mark - Search button clicked

- (void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar
{    
    //if([customDelegate respondsToSelector:@selector(searchButtonClicked:)]) {
    [customDelegate searchButtonClicked:aSearchBar];
    //}
    
    [aSearchBar resignFirstResponder];
}

@end