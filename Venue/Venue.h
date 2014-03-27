//
//  Venue.h
//  Venue
//
//  Created by Daniel Cintra on 3/22/14.
//  Copyright (c) 2014 Daniel Cintra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Venue : NSObject

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property NSString *name;
@property NSString *address;
@property NSString *rating;
@property BOOL isOpen;
@property NSString *photoURL;
@property NSString *price;
@property NSArray *type;
@property double distanceFromCurrentLocation;
@property UIImage *image;


- initWithName:(NSString*)placename address:(NSString*)addr coordinate:(CLLocationCoordinate2D)coords photoURL:(NSString*)pic rating:(NSString*) ratingLevel isOpen:(BOOL) openHours price:(NSString*) priceLevel;
- initWithName:(NSString*)placename address:(NSString*)addr coordinate:(CLLocationCoordinate2D)coords rating:(NSString*) ratingLevel isOpen:(BOOL) openHours price:(NSString*) priceLevel;

@end
