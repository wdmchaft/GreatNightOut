//
//  AddLocationViewController.h
//  GreatNightOut
//
//  Created by Christopher Alford on 04/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AddLocationViewController : UIViewController {
    IBOutlet UITextField *locationTitle; // varchar(254);
	IBOutlet UITextField *building_number; // varchar(15)
    IBOutlet UITextField *street; // varchar(150)
    IBOutlet UITextField *street_additional; // varchar(150)
    IBOutlet UITextField *area; // varchar(100)
    IBOutlet UITextField *apartment; // varchar(30)
    //NSString *description; // int(11)
    IBOutlet UITextField *phone; // varchar(40)
    IBOutlet UIButton *addButton;
    IBOutlet UIButton *kbCloseButton;
    
    IBOutlet UIScrollView *scrollView;
    
    /*
    NSString *url; // varchar(254)
    
    
    NSNumber *city; // int(11)
    NSNumber *country; // char(2)
    NSNumber *lat; // decimal(10,0)
    NSNumber *lng; // decimal(10,0)
    NSString *address_format; // char(2)
    NSString *language; // char(2)
    NSNumber *owner; // int(11)
    NSString *verified; // char(1)
    NSString *is_public; // char(1)
    NSNumber *address_type; // int(11)
    NSDate *last_updated; // datetime
    NSNumber *last_updated_by; // int(11)
     */
    
    NSManagedObject *newManagedObject;
    NSManagedObjectContext *aContext;
}

// Outlets for view

@property (nonatomic, retain) IBOutlet UITextField *locationTitle;
@property (nonatomic, retain) IBOutlet UITextField *building_number;
@property (nonatomic, retain) IBOutlet UITextField *street;
@property (nonatomic, retain) IBOutlet UITextField *street_additional;
@property (nonatomic, retain) IBOutlet UITextField *area;
@property (nonatomic, retain) IBOutlet UITextField *apartment;
@property (nonatomic, retain) IBOutlet UITextField *phone;
@property (nonatomic, retain) IBOutlet UIButton *addButton;
@property (nonatomic, retain) IBOutlet UIButton *kbCloseButton;

@property (nonatomic, retain) NSManagedObject *newManagedObject;
@property (nonatomic, retain) NSManagedObjectContext *aContext;


// Actions
- (IBAction)addLocation:(id)sender;
- (IBAction)backgroundTouch:(id)sender;

@end
