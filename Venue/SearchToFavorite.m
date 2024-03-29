//
//  SearchToFavorite.m
//  Venue
//
//  Created by Daniel Cintra on 4/4/14.
//  Copyright (c) 2014 Daniel Cintra. All rights reserved.
//
//Cannot segue to Favorites without using custom segue. Segue below is from http://stackoverflow.com/questions/19243131/xcode-custom-segue-animation
//

#import "SearchToFavorite.h"

@implementation SearchToFavorite

- (void)perform {
    UIViewController* source = (UIViewController *)self.sourceViewController;
    UIViewController* destination = (UIViewController *)self.destinationViewController;
    
    CGRect sourceFrame = source.view.frame;
    sourceFrame.origin.x = -sourceFrame.size.width;
    
    CGRect destFrame = destination.view.frame;
    destFrame.origin.x = destination.view.frame.size.width;
    destination.view.frame = destFrame;
    
    destFrame.origin.x = 0;
    
    [source.view.superview addSubview:destination.view];
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         source.view.frame = sourceFrame;
                         destination.view.frame = destFrame;
                     }
                     completion:^(BOOL finished) {
                         UIWindow *window = source.view.window;
                         [window setRootViewController:destination];
                     }];
}

@end
