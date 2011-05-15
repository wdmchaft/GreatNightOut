//
//  NearbyOccasions.h
//  GreatNightOut
//
//  Created by Christopher Alford on 29/04/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface NearbyOccasions : NSObject {
    
}

-(void) getNearby:(CLLocation *)withLocation;
-(void) storeItem:(NSDictionary *)entry;

@end
