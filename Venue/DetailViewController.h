//
//  DetailViewController.h
//  Venue
//
//  Created by Daniel Cintra on 3/18/14.
//  Copyright (c) 2014 Daniel Cintra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
