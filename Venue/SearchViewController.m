//
//  SearchViewController.m
//  Venue
//
//  Created by Daniel Cintra on 3/18/14.
//  Copyright (c) 2014 Daniel Cintra. All rights reserved.
//

#import "SearchViewController.h"
#import "TabBarViewController.h"


@interface SearchViewController () 
@end

@implementation SearchViewController

@synthesize locationManager, startLocation, currentLocation, query;
@synthesize apiSearch, venueArray, spinner, gravity, animator, collision, draggableLogo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //set background to NY landscape
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"nysmall1.png"]]];
    self.locationManager = [[CLLocationManager alloc] init];
    
    //Start location manager
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    startLocation = nil;
    
    
    //if user hasn't seen the draggable button show it to them
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"hasSeenDraggableButton"]){
        draggableLogo = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
        [draggableLogo setImage:[UIImage imageNamed:@"logo"] forState:UIControlStateNormal];
        [self.view addSubview:draggableLogo];
        animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        gravity = [[UIGravityBehavior alloc] initWithItems:@[draggableLogo]];
        [animator addBehavior:gravity];
        collision = [[UICollisionBehavior alloc]
                     initWithItems:@[draggableLogo]];
        collision.translatesReferenceBoundsIntoBoundary = YES;
        [animator addBehavior:collision];
        UIPanGestureRecognizer *panRecognizer;
        panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                action:@selector(dragButton:)];
        panRecognizer.cancelsTouchesInView = YES;
        [draggableLogo addGestureRecognizer:panRecognizer];
        [draggableLogo addTarget:self action:@selector(draggableButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    
   
    
}

#pragma mark - Location Manager

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    currentLocation = [locations lastObject];
}


#pragma mark - SearchBar config
//remove keyboard when user touches the screen elsewhere
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

//When search button is clicked pass the entry to the MapViewController to search for places close by and drop the pins
-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [searchBar addSubview: spinner];
    spinner.center = [searchBar convertPoint:searchBar.center fromView:searchBar.superview];
    [spinner startAnimating];
    [searchBar setShowsCancelButton:YES];
    query = searchBar.text;
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        if(query){
            apiSearch = [PlacesAPISearch new];
            venueArray = [NSMutableArray new];
            
            venueArray = [apiSearch queryGooglePlaces:query withLatitude:currentLocation.coordinate.latitude withLongitude:currentLocation.coordinate.longitude currentLocation:currentLocation];
            [locationManager stopUpdatingLocation];
            [self performSegueWithIdentifier:@"SearchPerformed" sender:self];
        }
        
    });
    
    
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"Cancel button clicked");
    query = nil;
    [spinner stopAnimating];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO];
    
}

-(void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"Booksmark button clicked");

    [self performSegueWithIdentifier:@"Bookmarks" sender:self];
}


#pragma mark - Draggable Button Methods

- (void)dragButton:(UIPanGestureRecognizer *)recognizer {
    UIButton *button = (UIButton *)recognizer.view;
    CGPoint translation = [recognizer translationInView:button];
    button.center = CGPointMake(button.center.x + translation.x, button.center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:button];
}

- (IBAction)draggableButtonTapped:(id)sender {
    NSLog(@"button was tapped");
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Welcome!" message:@"Search, save and check out places you might want to go to" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasSeenDraggableButton"];
    draggableLogo.hidden = YES;
}

#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"SearchPerformed"]){
        TabBarViewController *tabBarController = segue.destinationViewController;
        tabBarController.venueArray = self.venueArray;
        tabBarController.currentLocation = self.currentLocation;
    }
}


@end
