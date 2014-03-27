//
//  FavoritesTableViewController.h
//  Venue
//
//  Created by Daniel Cintra on 3/26/14.
//  Copyright (c) 2014 Daniel Cintra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Favorites.h"

@interface FavoritesTableViewController : UITableViewController

@property NSManagedObjectContext *managedObjectContext;
@property NSManagedObjectModel  *managedObjectModel;

@end
