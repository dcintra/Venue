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
#define favColor [UIColor colorWithRed:255/255.0f green:222/255.0f blue:94/255.0f alpha:1.0f]
@interface ListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *myTable;
- (IBAction)searchButton:(id)sender;

@end

@implementation ListViewController



@synthesize venueArray, sortedVenueArray;
@synthesize delegate;
@synthesize managedObjectContext;
@synthesize managedObjectModel;

#pragma mark - Controller setup
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


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    
    [_myTable reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    TabBarViewController *tabBar = (TabBarViewController *)self.tabBarController;
    
    //sort the cells by distance
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

#pragma mark - TableView setup

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
    NSString *name = [self nameofExistingVenue:placeName withAddress:placeAddress andContext:managedObjectContext];
    NSLog(@"name %@",name);
    
    //set up cell with leftutility button
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
    //check if the place is already stored in CoreData, if so make sure the utility button is highlighted
    if([placeName isEqualToString:name]){
        [cell.leftUtilityButtons[0] setBackgroundColor:favColor];
    }
    
    //check if there's an image for the place
    UIImage *photo = [venueArray[indexPath.row] image];
    
    if(photo){
        UIImageView *New = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 100, 100)];
        New.image = photo;
        [cell.imageView setImage:photo];
    }else{
        [cell.imageView setImage:[UIImage imageNamed:@"ic_action_place"]];
    }
    
    //finish cell setup
    cell.textLabel.text = placeName;
    cell.detailTextLabel.text = placeAddress;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    
    
    return cell;
}

#pragma mark - Swipeable TableView setup

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
            NSData *pic = UIImagePNGRepresentation(cell.imageView.image);
            favoriteVenue.photo = pic;
            
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
            // Find and delete all places in the db that match the cell contents
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
            // change color of button when removed from favorites
            [cell.leftUtilityButtons[0] setBackgroundColor:[UIColor grayColor]];
            
        }
    }
    
}



#pragma mark - CoreDate Methods

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
-(NSString *) nameofExistingVenue: (NSString *) placeName withAddress: (NSString *) addr andContext:(NSManagedObjectContext *) mOC{
    
    NSString *name;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Favorites" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@ AND address == %@", placeName, addr];
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


#pragma mark - Segue

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
- (IBAction)searchButton:(id)sender {
    [self performSegueWithIdentifier:@"Search" sender:sender];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"TableItemToDetail" sender:self];
}

@end
