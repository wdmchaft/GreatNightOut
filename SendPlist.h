//
//  SendPlist.h
//  GreatNightOut
//
//  Created by Christopher Alford on 29/04/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SendPlist : NSObject {
    NSMutableArray *books;
    NSMutableDictionary *book;
}

@property (nonatomic, retain) NSMutableArray *books;
@property (nonatomic, retain)NSMutableDictionary *book;

-(void) createData;
-(void) sendData;
-(void) sendRestData;
@end
