//
//  ALTabBarView.m
//  ALCommon
//
//  Created by Andrew Little on 10-08-17.
//  Copyright (c) 2010 Little Apps - www.myroles.ca. All rights reserved.
//

#import "ALTabBarView.h"

@implementation ALTabBarView

@synthesize delegate = _delegate;
@synthesize selectedButton;

- (void)dealloc {
    
    _delegate = nil;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

//Let the delegate know that a tab has been touched
-(IBAction) touchButton:(id)sender {

    if( _delegate != nil && [_delegate respondsToSelector:@selector(tabWasSelected:withButton:)]) {                

        selectedButton = ((UIButton *)sender);        
        
        for(UIView *item in self.subviews)
        {
            if([item isKindOfClass:[UIButton class]] && (![item isEqual:selectedButton]))
            {
                [(UIButton *)item setEnabled:YES];            
            }
        }        
        
        [selectedButton setEnabled:NO];     
        [_delegate tabWasSelected:selectedButton.tag withButton:NO];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
