//
//  GreatNightOutAppDelegate.h
//  GreatNightOut
//
//  Created by Christopher Alford on 28/04/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationGetter.h"
#import <CoreData/CoreData.h>
//#import "EventLocationNavController"
//#import "EventsNavController"
//#import "FriendsNavController"
//#import "InvitationsNavController"

@interface GreatNightOutAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, LocationGetterDelegate> {
    
    CLLocation *lastKnownLocation;

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) CLLocation *lastKnownLocation;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
