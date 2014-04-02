//
//  DetailViewController.h
//  Venue
//
//  Created by Daniel Cintra on 3/18/14.
//  Copyright (c) 2014 Daniel Cintra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VenueAnnotation.h"

@interface DetailViewController : UIViewController

@property NSString *name;
@property NSString *address;
@property NSString *rating;
@property BOOL isOpen;
@property NSString *photoURL;
@property NSString *price;
@property UIImage *photo;

@end
