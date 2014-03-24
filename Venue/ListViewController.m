//
//  ListViewController.m
//  Venue
//
//  Created by Daniel Cintra on 3/18/14.
//  Copyright (c) 2014 Daniel Cintra. All rights reserved.
//

#import "ListViewController.h"
#import "MapViewController.h"


@interface ListViewController ()

@end

@implementation ListViewController{
    dispatch_queue_t _photo_queue;
}

@synthesize venueArray, sortedVenueArray;
@synthesize delegate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [venueArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"Cell";
    
    SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSMutableArray *leftUtilityButtons = [NSMutableArray new];
        [leftUtilityButtons sw_addUtilityButtonWithColor:[UIColor grayColor] icon:[UIImage imageNamed:@"ic_action_favorite"]];
    cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier
                                  containingTableView:tableView
                               leftUtilityButtons:leftUtilityButtons
                              rightUtilityButtons:nil];
        cell.delegate = self;
        
    }
    
    cell.textLabel.text = [venueArray[indexPath.row] name];
    cell.detailTextLabel.text = [venueArray[indexPath.row] address];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    if ([venueArray[indexPath.row] photoURL]){
        
        _photo_queue = dispatch_queue_create("imageFetcher", nil);
        dispatch_async(_photo_queue, ^{
            
            UIImage *photo=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[venueArray[indexPath.row] photoURL]]]];
            
            CGSize destinationSize = CGSizeMake(40, 40);
            UIGraphicsBeginImageContext(destinationSize);
            [photo drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
            UIImageView *New = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 100, 100)];
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            New.image = newImage;
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"processing images done");
                [cell.imageView setImage:newImage];
            });
        });
        
    }
    
    return cell;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    
    if(index == 0){
        //Cell is active
        if([cell.leftUtilityButtons[0] backgroundColor]== [UIColor grayColor]){
            [cell.leftUtilityButtons[0] setBackgroundColor:[UIColor greenColor]];
        //Deactivate cell
        }else{
            [cell.leftUtilityButtons[0] setBackgroundColor:[UIColor grayColor]];
            
        }
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    TabBarViewController *tabBar = (TabBarViewController *)self.tabBarController;
    
    NSSortDescriptor* sortByDistance = [NSSortDescriptor sortDescriptorWithKey:@"distanceFromCurrentLocation" ascending:YES];
    venueArray = tabBar.venueArray;
    [venueArray sortUsingDescriptors:[NSArray arrayWithObject:sortByDistance]];
    
    
    for (Venue *venue in venueArray) {
        NSLog(@"Venue name: %@", venue.name);
    }

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
