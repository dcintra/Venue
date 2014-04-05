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
@property (weak, nonatomic) IBOutlet UIImageView *circle;


@end

@implementation DetailViewController{
    dispatch_queue_t _photo_queue;
}

@synthesize name, address, isOpen, rating, photoURL, placeName, price;

- (void)awakeFromNib {

    UIImageView* img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    self.navigationItem.titleView = img;
    
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
        self.circle.image = [UIImage imageNamed:@"green_circle"];
    } else{
        self.isOpenOutlet.text = @"Nope";
        self.circle.image = [UIImage imageNamed:@"redcircle"];
    }
    
    self.placeName.text = name;
    self.addressOutlet.text = address;
    if (self.rating){
        self.ratingOutlet.text = [NSString stringWithFormat:@"%@/5",self.rating];
    } else{
        self.ratingOutlet.text = @"N/A";
    }
    
    NSInteger prix = [self.price integerValue];
    
    if (prix == 0) {
        self.priceLevel.text = @"$";
    } else if(prix == 1){
        self.priceLevel.text = @"$$";
    } else if(prix == 2){
        self.priceLevel.text = @"$$$";
    }else if(prix == 3){
        self.priceLevel.text = @"$$$$";
    }else if(prix == 4){
        self.priceLevel.text = @"$$$$$";
    }else{
        self.priceLevel.text = @"N/A";
    }
    
    self.venuePhoto.frame = CGRectMake(self.venuePhoto.frame.origin.x, self.venuePhoto.frame.origin.y, 321, 170);
    
    //check if we have a photo if not either grab one from the URL or use the stock image
    if (self.photo) {
        self.venuePhoto.image = self.photo;
    } else if (self.photoURL){
        _photo_queue = dispatch_queue_create("imageFetcher", nil);
        dispatch_async(_photo_queue, ^{
            
            UIImage *photo=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.photoURL]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"finished processing images");
                self.venuePhoto.image = photo;
            });
        });
    } else{
        self.venuePhoto.image = [UIImage imageNamed:@"photo_placeholder"];
    }
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
