//
//  SyncLocations.m
//  GreatNightOut
//
//  Created by Christopher Alford on 29/04/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
 @property (nonatomic, retain) NSNumber * id;
 @property (nonatomic, retain) NSString * title;
 @property (nonatomic, retain) NSString * phone;
 @property (nonatomic, retain) NSString * url;
 @property (nonatomic, retain) NSString * building_number;
 @property (nonatomic, retain) NSString * street;
 @property (nonatomic, retain) NSString * street_additional;
 @property (nonatomic, retain) NSString * area;
 @property (nonatomic, retain) NSString * apartment;
 //@property (nonatomic, retain) NSString * city;
 @property (nonatomic, retain) NSString * country;
 @property (nonatomic, retain) NSDecimalNumber * lat;
 @property (nonatomic, retain) NSDecimalNumber * lng;
 @property (nonatomic, retain) NSString * address_format;
 @property (nonatomic, retain) NSString * language;
 @property (nonatomic, retain) NSString * is_public;
 @property (nonatomic, retain) NSString * address_type;
 @property (nonatomic, retain) NSDecimalNumber * distance;
 @property (nonatomic, retain) NSDate * expires;
 
 @property (nonatomic, retain) NSString * status;
 */


#import "SyncLocations.h"
#import "GreatNightOutAppDelegate.h"

@implementation SyncLocations

@synthesize location, locations;

NSManagedObjectContext *context;

-(int) sync {
    int numberSynced = 0;
    
    // Get your array of managed objects with status L and fill in any missing data 
    NSArray *fetchedLocations = [[NSArray alloc]initWithArray:[self getStatusL]];
    if (0 < [fetchedLocations count])
    {
        // Create your array to convert to plist including any missing data
        self.locations = [[NSMutableArray alloc] init];
        for(NSManagedObject *object in fetchedLocations) {
            // Do your updates here
            location = [NSMutableDictionary new];
            
            [location setObject:[object valueForKey:@"id"] forKey:@"id"];
            [location setObject:[object valueForKey:@"title"] forKey:@"title"];
            if([object valueForKey:@"phone"])
                [location setObject:[object valueForKey:@"phone"] forKey:@"phone"];
            
            if([object valueForKey:@"url"])
                [location setObject:[object valueForKey:@"url"] forKey:@"url"];
            
            if([object valueForKey:@"building_number"])
                [location setObject:[object valueForKey:@"building_number"] forKey:@"building_number"];
            
            if([object valueForKey:@"street"])
                [location setObject:[object valueForKey:@"street"] forKey:@"street"];
            
            if([object valueForKey:@"street_additional"])
                [location setObject:[object valueForKey:@"street_additional"] forKey:@"street_additional"];
            
            if([object valueForKey:@"area"])
                [location setObject:[object valueForKey:@"area"] forKey:@"area"];
            
            if([object valueForKey:@"apartment"])
                [location setObject:[object valueForKey:@"apartment"] forKey:@"apartment"];
            
            //if([object valueForKey:@"city"])    
            //    [location setObject:[object valueForKey:@"city"] forKey:@"city"];
            
            if([object valueForKey:@"country"])
                [location setObject:[object valueForKey:@"country"] forKey:@"country"];
            
            [location setObject:[object valueForKey:@"lat"] forKey:@"lat"];
            [location setObject:[object valueForKey:@"lng"] forKey:@"lng"];
            
            if([object valueForKey:@"address_format"])
                [location setObject:[object valueForKey:@"address_format"] forKey:@"address_format"];
            
            if([object valueForKey:@"language"])
                [location setObject:[object valueForKey:@"language"] forKey:@"language"];
            
            if([object valueForKey:@"is_public"])
                [location setObject:[object valueForKey:@"is_public"] forKey:@"is_public"];
            
            //if([object valueForKey:@"address_type"])
            //    [location setObject:[object valueForKey:@"address_type"] forKey:@"address_type"];
            
            [location setObject:[object valueForKey:@"expires"] forKey:@"expires"];
            
            if([object valueForKey:@"status"])
                [location setObject:[object valueForKey:@"status"] forKey:@"status"];
            
            [locations addObject:location];  
        }
        
        // Send the plist
        NSArray *locationsUpdated = [[NSArray alloc]initWithArray:[self sendPlist]];
        
        // Now update the managed objects in the fetched data with the updated data
        for(location in locationsUpdated) {
            NSLog(@"Setting status to N and id to : %@ for name : %@", [location valueForKey:@"newID"], [location valueForKey:@"title"]);
            
            // Find the managed object with the same name
            NSArray *fetchedLocation;
            for(fetchedLocation in fetchedLocations) {
                NSString *fetchedTitle = [fetchedLocation valueForKey:@"title"];
                NSLog(@"Title : %@", fetchedTitle);
                if([fetchedTitle isEqualToString:[location valueForKey:@"title"]]) {
                    [fetchedLocation setValue:[location valueForKey:@"newID"] forKey:@"id"];
                    [fetchedLocation setValue:@"N" forKey:@"status"];
                    NSLog(@"Saving : %@ %@ %@", [fetchedLocation valueForKey:@"id"],
                          [fetchedLocation valueForKey:@"title"],
                          [fetchedLocation valueForKey:@"status"]);
                    
                    NSError *error;
                    if (![context save:&error]) {
                        NSLog(@"Saving changes Failed: %@", error);
                    } else {
                        NSLog(@"Saving changes completed!");
                        // Update sucessful
                        numberSynced++;
                    }
                    
                    
                }
            }

        }
        
    }
    
    return numberSynced;
}


