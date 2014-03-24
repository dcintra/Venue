//
//  PlacesAPISearch.m
//  Venue
//
//  Created by Daniel Cintra on 3/22/14.
//  Copyright (c) 2014 Daniel Cintra. All rights reserved.
//

#import "PlacesAPISearch.h"


@implementation PlacesAPISearch

@synthesize venueArray;

-(NSMutableArray *)fetchedData:(NSData *)responseData currentLocation: (CLLocation*)  coord{
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
    NSMutableArray *venues = [NSMutableArray new];
    return venues = [self savePlaces:places currentLocation:coord];
}

-(NSMutableArray *) queryGooglePlaces: (NSString *) query withLatitude:(float) lat withLongitude:(float) lon currentLocation: (CLLocation*)  coord{
    // Build the url string to send to Google
    NSString *typedQuery = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?query=%@&location=%f,%f&radius=500&sensor=true&key=%@", typedQuery, lat, lon, GOOGLE_API_KEY];
    
    NSLog(@"url: %@", url);
    
    //Formulate the string as a URL object.
    NSURL *googleRequestURL=[NSURL URLWithString:url];
    
    // Retrieve the results of the URL.
    
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        venueArray = [self fetchedData:data currentLocation:coord];

    
        return venueArray;
}


-(NSMutableArray *) savePlaces: (NSArray *) data currentLocation: (CLLocation*)  coord{
    
    venueArray = [NSMutableArray new];
    
    for (int i=0; i<[data count]; i++) {
        //Retrieve the NSDictionary object in each index of the array.
        NSDictionary* place = [data objectAtIndex:i];
        
        //Coordinate and Location info
        NSDictionary *geo = [place objectForKey:@"geometry"];
        NSDictionary *loc = [geo objectForKey:@"location"];
        CLLocationCoordinate2D placeCoord;
        // Set the lat and long.
        placeCoord.latitude=[[loc objectForKey:@"lat"] doubleValue];
        placeCoord.longitude=[[loc objectForKey:@"lng"] doubleValue];
        CLLocation *venueCoord = [[CLLocation alloc] initWithLatitude:placeCoord.latitude longitude:placeCoord.longitude];
        //Distance from current Location
        CLLocationDistance distance = [coord distanceFromLocation:venueCoord];
        //Place name address
        NSString *name=[place objectForKey:@"name"];
        NSLog(@"Place name: %@", name);
        NSLog(@"Distance from current location: %f", distance);
        NSString *address=[place objectForKey:@"formatted_address"];
        //Rating
        NSString *rating=[place objectForKey:@"rating"];
        // Opening Hours
        NSDictionary *openingHours = [place objectForKey:@"opening_hours"];
        BOOL isopen = [[openingHours valueForKeyPath:@"open_now"] boolValue];
        //PriceLevel
        NSString *priceLevel=[place objectForKey:@"price_level"];
        
        Venue *placeObject;
        
        if ([place objectForKey:@"photos"]){
            NSDictionary *photoDetail = [place objectForKey:@"photos"];
            if([photoDetail valueForKeyPath:@"photo_reference"][0]){
                NSString *photoReference=[photoDetail valueForKeyPath:@"photo_reference"][0];
                NSString *photoUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=500&photoreference=%@&sensor=true&key=%@",photoReference, GOOGLE_API_KEY];
                // 5 - Create a new annotation.
                placeObject = [[Venue alloc]initWithName:name address:address coordinate:placeCoord photoURL:photoUrl rating:rating isOpen:isopen price:priceLevel];
                placeObject.distanceFromCurrentLocation = distance;
                [venueArray addObject:placeObject];
            }
            
        } else {
            placeObject = [[Venue alloc]initWithName:name address:address coordinate:placeCoord rating:rating isOpen:isopen price:priceLevel];
            placeObject.distanceFromCurrentLocation = distance;
            [venueArray addObject:placeObject];
        }
        
    }
    return venueArray;
}



@end
