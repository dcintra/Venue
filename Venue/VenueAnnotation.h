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
@property NSNumber *rating;
@property NSString *isOpen;
@property NSString *photoURL;
@property NSArray *type;


- initWithName:(NSString*)placename address:(NSString*)addr coordinate:(CLLocationCoordinate2D)coords photoURL:(NSString*)pic;
- initWithName:(NSString*)placename address:(NSString*)addr coordinate:(CLLocationCoordinate2D)coords;
@end
