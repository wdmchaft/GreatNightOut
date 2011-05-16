//
//  Location.h
//  GreatNightOut
//
//  Created by Christopher Alford on 29/04/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Location : NSObject {
    NSMutableArray *locations;
    NSMutableDictionary *location;
}

@property (nonatomic, retain)NSMutableArray *locations;
@property (nonatomic, retain)NSMutableDictionary *location;

-(void) createData;
-(void) sendData;
@end
