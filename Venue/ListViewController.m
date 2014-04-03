//
//  ListViewController.m
//  Venue
//
//  Created by Daniel Cintra on 3/18/14.
//  Copyright (c) 2014 Daniel Cintra. All rights reserved.
//

#import "ListViewController.h"
#import "MapViewController.h"
#import "DetailViewController.h"
#import "Favorites.h"
#import "SWTableViewCell.h"

#define favColor [UIColor colorWithRed:255/255.0f green:141/255.0f blue:166/255.0f alpha:1.0f]
@interface ListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *myTable;

@end

@implementation ListViewController



@synthesize venueArray, sortedVenueArray;
@synthesize delegate;
@synthesize managedObjectContext;
@synthesize managedObjectModel;



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
    SWTableViewCell *cell;
    id appDelegate = [[UIApplication sharedApplication] delegate];
    managedObjectContext = [appDelegate managedObjectContext];
    

    NSString *placeName = [venueArray[indexPath.row] name];
    NSString *placeAddress = (NSString*) [venueArray[indexPath.row] address];
    NSString *name = [self nameofExistingVenue:managedObjectContext withName:placeName];
    
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
    

    if([placeName isEqualToString:name]){
        [cell.leftUtilityButtons[0] setBackgroundColor:favColor];
    }
    
    
    UIImage *photo = [venueArray[indexPath.row] image];

    if(photo){
        UIImageView *New = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 100, 100)];
        New.image = photo;
        [cell.imageView setImage:photo];
    }else{
        [cell.imageView setImage:[UIImage imageNamed:@"ic_action_place"]];
    }
 
    cell.textLabel.text = placeName;
    cell.detailTextLabel.text = placeAddress;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;

    

    return cell;
}


- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    
    
    id appDelegate = [[UIApplication sharedApplication] delegate];
    managedObjectContext = [appDelegate managedObjectContext];
    managedObjectModel = [appDelegate managedObjectModel];

    NSFetchRequest *fetchAll = [managedObjectModel fetchRequestTemplateForName:@"FetchAll"];
    NSError *error = nil;
    NSArray *fetchedObj = [managedObjectContext executeFetchRequest:fetchAll error:&error];
    
    if (fetchedObj == nil) {
        NSLog(@"Problem fetching data");
    } else{
        for (Favorites *fav in fetchedObj) {
            NSLog(@"Name: %@ and Address: %@", fav.name, fav.address);
        }
    }
    
    
    if(index == 0){

//SAVE
        if([cell.leftUtilityButtons[0] backgroundColor]== [UIColor grayColor]){
            //store venue information
            Favorites *favoriteVenue= [NSEntityDescription
                                       insertNewObjectForEntityForName:@"Favorites"
                                       inManagedObjectContext:[self managedObjectContext]];
            
            favoriteVenue.name = cell.textLabel.text;
            favoriteVenue.address = cell.detailTextLabel.text;

            if(! [[self managedObjectContext] save:&error]){
                NSLog(@"Error occurred when saving %@", error);
            }
            
            //change color of button when saved
            [cell.leftUtilityButtons[0] setBackgroundColor: favColor];
        }
//DELETE
        else {
            
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"Favorites" inManagedObjectContext:managedObjectContext];
            [fetchRequest setEntity:entity];
            // Specify criteria for filtering which objects to fetch
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@ AND address == %@", cell.textLabel.text,cell.detailTextLabel.text];
            [fetchRequest setPredicate:predicate];
            
            NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
            if (fetchedObjects == nil) {
                NSLog(@"Problem fetching data");
            }
            
            for(NSManagedObject *mOC in fetchedObjects){
                [managedObjectContext deleteObject:mOC];
            }
            
            
            if(! [managedObjectContext save:&error]){
                NSLog(@"Error occurred when deleting object %@", error);
            }
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

//Check if venue exists in CoreData
-(BOOL) venueExistsInFavorites: (NSString *) venueName andAddress: (NSString *) add{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Favorites" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@ AND address == %@", venueName, add];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if(fetchedObjects == nil){
        return NO;
    } else{
        return YES;
    }
}

//Check if venue exists in CoreData
-(NSString *) nameofExistingVenue: (NSManagedObjectContext *) mOC withName: (NSString *) placeName{
    
    NSString *name;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Favorites" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", placeName];
    [fetchRequest setPredicate:predicate];
    
    
    NSError *error = nil;
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"Error");
        name = nil;
    } else {
        for (Favorites *fav in fetchedObjects) {
            name= fav.name;
        }
    }
    
        return name;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"helllo");
    [self performSegueWithIdentifier:@"TableItemToDetail" sender:self];
}



#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"TableItemToDetail"]){
        NSIndexPath *myIndexPath = [self.myTable
                                    indexPathForSelectedRow];
        DetailViewController *dvc = segue.destinationViewController;;
        dvc.name = [venueArray[myIndexPath.row] name];
        dvc.address = (NSString *)[venueArray[myIndexPath.row] address];
        dvc.photoURL = [venueArray[myIndexPath.row] photoURL];
        dvc.rating = [venueArray[myIndexPath.row] rating];
        dvc.isOpen = [venueArray[myIndexPath.row] isOpen];
        dvc.price = [venueArray[myIndexPath.row] price];
    }
    
}




@end
