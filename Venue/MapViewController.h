//
//  MapViewController.h
//  Venue
//
//  Created by Daniel Cintra on 3/18/14.
//  Copyright (c) 2014 Daniel Cintra. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "VenueAnnotation.h"

#define GOOGLE_API_KEY @"AIzaSyDFuUDUhdTLk_WNs390u9kRSqZ3IDBGmJ8"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)



@interface MapViewController : UIViewController
@property CLLocation *currentLocation, *startLocation;
@property (strong, nonatomic) NSString *query;
@property VenueAnnotation *placeObject;


@end
