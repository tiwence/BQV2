//
//  BQViewController.m
//  BurgerQuest
//
//  Created by Sébastien POUDAT on 01/04/12.
//  Copyright (c) 2012 Milky-Interactive. All rights reserved.
//

#import "BQViewController.h"
#import "BurgerQuestAppDelegate.h"

@implementation BQViewController

@synthesize apiEngine;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    apiEngine = [[BurgerQuestAppDelegate sharedAppDelegate] apiEngine];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

@end
