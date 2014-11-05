//
//  BQActivityProvider.m
//  BurgerQuestV2
//
//  Created by Térence Marill on 19/05/2014.
//  Copyright (c) 2014 BurgerQuest. All rights reserved.
//

#import "BQActivityProvider.h"

@implementation BQActivityProvider

-(id)initWithBurger:(Burger *)_burger {
    self = [self init];
    if (self != nil) {
        burger = _burger;
    }
    return self;
}

- (id) activityViewController:(UIActivityViewController *)activityViewController
          itemForActivityType:(NSString *)activityType {
    if ( [activityType isEqualToString:UIActivityTypePostToTwitter] )
        return [NSString stringWithFormat:@"Check %@ by %@. The quest continues on @burgerquestApp", burger.name, burger.place.name];
    if ( [activityType isEqualToString:UIActivityTypePostToFacebook] )
        return [NSString stringWithFormat:@"Check %@ by %@. The quest continues on @burgerquestApp", burger.name, burger.place.name];
    if ( [activityType isEqualToString:UIActivityTypeMail] )
        return [NSString stringWithFormat:@"Check %@ by %@. The quest continues on @burgerquestApp", burger.name, burger.place.name];
    return nil;
}

- (id) activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController {
    return @"";
}

@end

@implementation BQActivityIcon

- (NSString *)activityType { return @"it.albertopasca.myApp"; }
- (NSString *)activityTitle { return @"Open Maps"; }
- (UIImage *) activityImage { return [UIImage imageNamed:@"lines.png"]; }
- (BOOL) canPerformWithActivityItems:(NSArray *)activityItems { return YES; }
- (void) prepareWithActivityItems:(NSArray *)activityItems { }
- (UIViewController *) activityViewController { return nil; }
- (void) performActivity {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"maps://"]];
}

@end
