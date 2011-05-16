//
//  AddLocationViewController.m
//  GreatNightOut
//
//  Created by Christopher Alford on 04/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddLocationViewController.h"
#import "GreatNightOutAppDelegate.h"
#import "LocationGetter.h"


@implementation AddLocationViewController

@synthesize locationTitle, phone, building_number, street, street_additional, area, apartment;

@synthesize addButton, kbCloseButton;

@synthesize newManagedObject, aContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //[scrollView setContentSize:CGSizeMake(320, 600)];
        //[scrollView setClipsToBounds:YES];
    }
    return self;
}

// Add button clicked
- (IBAction)addLocation:(id)sender {
    
    // Get your current location
    CLLocation *here = [(GreatNightOutAppDelegate *)[[UIApplication sharedApplication] delegate] lastKnownLocation];
    NSNumber *lat = [[NSNumber alloc] initWithFloat:here.coordinate.latitude];
    NSNumber *lng = [[NSNumber alloc] initWithFloat:here.coordinate.longitude];
    
    // Configure the new managed object.
    [newManagedObject setValue:@"L" forKey:@"status"]; // make this a new local item
    [newManagedObject setValue:self.locationTitle.text forKey:@"title"];
    [newManagedObject setValue:self.building_number.text forKey:@"building_number"];
    [newManagedObject setValue:self.street.text forKey:@"street"];
    [newManagedObject setValue:self.street_additional.text forKey:@"street_additional"];
    [newManagedObject setValue:self.area.text forKey:@"area"];
    [newManagedObject setValue:self.apartment.text forKey:@"apartment"];
    [newManagedObject setValue:self.phone.text forKey:@"phone"];
    
    [newManagedObject setValue:[NSDate date] forKey:@"expires"];
    [newManagedObject setValue:[NSNumber numberWithInt:0] forKey:@"id"];
    [newManagedObject setValue:lat forKey:@"lat"];
    [newManagedObject setValue:lng forKey:@"lng"];
    [newManagedObject setValue:[NSNumber numberWithFloat:0.00] forKey:@"distance"];
    [newManagedObject setValue: @"L" forKey:@"status"];
    
    // Save the context.
    NSError *error = nil;
    if (![aContext save:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    [self.view removeFromSuperview];
    [[super navigationController] popViewControllerAnimated:YES];

}


// Background tapped to close keyboard
- (IBAction)backgroundTouch:(id)sender {
    [self.view endEditing:YES];
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [scrollView setContentSize:CGSizeMake(320, 600)];
    [scrollView setClipsToBounds:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
