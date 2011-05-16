//
//  NearByLocations.m
//  GreatNightOut
//
//  Created by Christopher Alford on 20/04/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NearByLocations.h"
#import "GreatNightOutAppDelegate.h"
#import "EventLocation.h"


@implementation NearByLocations

NSPropertyListFormat format;
NSString *errorDesc = nil;
NSError *error;
NSURLResponse *response;

NSManagedObjectContext *context;

-(void) getNearby:(CLLocation *)withLocation {
    
    // Location Data
    
    NSNumber *lat = [[NSNumber alloc] initWithFloat:withLocation.coordinate.latitude];
    NSNumber *lng = [[NSNumber alloc] initWithFloat:withLocation.coordinate.longitude];
    
    // Read your plist
    NSString *serverURL = [NSString stringWithFormat:@"http://api.gno.mobi/loc/getNearby/2/%f/%f/1.5/10/0", [lat floatValue], [lng floatValue]];
    NSURL *pListURL = [NSURL URLWithString:serverURL ];
    // Lucias 46.20107/6.15713
    // Authers 46.204550/6.144100
    [serverURL release];
    [lat release];
    [lng release];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:pListURL];
    
    //NSData* pListData = [NSData dataWithContentsOfURL:pListURL];
    
    NSData *pListData = [NSURLConnection
                         sendSynchronousRequest:request
                         returningResponse:&response
                         error:&error];
    
    id pList = [NSPropertyListSerialization
                propertyListFromData:pListData
                mutabilityOption:NSPropertyListImmutable
                format:&format 
                errorDescription:&errorDesc];
    
    NSDictionary *d = (NSDictionary *)pList;
    NSArray *entries = (NSArray *)[d objectForKey:@"feed"];
    
    context = [(GreatNightOutAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    // get the event location id's to parse in sorted order
    NSMutableArray *eventLocationIDs = [[NSMutableArray alloc] init];
    for(NSDictionary *entry in entries) {
        [eventLocationIDs addObject:[entry objectForKey:@"id"]];
    }
    // create the fetch request to get all events matching the IDs
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"EventLocation" inManagedObjectContext:context]];
    [fetchRequest setPredicate: [NSPredicate predicateWithFormat: @"(id IN %@)", eventLocationIDs]];
    
    // make sure the results are sorted as well
    [fetchRequest setSortDescriptors: [NSArray arrayWithObject:
                                       [[[NSSortDescriptor alloc] initWithKey: @"id"
                                                                    ascending:YES] autorelease]]];
    // Execute the fetch
    NSError *error = nil;
    NSArray *eventsMatchingIDs = [context executeFetchRequest:fetchRequest error:&error];
    
    // Are these all new event items, the match list will be empty
    if(0 == [eventsMatchingIDs count]){
        // Insert whole list
        for(NSDictionary *entry in entries) {
            [self storeItem:entry];
        }
    }
    else {
        
        // There should never be more fetched items than new items, unless there are duplicates in core data
        // There should never be fetched items which are not in the new items array
        // As both arrays are sorted by ID you can test values, equality...
        
        int countOfNewItems = [eventLocationIDs count]-1; // Don't forget arrays start at 0
        int countOfFetchedItems = [eventsMatchingIDs count]-1;
        
        int currentNewItem = 0;
        int currentFetchedItem =0;
        
        Boolean moreFetchedItems = true;
        
        for(currentNewItem = 0;currentNewItem <= countOfNewItems; currentNewItem++){
            
            NSNumber *idFromNewItem = [eventLocationIDs objectAtIndex:currentNewItem];
            NSNumber *idFromFetchedItem = [[eventsMatchingIDs objectAtIndex:currentFetchedItem] id];
            
            NSLog(@"Loop : % d matching new item : %@ with fetched item : %@",currentFetchedItem, idFromNewItem, idFromFetchedItem);
            
            // Do we have a match?
            if([idFromNewItem intValue] == [idFromFetchedItem intValue]) {
                NSLog(@"Item already exists, updating");
                
                NSDictionary *entry = [entries objectAtIndex:currentNewItem];
                [[eventsMatchingIDs objectAtIndex:currentFetchedItem] setDistance:[entry objectForKey:@"distance"]];
                NSError *error;
                if(![context save:&error]) {
                    NSLog(@"Error saving EventLocation entity");
                }
                
                // Are there any more fetched items
                if(currentFetchedItem < countOfFetchedItems){
                    currentFetchedItem++;
                    moreFetchedItems = true;
                }
                else{
                    moreFetchedItems = false;
                    break;
                }
            }
            
            // Is the new item before the fetched one, would happen if location changed
            else if([idFromNewItem intValue] < [idFromFetchedItem intValue]) {
                // Store the new item
                NSLog(@"New item <");
                NSDictionary *entry = [entries objectAtIndex:currentNewItem];
                [self storeItem:entry];
                // No need to increment currentFetchedItem
            }
            
            // Lastly the new item must be greater than the fetched, a new record created by another user
            else {
                while([idFromNewItem intValue] > [idFromFetchedItem intValue]){
                    if(currentFetchedItem < countOfFetchedItems){
                        currentFetchedItem++;
                        idFromFetchedItem = [[eventsMatchingIDs objectAtIndex:currentFetchedItem++] id];
                    }
                    else{
                        moreFetchedItems = false;
                        break;
                    }
                    
                }
            }
        }
        
        // See if there any more new items to be added
        if((currentNewItem) < countOfNewItems) {
            for (int i = currentNewItem; i < countOfNewItems; i++){
                NSLog(@"Additional New item");
                NSDictionary *entry = [entries objectAtIndex:i+1];
                [self storeItem:entry];
            }
        }
    }
    
}
-(void) storeItem:(NSDictionary *)entry {
    
    NSLog(@"Title: %@", [entry objectForKey:@"title"]);
    
    EventLocation *eventLocationEntity = (EventLocation *)[NSEntityDescription
                                   insertNewObjectForEntityForName:@"EventLocation" 
                                   inManagedObjectContext:context];
    
    
    [eventLocationEntity setExpires:[NSDate date]];
    [eventLocationEntity setBuilding_number:[entry objectForKey:@"building_number"]];
    [eventLocationEntity setId:[entry objectForKey:@"id"]];
    [eventLocationEntity setLat:[entry objectForKey:@"lat"]];
    [eventLocationEntity setLng:[entry objectForKey:@"lng"]];
    [eventLocationEntity setDistance:[entry objectForKey:@"distance"]];
    [eventLocationEntity setStatus:[entry objectForKey:@"status"]];
    [eventLocationEntity setStreet:[entry objectForKey:@"street"]];
    [eventLocationEntity setTitle:[entry objectForKey:@"title"]];
    
    // Save the new entity
    NSError *error;
    if(![context save:&error]) {
        NSLog(@"Error saving EventLocation entity");
    }

    
}
@end
