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



@interface ListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate>

@property NSMutableArray *venueArray;
@property NSMutableArray *sortedVenueArray;
@property (nonatomic) id <SWTableViewCellDelegate> delegate;

@end
