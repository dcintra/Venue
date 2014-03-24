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
#import "Venue.h"
#import "ListViewController.h"
#import "TabBarViewController.h"
#define GOOGLE_API_KEY @"AIzaSyDFuUDUhdTLk_WNs390u9kRSqZ3IDBGmJ8"




@interface MapViewController : UIViewController
@property CLLocation *currentLocation, *startLocation;
@property VenueAnnotation *placeObject;
@property NSMutableArray *venueArray;

@end