- (NSArray *)getStatusL
{
    // Get only the location items with a status of L, sorted by name
    context = [(GreatNightOutAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"EventLocation" inManagedObjectContext:context];
    
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entityDescription];
    
    // Set example predicate and sort orderings...
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(status=%@)", @"L"];
    
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" 
                                                                   ascending:YES];
    
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    [sortDescriptor release];
    
    
    // and error object
    NSError *error = nil;
    return [context executeFetchRequest:request error:&error];
}

-(NSArray *) sendPlist {
    
    NSError *error;
    NSURLResponse *response;
    NSPropertyListFormat format;
    NSString *errorDesc = nil;
    
    NSData *sampleData = [NSPropertyListSerialization dataFromPropertyList:self.locations 
                                                                    format:kCFPropertyListBinaryFormat_v1_0 
                                                          errorDescription:&errorDesc];
    
    if(sampleData)
    {
        NSString *urlString = @"http://api.gno.mobi/ios/addMembersNewLocations";
        
        // setting up the request object now
        NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        
        [request addValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
        //[request addValue:@"real length" forHTTPHeaderField:@"Content-Length"];

        [request setHTTPBody:sampleData];
        
        // now lets make the connection to the web
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request 
                                                   returningResponse:&response 
                                                               error:&error];
        
        
        id pList = [NSPropertyListSerialization
                    propertyListFromData:returnData
                    mutabilityOption:NSPropertyListImmutable
                    format:&format 
                    errorDescription:&errorDesc];
        
        NSDictionary *d = (NSDictionary *)pList;
        NSArray *occasionEntries = (NSArray *)[d objectForKey:@"inserts"];
        
        return occasionEntries;

    }
    return nil;
    
}


- (void)dealloc
{
    [location release];
    [super dealloc];
}



@end


