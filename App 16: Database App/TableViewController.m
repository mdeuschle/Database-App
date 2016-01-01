//
//  TableViewController.m
//  App 16: Database App
//
//  Created by Matt Deuschle on 12/22/15.
//  Copyright © 2015 Matt Deuschle. All rights reserved.
//

#import "TableViewController.h"
#import <CoreData/CoreData.h>
#import "DetailViewController.h"

@interface TableViewController ()

//create array to store data
@property (strong) NSMutableArray *devices;

@end

@implementation TableViewController

//set up delegate to run context
-(NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication]delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSManagedObjectContext *managedContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Device"];
    self.devices = [[managedContext executeFetchRequest:fetchRequest error:nil] mutableCopy];

    // refresh data
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.devices.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSManagedObjectModel *device = [self.devices objectAtIndex:indexPath.row];

    // display text in cell on the right (cell.textLabel)
    [cell.textLabel setText:[NSString stringWithFormat:@"%@ %@", [device valueForKey:@"text1"], [device valueForKey:@"text2"]]];

    // now display text for the detail (cell.detailTextLabel)
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@", [device valueForKey:@"text3"]]];

    return cell;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    // first, dive into our data to get ready to edit
        NSManagedObjectContext *context = [self managedObjectContext];

    if (editingStyle == UITableViewCellEditingStyleDelete) {

        [context deleteObject:[self.devices objectAtIndex:indexPath.row]];

        NSError *error = nil;

        if (![context save:&error]) {
            NSLog(@"%@ %@", error, [error localizedDescription]);
        }

        // now remove device from our tableview
        [self.devices removeObjectAtIndex:indexPath.row];

        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue identifier] isEqualToString:@"UpdateCar"]) {
        NSManagedObjectModel *selectedDevice = [self.devices objectAtIndex:[[self.tableView indexPathForSelectedRow]row]];
        DetailViewController *dvc = segue.destinationViewController;
        dvc.device = selectedDevice;
    }
}


@end
