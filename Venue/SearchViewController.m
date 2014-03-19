//
//  SearchViewController.m
//  Venue
//
//  Created by Daniel Cintra on 3/18/14.
//  Copyright (c) 2014 Daniel Cintra. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController () 
@end

@implementation SearchViewController

@synthesize locationManager, startLocation, currentLocation, query;

- (void)awakeFromNib {
    
    //put logo image in the navigationBar
    
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    currentLocation = [locations lastObject];
    NSDate* eventDate = currentLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    
    if (abs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              currentLocation.coordinate.latitude,
              currentLocation.coordinate.longitude);
    }

    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    startLocation = nil;
    
}




//remove keyboard when user touches the screen elsewhere
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    query = searchBar.text;
    [self performSegueWithIdentifier:@"DisplaySearchResults" sender:self];

    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
     MapViewController *ViewController = [segue destinationViewController];
    ViewController.query = query;
    ViewController.currentLocation = currentLocation;

}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    
//    MapViewController *ViewController = [segue destinationViewController];
//    ViewController.query = query;
//    ViewController.currentLocation = currentLocation;
//
//}


@end
