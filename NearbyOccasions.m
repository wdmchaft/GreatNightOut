//
//  NearbyOccasions.m
//  GreatNightOut
//
//  Created by Christopher Alford on 29/04/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NearbyOccasions.h"
#import "GreatNightOutAppDelegate.h"
#import "Occasion.h"

@implementation NearbyOccasions

NSPropertyListFormat format;
NSString *errorDescription = nil;
NSError *error;
NSURLResponse *response;

NSManagedObjectContext *context;

-(void) getNearby:(CLLocation *)withLocation {
    
    // Location Data
    
    NSNumber *lat = [[NSNumber alloc] initWithFloat:withLocation.coordinate.latitude];
    NSNumber *lng = [[NSNumber alloc] initWithFloat:withLocation.coordinate.longitude];
    
    // Read your plist
    NSString *serverURL = [NSString stringWithFormat:@"http://api.gno.mobi/occ/getNearby/2/%f/%f/1.5/10/0", [lat floatValue], [lng floatValue]];
    NSURL *pListURL = [NSURL URLWithString:serverURL ];
    // Lucias 46.20107/6.15713
    // Authers 46.204550/6.144100
    //[serverURL release];
    //[lat release];
    //[lng release];
    
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
                errorDescription:&errorDescription];
    
    NSDictionary *d = (NSDictionary *)pList;
    NSArray *occasionEntries = (NSArray *)[d objectForKey:@"feed"];
    
    context = [(GreatNightOutAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    // get the occasion id's to parse in sorted order
    NSMutableArray *occasionIDs = [[NSMutableArray alloc] init];
    for(NSDictionary *occasionEntry in occasionEntries) {
        [occasionIDs addObject:[occasionEntry objectForKey:@"id"]];
    }
    // create the fetch request to get all events matching the IDs
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Occasion" inManagedObjectContext:context]];
    [fetchRequest setPredicate: [NSPredicate predicateWithFormat: @"(id IN %@)", occasionIDs]];
    
    // make sure the results are sorted as well
    [fetchRequest setSortDescriptors: [NSArray arrayWithObject:
                                       [[[NSSortDescriptor alloc] initWithKey: @"id"
                                                                    ascending:YES] autorelease]]];
    // Execute the fetch
    NSError *error = nil;
    NSArray *occasionsMatchingIDs = [context executeFetchRequest:fetchRequest error:&error];
    
    // Are these all new event items, the match list will be empty
    if(0 == [occasionsMatchingIDs count]){
        // Insert whole list
        for(NSDictionary *occasionEntry in occasionEntries) {
            [self storeItem:occasionEntry];
        }
    }
    else {
        
        // There should never be more fetched items than new items, unless there are duplicates in core data
        // There should never be fetched items which are not in the new items array
        // As both arrays are sorted by ID you can test values, equality...
        
        int countOfNewItems = [occasionIDs count]-1; // Don't forget arrays start at 0
        int countOfFetchedItems = [occasionsMatchingIDs count]-1;
        
        int currentNewItem = 0;
        int currentFetchedItem =0;
        
        Boolean moreFetchedItems = true;
        
        for(currentNewItem = 0;currentNewItem <= countOfNewItems; currentNewItem++){
            
            NSNumber *idFromNewItem = [occasionIDs objectAtIndex:currentNewItem];
            NSNumber *idFromFetchedItem = [[occasionsMatchingIDs objectAtIndex:currentFetchedItem] id];
            
            NSLog(@"NBO: Loop : % d matching new item : %@ with fetched item : %@",currentFetchedItem, idFromNewItem, idFromFetchedItem);
            
            // Do we have a match?
            if([idFromNewItem intValue] == [idFromFetchedItem intValue]) {
                NSLog(@"NBO: Item already exists, updating");
                
                NSDictionary *entry = [occasionEntries objectAtIndex:currentNewItem];
                Occasion *occasionEntity = (Occasion *)[occasionsMatchingIDs objectAtIndex:currentFetchedItem];
                
                [occasionEntity setExpires:[NSDate date]];
                [occasionEntity setBuilding_number:[entry objectForKey:@"building_number"]];
                [occasionEntity setId:[entry objectForKey:@"id"]];
                [occasionEntity setLat:[entry objectForKey:@"lat"]];
                [occasionEntity setLng:[entry objectForKey:@"lng"]];
                [occasionEntity setDistance:[entry objectForKey:@"distance"]];
                [occasionEntity setStatus:[entry objectForKey:@"status"]];
                [occasionEntity setStreet:[entry objectForKey:@"street"]];
                [occasionEntity setTitle:[entry objectForKey:@"title"]];
                
                NSError *error;
                if(![context save:&error]) {
                    NSLog(@"NBO: Error saving EventLocation entity");
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
                NSLog(@"NBO: New item <");
                NSDictionary *occasionEntry = [occasionEntries objectAtIndex:currentNewItem];
                [self storeItem:occasionEntry];
                // No need to increment currentFetchedItem
            }
            
            // Lastly the new item must be greater than the fetched, a new record created by another user
            else {
                while([idFromNewItem intValue] > [idFromFetchedItem intValue]){
                    if(currentFetchedItem < countOfFetchedItems){
                        currentFetchedItem++;
                        idFromFetchedItem = [[occasionsMatchingIDs objectAtIndex:currentFetchedItem++] id];
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
                NSLog(@"NBO: Additional New item");
                NSDictionary *occasionEntry = [occasionEntries objectAtIndex:i+1];
                [self storeItem:occasionEntry];
            }
        }
    }
    
}
-(void) storeItem:(NSDictionary *)occasionEntry {
    
    NSLog(@"NBO: Title: %@", [occasionEntry objectForKey:@"title"]);
    
    Occasion *occasionEntity = (Occasion *)[NSEntityDescription
                                                           insertNewObjectForEntityForName:@"Occasion" 
                                                           inManagedObjectContext:context];
    
    
    [occasionEntity setExpires:[NSDate date]];
    [occasionEntity setBuilding_number:[occasionEntry objectForKey:@"building_number"]];
    [occasionEntity setId:[occasionEntry objectForKey:@"id"]];
    [occasionEntity setLat:[occasionEntry objectForKey:@"lat"]];
    [occasionEntity setLng:[occasionEntry objectForKey:@"lng"]];
    [occasionEntity setDistance:[occasionEntry objectForKey:@"distance"]];
    [occasionEntity setStatus:[occasionEntry objectForKey:@"status"]];
    [occasionEntity setStreet:[occasionEntry objectForKey:@"street"]];
    [occasionEntity setTitle:[occasionEntry objectForKey:@"title"]];
    
    // Save the new entity
    NSError *error;
    if(![context save:&error]) {
        NSLog(@"NBO: Error saving Occasion entity");
    }
}
@end

