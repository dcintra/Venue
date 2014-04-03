//
//  DetailViewController.m
//  Venue
//
//  Created by Daniel Cintra on 3/18/14.
//  Copyright (c) 2014 Daniel Cintra. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *placeName;
@property (weak, nonatomic) IBOutlet UIImageView *venuePhoto;
@property (weak, nonatomic) IBOutlet UILabel *addressOutlet;
@property (weak, nonatomic) IBOutlet UILabel *priceLevel;
@property (weak, nonatomic) IBOutlet UILabel *ratingOutlet;
@property (weak, nonatomic) IBOutlet UILabel *isOpenOutlet;


@end

@implementation DetailViewController{
    dispatch_queue_t _photo_queue;
}

@synthesize name, address, isOpen, rating, photoURL, placeName, price;

- (void)awakeFromNib {
    
    //put logo image in the navigationBar
    
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    if(self.isOpen){
        self.isOpenOutlet.text = @"Yup";
    } else{
        self.isOpenOutlet.text = @"Nope";
    }
    
    self.placeName.text = name;
    self.addressOutlet.text = address;
    if (self.rating){
        self.ratingOutlet.text = [NSString stringWithFormat:@"%@",self.rating];
    } else{
        self.ratingOutlet.text = @"No ratings. Take a chance?";
    }
    
    self.priceLevel.text = [NSString stringWithFormat:@"%@",self.price];
    
    if (self.photo) {
        self.venuePhoto.image = self.photo;
    } else {
        _photo_queue = dispatch_queue_create("imageFetcher", nil);
        dispatch_async(_photo_queue, ^{
            
            UIImage *photo=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.photoURL]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"finished processing images");
                self.venuePhoto.image = photo;
            });
        });
    }
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
