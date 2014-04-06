//
//  Favorites.h
//  Venue
//
//  Created by Daniel Cintra on 3/24/14.
//  Copyright (c) 2014 Daniel Cintra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Favorites : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * photo;

@end
