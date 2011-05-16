//
//  Location.m
//  GreatNightOut
//
//  Created by Christopher Alford on 29/04/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Location.h"

@implementation Location

@synthesize location, locations;

-(void) createData {
    self.locations = [[NSMutableArray alloc] init];
    
    location = [NSMutableDictionary new];
    
    NSString *title = [NSString stringWithFormat:@"War and Peace"];
    [location setObject:@"Leo Tolstoy" forKey:@"Author"];
    [location setObject:title forKey:@"Title"];
    [location setObject:[NSNumber numberWithInt:3000] forKey:@"Number Available"];
    [location setObject:[NSNumber numberWithDouble:0.7] forKey:@"Weight"];
    [location setObject:[NSNumber numberWithBool:YES] forKey:@"In Stock"];
    NSDate *date = [NSDate date];
    [location setObject:date forKey:@"Date Received"];
    
    [locations addObject:location];  
    
}

-(void) sendData {
    
    NSString *error;
    
    NSData *sampleData = [NSPropertyListSerialization dataFromPropertyList:self.location format:kCFPropertyListBinaryFormat_v1_0 errorDescription:&error];
    
    if(sampleData)
    {
        NSString *urlString = @"http://api.gno.mobi/ios/xxx/postData";
        
        // setting up the request object now
        NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        
        [request addValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
        //[request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Length"];

        [request setHTTPBody:sampleData];
        
        // now lets make the connection to the web
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@",returnString);
        [returnString release];
    }
    
}


- (void)dealloc
{
    [locations release];
    [location release];
    [super dealloc];
}

@end
