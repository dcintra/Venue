//
//  VenueAnnotation.h
//  Venue
//
//  Created by Daniel Cintra on 3/20/14.
//  Copyright (c) 2014 Daniel Cintra. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface VenueAnnotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D _coordinate;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property NSString *name;
@property NSString *address;
@property NSString *rating;
@property BOOL isOpen;
@property NSString *photoURL;
@property NSString *price;
@property NSArray *type;


- initWithName:(NSString*)placename address:(NSString*)addr coordinate:(CLLocationCoordinate2D)coords photoURL:(NSString*)pic rating:(NSString*) ratingLevel isOpen:(BOOL) openHours price:(NSString*) priceLevel;
- initWithName:(NSString*)placename address:(NSString*)addr coordinate:(CLLocationCoordinate2D)coords rating:(NSString*) ratingLevel isOpen:(BOOL) openHours price:(NSString*) priceLevel;
@end
