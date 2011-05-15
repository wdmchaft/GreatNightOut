//
//  SendPlist.m
//  GreatNightOut
//
//  Created by Christopher Alford on 29/04/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SendPlist.h"

@implementation SendPlist

@synthesize book, books;

-(void) createData {
    self.books = [[NSMutableArray alloc] init];
    
    book = [NSMutableDictionary new];
    
    NSString *title = [NSString stringWithFormat:@"War and Peace"];
    [book setObject:@"Leo Tolstoy" forKey:@"Author"];
    [book setObject:title forKey:@"Title"];
    [book setObject:[NSNumber numberWithInt:3000] forKey:@"Number Available"];
    [book setObject:[NSNumber numberWithDouble:0.7] forKey:@"Weight"];
    [book setObject:[NSNumber numberWithBool:YES] forKey:@"In Stock"];
    NSDate *date = [NSDate date];
    [book setObject:date forKey:@"Date Received"];
    
    [books addObject:book];  
    
}

-(void) sendData {
    
    NSString *error;
    
    NSData *sampleData = [NSPropertyListSerialization dataFromPropertyList:self.book format:kCFPropertyListBinaryFormat_v1_0 errorDescription:&error];
    
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

-(void) sendRestData {
    
    NSString *error;
    
    NSData *sampleData = [NSPropertyListSerialization dataFromPropertyList:self.book format:kCFPropertyListBinaryFormat_v1_0 errorDescription:&error];
    
    if(sampleData)
    {
        NSString *urlString = @"http://api.gno.mobi/bplist/test";
        
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
    [books release];
    [super dealloc];
}

@end
