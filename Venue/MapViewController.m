//
//  MapViewController.m
//  Venue
//
//  Created by Daniel Cintra on 3/18/14.
//  Copyright (c) 2014 Daniel Cintra. All rights reserved.
//

#import "MapViewController.h"
#import "DetailViewController.h"


@interface MapViewController () <MKMapViewDelegate>
@property NSString *KEY;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation MapViewController {
    dispatch_queue_t _pic_queue;
}
@synthesize query, currentLocation, placeObject;


-(void)setMapView:(MKMapView *)mapView{
    _mapView = mapView;
    self.mapView.delegate = self;
    [self.mapView setShowsUserLocation:YES];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 800, 800);
    [mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Check is query and coordinates have been passed along correctly
    NSLog(@"%@ latitude: %f",query, currentLocation.coordinate.latitude);
    
    
    [self queryGooglePlaces:query];
    
}


-(void) queryGooglePlaces: (NSString *) googleType {
    // Build the url string to send to Google
    NSString *typedQuery = [googleType stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?query=%@&location=%f,%f&radius=500&sensor=true&key=%@", typedQuery, currentLocation.coordinate.latitude, currentLocation.coordinate.longitude, GOOGLE_API_KEY];
    
    NSLog(@"url: %@", url);
    
    //Formulate the string as a URL object.
    NSURL *googleRequestURL=[NSURL URLWithString:url];
    
    // Retrieve the results of the URL.
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

-(void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    //The results from Google will be an array obtained from the NSDictionary object with the key "results".
    NSArray* places = [json objectForKey:@"results"];
    
    //Write out the data to the console.
    NSLog(@"Google Data: %@", places);
    [self plotAnnotations:places];
}



-(void) plotAnnotations: (NSArray *) data {
    for (id<MKAnnotation> annotation in _mapView.annotations) {
        if ([annotation isKindOfClass:[VenueAnnotation class]]) {
            [_mapView removeAnnotation:annotation];
        }
    }
    
    for (int i=0; i<[data count]; i++) {
        //Retrieve the NSDictionary object in each index of the array.
        NSDictionary* place = [data objectAtIndex:i];
        // 3 - There is a specific NSDictionary object that gives us the location info.
        NSDictionary *geo = [place objectForKey:@"geometry"];
        // Get the lat and long for the location.
        NSDictionary *loc = [geo objectForKey:@"location"];
        // 4 - Get your name and address info for adding to a pin.
        NSString *name=[place objectForKey:@"name"];
        
        NSString *address=[place objectForKey:@"formatted_address"];
        
        CLLocationCoordinate2D placeCoord;
        // Set the lat and long.
        placeCoord.latitude=[[loc objectForKey:@"lat"] doubleValue];
        placeCoord.longitude=[[loc objectForKey:@"lng"] doubleValue];
        
        if ([place objectForKey:@"photos"]){
            NSDictionary *photoDetail = [place objectForKey:@"photos"];
            if([photoDetail valueForKeyPath:@"photo_reference"][0]){
                NSString *photoReference=[photoDetail valueForKeyPath:@"photo_reference"][0];
                NSLog(@"PHOTO REFERENCE: %@", photoReference);
                NSString *photoUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=50&photoreference=%@&sensor=true&key=%@",photoReference, GOOGLE_API_KEY];
                NSLog(@"VENUE WITH PHOTO URL: %@", photoUrl);
                // 5 - Create a new annotation.
                placeObject = [[VenueAnnotation alloc]initWithName:name address:address coordinate:placeCoord photoURL:photoUrl];
            }
           
        } else {
            placeObject = [[VenueAnnotation alloc]initWithName:name address:address coordinate:placeCoord];
        }
            
            [self.mapView addAnnotation:placeObject];
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    // Define your reuse identifier.
    static NSString *identifier = @"VenueAnnotation";
    
    if ([annotation isKindOfClass:[VenueAnnotation class]]) {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 46, 46)];
        annotationView.leftCalloutAccessoryView = imageView;
        
        UIButton *annotationButton = [[UIButton alloc] init];
        [annotationButton setBackgroundImage:[UIImage imageNamed:@"ic_action_next_item"] forState:UIControlStateNormal];
        [annotationButton sizeToFit];
        annotationView.rightCalloutAccessoryView = annotationButton;
        [self updateLeftCalloutAccessory:annotationView];
        annotationView.animatesDrop = YES;
        
        
        return annotationView;
    }
    return nil;
}



- (void) updateLeftCalloutAccessory:(MKAnnotationView *)annotationView{
    UIImageView *imageView = nil;
    if([annotationView.leftCalloutAccessoryView isKindOfClass:[UIImageView class]]) {
        imageView = (UIImageView *) annotationView.leftCalloutAccessoryView;
    }
    if (imageView) {
        VenueAnnotation *venue = nil;
        if([annotationView.annotation isKindOfClass:[VenueAnnotation class]]){
            venue = (VenueAnnotation *) annotationView.annotation;
        }
        if (venue){
            NSLog(@"PHOTO URL: %@",venue.photoURL);
            
            
            
            _pic_queue = dispatch_queue_create("imageFetcher", nil);
            dispatch_async(_pic_queue, ^{
                
                UIImage *photo=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:venue.photoURL]]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"finished processing images");
                    imageView.image = photo;
                });
            });
            
        }
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    [self performSegueWithIdentifier:@"ShowDetails" sender:view];
}

- (void) prepareViewController:(id) vc forSegue: (NSString *) segueIdentifier toShowAnnotation: (id <MKAnnotation>) annotation
{
    VenueAnnotation *venue = nil;
    if([annotation isKindOfClass:[VenueAnnotation class]]){
        venue = (VenueAnnotation *) annotation;
    }
    if(venue){
        if(![segueIdentifier length] || [segueIdentifier isEqualToString:@"ShowDetails"]){
            if([vc isKindOfClass:[DetailViewController class]]){
                DetailViewController *dvc = (DetailViewController *) vc;
                dvc.name = venue.name;
            }
        }
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([sender isKindOfClass:[MKAnnotationView class]]){
        [self prepareViewController:segue.destinationViewController forSegue:segue.identifier toShowAnnotation:((MKAnnotationView *)sender).annotation];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
