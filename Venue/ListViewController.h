//
//  ListViewController.h
//  Venue
//
//  Created by Daniel Cintra on 3/18/14.
//  Copyright (c) 2014 Daniel Cintra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Venue.h"
#import "TabBarViewController.h"
#import "SWTableViewCell.h"
#import "AppDelegate.h"
#import "ImageDownloader.h"


@interface ListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate>

@property NSMutableArray *venueArray;
@property NSMutableArray *sortedVenueArray;
@property (nonatomic) id <SWTableViewCellDelegate> delegate;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;

-(BOOL)venueExistsInFavorites: (NSManagedObjectContext *) mOC withName: (NSString *) venueName andAddress: (NSString *) add;

@end
