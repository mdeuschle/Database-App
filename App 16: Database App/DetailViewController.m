//
//  DetailViewController.m
//  App 16: Database App
//
//  Created by Matt Deuschle on 12/22/15.
//  Copyright © 2015 Matt Deuschle. All rights reserved.
//

#import "DetailViewController.h"
#import <CoreData/CoreData.h>

@interface DetailViewController ()
@property (strong, nonatomic) IBOutlet UITextField *carMakeTextField;
@property (strong, nonatomic) IBOutlet UITextField *carModelTextField;
@property (strong, nonatomic) IBOutlet UITextField *carYearTextField;

@end

@implementation DetailViewController

-(NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication]delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }

    return context;
}

@synthesize device;

- (void)viewDidLoad {
    [super viewDidLoad];

    // if statement for if data is coming into database
    if (self.device) {
        [self.carMakeTextField setText:[self.device valueForKey:@"text1"]];
        [self.carModelTextField setText:[self.device valueForKey:@"text2"]];
        [self.carYearTextField setText:[self.device valueForKey:@"text3"]];
    }
}

- (IBAction)saveButtonPressed:(id)sender {

    NSManagedObjectContext *context = [self managedObjectContext];

    //when user edits data, we need to update current info and not create new enty
    if (self.device) {
        [self.device setValue:self.carMakeTextField.text forKey:@"text1"];
        [self.device setValue:self.carModelTextField.text forKey:@"text2"];
        [self.device setValue:self.carYearTextField.text forKey:@"text3"];
    }
    // but what if user creates for first time? In that case, we need the "else" statment
    else
    {
        NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"Device" inManagedObjectContext:context];

        [newDevice setValue:self.carMakeTextField.text forKey:@"text1"];
        [newDevice setValue:self.carModelTextField.text forKey:@"text2"];
        [newDevice setValue:self.carYearTextField.text forKey:@"text3"];

    }

    NSError *error = nil;

    if (![context save:&error]) {
        NSLog(@"%@ %@", error, [error localizedDescription]);
    }
    // once user add data into database, we want to dismiss view and go back to tableview
    [self.navigationController popToRootViewControllerAnimated:YES];

}
- (IBAction)dismissKeyboard:(id)sender {

    [self resignFirstResponder];

}




@end
