//
//  VenueAnnotation.m
//  Venue
//
//  Created by Daniel Cintra on 3/20/14.
//  Copyright (c) 2014 Daniel Cintra. All rights reserved.
//

#import "VenueAnnotation.h"

@implementation VenueAnnotation

@synthesize name, address, isOpen, rating, photoURL, type, price;

@synthesize coordinate = _coordinate;


-(id)initWithName:(NSString*)placename address:(NSString*)addr coordinate:(CLLocationCoordinate2D)coords photoURL:(NSString*)pic rating:(NSString*) ratingLevel isOpen:(BOOL) openHours price:(NSString*) priceLevel{
    if(self = [super init]) {
        self.name = placename;
        self.address = addr;
        _coordinate = coords;
        self.photoURL = pic;
        self.rating = ratingLevel;
        self.isOpen = openHours;
        self.price = priceLevel;
    }
    
    return self;
}

-(id)initWithName:(NSString*)placename address:(NSString*)addr coordinate:(CLLocationCoordinate2D)coords rating:(NSString*) ratingLevel isOpen:(BOOL) openHours price:(NSString*) priceLevel{
    if(self = [super init]) {
        self.name = placename;
        self.address = addr;
        _coordinate = coords;
        self.rating = ratingLevel;
        self.isOpen = openHours;
        self.price = priceLevel;
    }
    
    return self;
}

-(NSString *)title {
        return name;
}

-(NSString *)subtitle {
    return address;
}




@end
