//
//  MapViewController.m
//  Venue
//
//  Created by Daniel Cintra on 3/18/14.
//  Copyright (c) 2014 Daniel Cintra. All rights reserved.
//

#import "MapViewController.h"
#import "DetailViewController.h"
#import "SearchViewController.h"
#import "NSString+AddressSubString.h"




@interface MapViewController () <MKMapViewDelegate, UITabBarControllerDelegate>

@property NSString *KEY;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)searchButton:(id)sender;

@end


@implementation MapViewController {
    dispatch_queue_t _pic_queue;
}

@synthesize currentLocation, placeObject;
@synthesize venueArray;

#pragma mark - ViewController setup

- (void)awakeFromNib {
    
    UIImageView* img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    self.navigationItem.titleView = img;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Check is query and coordinates have been passed along correctly
    TabBarViewController *tabBar = (TabBarViewController *)self.tabBarController;
    venueArray = tabBar.venueArray;
    
    [self plotAnnotations:venueArray];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Map setup

-(void)setMapView:(MKMapView *)mapView{
    _mapView = mapView;
    self.mapView.delegate = self;
    [self.mapView setShowsUserLocation:YES];
    TabBarViewController *tabBarController = (TabBarViewController *)self.tabBarController;
    currentLocation = tabBarController.currentLocation;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 800, 800);
    [mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}

#pragma mark - Annotation setup
-(void) plotAnnotations: (NSArray *) data {
    for (id<MKAnnotation> annotation in _mapView.annotations) {
        if ([annotation isKindOfClass:[VenueAnnotation class]]) {
            [_mapView removeAnnotation:annotation];
        }
    }
    
    for (int i=0; i<[data count]; i++) {
        //Retrieve the NSDictionary object in each index of the array.
        Venue *place= [data objectAtIndex:i];

        CLLocationCoordinate2D placeCoord;
        // Set the lat and long.
        placeCoord.latitude= place.coordinate.latitude;
        placeCoord.longitude= place.coordinate.longitude;
        
        //Place name address
        NSString *name= place.name;
        NSString *fullAddress = place.address;
        NSString *address= [fullAddress substringAddress:fullAddress];
        
        //Rating
        NSString *rating= place.rating;
        // Opening Hours
        BOOL isopen = place.isOpen;

        //PriceLevel
        NSString *priceLevel= place.price;
        
        //PhotoURL
        NSString *photoUrl = place.photoURL;
        
        if (place.photoURL){
            placeObject = [[VenueAnnotation alloc]initWithName:name address:address coordinate:placeCoord photoURL:photoUrl rating:rating isOpen:isopen price:priceLevel];
            _pic_queue = dispatch_queue_create("imageFetcher", nil);
            dispatch_async(_pic_queue, ^{
                
                UIImage *photo=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photoUrl]]];
                CGSize destinationSize = CGSizeMake(40, 40);
                UIGraphicsBeginImageContext(destinationSize);
                [photo drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
                UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"finished adding images to object");
                    placeObject.image = newImage;
                    place.image = newImage;
                });
            });
                
            } else {
            placeObject = [[VenueAnnotation alloc]initWithName:name address:address coordinate:placeCoord rating:rating isOpen:isopen price:priceLevel];
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
            //imageView.image = venue.image;
            NSLog(@"PHOTO URL: %@",venue.photoURL);
            
            _pic_queue = dispatch_queue_create("imageFetcher", nil);
            dispatch_async(_pic_queue, ^{
                
                UIImage *photo=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:venue.photoURL]]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"finished processing images");
                    venue.image = photo;
                    imageView.image = photo;
                });
            });
            
        }
    }
}

#pragma mark - Segue

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
                dvc.address = venue.address;
                dvc.photoURL = venue.photoURL;
                dvc.rating = venue.rating;
                dvc.isOpen = venue.isOpen;
                dvc.price = venue.price;
                dvc.photo = venue.image;
            }
        }
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([sender isKindOfClass:[MKAnnotationView class]]){
        [self prepareViewController:segue.destinationViewController forSegue:segue.identifier toShowAnnotation:((MKAnnotationView *)sender).annotation];
    }
}

- (IBAction)searchButton:(id)sender {
    [self performSegueWithIdentifier:@"SegueIdentifier" sender:sender];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    [self performSegueWithIdentifier:@"ShowDetails" sender:view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
