//
//  BQChildViewController.m
//  BurgerQuest
//
//  Created by Sébastien POUDAT on 01/04/12.
//  Copyright (c) 2012 Milky-Interactive. All rights reserved.
//

#import "BQChildViewController.h"

@implementation BQChildViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)backAction:(id)sender 
{
    [self.navigationController popViewControllerAnimated:YES];    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        
    // Making a custom button
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];    
    [backBtn setImage:[UIImage imageNamed:@"Back-Button.png"] forState:UIControlStateNormal];    
    [backBtn setImage:[UIImage imageNamed:@"Back-Button-Highlighted.png"] forState:UIControlStateHighlighted];    
    [backBtn setFrame:CGRectMake(0, 19, 60, 31)];
    
    // Binding custom target & action to the button
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // Nesting the button in a UIView to position the button anywhere !
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 70)];
    [backView addSubview:backBtn];
    
    // Nesting all of these into a UIBarButtonItem
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    
    // Overwrite original backbutton (self.navigationItem.backBarButtonItem 
    self.navigationItem.leftBarButtonItem = backItem;    
    [self.navigationItem.leftBarButtonItem setTitle:@"Back"];    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
