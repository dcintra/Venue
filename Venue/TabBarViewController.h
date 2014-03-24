//
//  TabBarViewController.h
//  Venue
//
//  Created by Daniel Cintra on 3/21/14.
//  Copyright (c) 2014 Daniel Cintra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface TabBarViewController : UITabBarController

@property (strong, nonatomic) NSArray *array;
@property NSMutableArray *venueArray;
@property CLLocation *currentLocation;

@end
