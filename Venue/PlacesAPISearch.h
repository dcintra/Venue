//
//  PlacesAPISearch.h
//  Venue
//
//  Created by Daniel Cintra on 3/22/14.
//  Copyright (c) 2014 Daniel Cintra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Venue.h"
#import <MapKit/MapKit.h>

#define GOOGLE_API_KEY @"AIzaSyDFuUDUhdTLk_WNs390u9kRSqZ3IDBGmJ8"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface PlacesAPISearch : NSObject

@property NSMutableArray *venueArray;

-(NSMutableArray *)fetchedData:(NSData *)responseData currentLocation: (CLLocation*)  coord;
-(NSMutableArray *) queryGooglePlaces: (NSString *) query withLatitude:(float) lat withLongitude:(float) lon currentLocation: (CLLocation*)  coord;
-(NSMutableArray *) savePlaces: (NSArray *) data currentLocation: (CLLocation*) coord;
@end