/*   OLD CODE ======================
 -(void) createPlist {
 
 // Get only the location items with a status of L
 context = [(GreatNightOutAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
 NSEntityDescription *entityDescription = [NSEntityDescription
 entityForName:@"EventLocation" inManagedObjectContext:context];
 NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
 [request setEntity:entityDescription];
 
 // Set example predicate and sort orderings...
 NSPredicate *predicate = [NSPredicate predicateWithFormat:
 @"(status=%@)", @"L"];
 [request setPredicate:predicate];
 
 //NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES];
 //[request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
 //[sortDescriptor release];
 
 
 // and error object
 NSError *error = nil;
 NSArray *fetchedLocations = [[NSArray alloc]initWithArray:[context executeFetchRequest:request error:&error]];
 
 if (0 < [fetchedLocations count])
 {
 // Create your array
 self.locations = [[NSMutableArray alloc] init];
 for(NSManagedObject *object in fetchedLocations) {
 // Do your updates here
 location = [NSMutableDictionary new];
 
 [location setObject:[object valueForKey:@"id"] forKey:@"id"];
 [location setObject:[object valueForKey:@"title"] forKey:@"title"];
 if([object valueForKey:@"phone"])
 [location setObject:[object valueForKey:@"phone"] forKey:@"phone"];
 
 if([object valueForKey:@"url"])
 [location setObject:[object valueForKey:@"url"] forKey:@"url"];
 
 if([object valueForKey:@"building_number"])
 [location setObject:[object valueForKey:@"building_number"] forKey:@"building_number"];
 
 if([object valueForKey:@"street"])
 [location setObject:[object valueForKey:@"street"] forKey:@"street"];
 
 if([object valueForKey:@"street_additional"])
 [location setObject:[object valueForKey:@"street_additional"] forKey:@"street_additional"];
 
 if([object valueForKey:@"area"])
 [location setObject:[object valueForKey:@"area"] forKey:@"area"];
 
 if([object valueForKey:@"apartment"])
 [location setObject:[object valueForKey:@"apartment"] forKey:@"apartment"];
 
 //if([object valueForKey:@"city"])    
 //    [location setObject:[object valueForKey:@"city"] forKey:@"city"];
 
 if([object valueForKey:@"country"])
 [location setObject:[object valueForKey:@"country"] forKey:@"country"];
 
 [location setObject:[object valueForKey:@"lat"] forKey:@"lat"];
 [location setObject:[object valueForKey:@"lng"] forKey:@"lng"];
 
 if([object valueForKey:@"address_format"])
 [location setObject:[object valueForKey:@"address_format"] forKey:@"address_format"];
 
 if([object valueForKey:@"language"])
 [location setObject:[object valueForKey:@"language"] forKey:@"language"];
 
 if([object valueForKey:@"is_public"])
 [location setObject:[object valueForKey:@"is_public"] forKey:@"is_public"];
 
 //if([object valueForKey:@"address_type"])
 //    [location setObject:[object valueForKey:@"address_type"] forKey:@"address_type"];
 
 [location setObject:[object valueForKey:@"expires"] forKey:@"expires"];
 
 if([object valueForKey:@"status"])
 [location setObject:[object valueForKey:@"status"] forKey:@"status"];
 
 // Not used, just test values
 //[location setObject:[NSNumber numberWithInt:3000] forKey:@"Number Available"];
 //[location setObject:[NSNumber numberWithDouble:0.7] forKey:@"Weight"];
 //[location setObject:[NSNumber numberWithBool:YES] forKey:@"In Stock"];
 //NSDate *date = [NSDate date];
 //[location setObject:date forKey:@"Date Received"];
 NSLog(@"%@ %@ %@ %@ %@ %@ %@",
 [location valueForKey:@"id"],
 [location valueForKey:@"title"],
 [location valueForKey:@"lat"],
 [location valueForKey:@"lng"],
 [location valueForKey:@"street"],
 [location valueForKey:@"phone"],
 [location valueForKey:@"url"]
 );
 
 [locations addObject:location];  
 }
 }
 
 }
 
 -(void) batchUpdate {
 
 // Get only the location items with an id of 0
 context = [(GreatNightOutAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
 NSEntityDescription *entityDescription = [NSEntityDescription
 entityForName:@"EventLocation" inManagedObjectContext:context];
 NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
 [request setEntity:entityDescription];
 
 // Set example predicate and sort orderings...
 NSPredicate *predicate = [NSPredicate predicateWithFormat:
 @"(id > %@)", [NSNumber numberWithInt:1000]];
 [request setPredicate:predicate];
 
 //NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES];
 //[request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
 //[sortDescriptor release];
 
 
 // and error object
 NSError *error = nil;
 NSArray *fetchedLocations = [[NSArray alloc]initWithArray:[context executeFetchRequest:request error:&error]];
 int i = 10000000;
 if (fetchedLocations != nil)
 {
 // Create your array
 for(NSManagedObject *object in fetchedLocations) {
 // Do your updates here
 [object setValue:[NSNumber numberWithInt:i++] forKey:@"id"];
 [object setValue:@"L" forKey:@"status"];
 NSLog(@"%@",[object valueForKey:@"id"]);
 }
 }
 if (![context save:&error]) {
 NSLog(@"Saving changes Failed: %@", error);
 } else {
 NSLog(@"Saving changes completed!");
 }
 }

 */
