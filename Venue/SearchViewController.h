//
//  SearchViewController.h
//  Venue
//
//  Created by Daniel Cintra on 3/18/14.
//  Copyright (c) 2014 Daniel Cintra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapViewController.h"
#import "ListViewController.h"
#import "PlacesAPISearch.h"
#import "Venue.h"
#import "SearchToFavorite.h"

@interface SearchViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate, UITabBarControllerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property CLLocation *currentLocation, *startLocation;
@property (strong, nonatomic) NSString *query;
@property PlacesAPISearch *apiSearch;
@property NSMutableArray *venueArray;
@property UIActivityIndicatorView *spinner;
@property UIDynamicAnimator* animator;
@property UIGravityBehavior* gravity;
@property UICollisionBehavior* collision;
@property UIButton *draggableLogo;

@end
