//
//  LocationGetter.h
//  GreatNightOut
//
//  Created by Christopher Alford on 28/04/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocationGetterDelegate
@required
- (void) newPhysicalLocation:(CLLocation *)location;
@end

@interface LocationGetter : NSObject  {
    CLLocationManager *locationManager;
    id delegate;
}

- (void)startUpdates;

@property (nonatomic, retain) CLLocationManager *locationManager;
@property(nonatomic , retain) id delegate;
@end