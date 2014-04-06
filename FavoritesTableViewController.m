//
//  FavoritesTableViewController.m
//  Venue
//
//  Created by Daniel Cintra on 3/26/14.
//  Copyright (c) 2014 Daniel Cintra. All rights reserved.
//

#import "FavoritesTableViewController.h"

@interface FavoritesTableViewController ()
- (IBAction)searchButton:(id)sender;

@end

@implementation FavoritesTableViewController

@synthesize managedObjectContext;
@synthesize managedObjectModel;


#pragma mark - View Setup

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Check if CoreData is empty, if so show message

    id appDelegate = [[UIApplication sharedApplication] delegate];
    managedObjectContext = [appDelegate managedObjectContext];
    managedObjectModel = [appDelegate managedObjectModel];
    NSFetchRequest *fetchAll = [managedObjectModel fetchRequestTemplateForName:@"FetchAll"];
    NSError *error = nil;
    NSArray *fetchedObj = [managedObjectContext executeFetchRequest:fetchAll error:&error];
    if(!fetchedObj || !fetchedObj.count){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Favorite Places?" message:@"Surely you have some places you like. Search and bookmark your favorite places!" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alert show];
    }

    
}

- (IBAction)searchButton:(id)sender {
    [self performSegueWithIdentifier:@"BackToSearch" sender:sender];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id appDelegate = [[UIApplication sharedApplication] delegate];
    managedObjectContext = [appDelegate managedObjectContext];
    managedObjectModel = [appDelegate managedObjectModel];
    
    //Check Existing data
    
    NSFetchRequest *fetchAll = [managedObjectModel fetchRequestTemplateForName:@"FetchAll"];
    
    NSError *error = nil;
    NSArray *fetchedObj = [managedObjectContext executeFetchRequest:fetchAll error:&error];
    
    return [fetchedObj count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    id appDelegate = [[UIApplication sharedApplication] delegate];
    managedObjectContext = [appDelegate managedObjectContext];
    managedObjectModel = [appDelegate managedObjectModel];
    
    //Check Existing data
    
    NSFetchRequest *fetchAll = [managedObjectModel fetchRequestTemplateForName:@"FetchAll"];
    
    NSError *error = nil;
    NSArray *fetchedObj = [managedObjectContext executeFetchRequest:fetchAll error:&error];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSLog(@"FETCHING EXISTING ENTRIES");
    for (Favorites *fav in fetchedObj) {
        
        NSLog(@"Name: %@ and Address: %@", fav.name, fav.address);
    }
    
    UIImage *photo = [UIImage imageWithData:[fetchedObj[indexPath.row] photo]];
    cell.imageView.image =photo;
    cell.textLabel.text = [fetchedObj[indexPath.row] name];
    NSString *address = (NSString*) [fetchedObj[indexPath.row] address];
    
    cell.accessoryView = [[UIImageView alloc]initWithImage: [UIImage imageNamed:@"star"]];
    cell.detailTextLabel.text = address;
    
    return cell;
}


//Enable deleting cells from table
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        NSError *error = nil;
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

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
    }
}

//Don't highlight cell when tapped
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}


@end
