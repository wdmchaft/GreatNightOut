//
//  LocationGetter.m
//  GreatNightOut
//
//  Created by Christopher Alford on 28/04/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LocationGetter.h"
#import <coreLocation/CoreLocation.h>
//#import <MapKit/MapKit.h>

@implementation LocationGetter

@synthesize locationManager, delegate;
BOOL didUpdate = NO;

- (void)startUpdates
{
    NSLog(@"Starting Location Updates");
    
    if (locationManager == nil)
        locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    
    locationManager.distanceFilter = 20;  // update is triggered after device travels this far (meters)
    
    // Alternatively you can use kCLLocationAccuracyHundredMeters or kCLLocationAccuracyKilometer, though higher accuracy takes longer to resolve
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your location could not be determined." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [alert release];
}

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manage didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (didUpdate)
        return;
    
    didUpdate = YES;
    // Disable future updates to save power.
    //[locationManager stopUpdatingLocation];
    
    // let our delegate know we're done
    [delegate newPhysicalLocation:newLocation];
}

/*
- (void)reverseGeocodeWithCoordinate:(CLLocationCoordinate2D *)coordinate
{
    MKReverseGeocoder *geocoder = [[MKReverseGeocoder alloc] initWithCoordinate:coordinate];
    geocoder.delegate = self;
    [geocoder start];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error 
{
    geocoder.delegate = nil;
    [geocoder autorelease];
    // Reverse geocode failed, do something
}


- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark 
{
    geocoder.delegate = nil;    
    [geocoder autorelease];
    // Reverse geocode worked, do something...
}
*/
- (void)dealloc
{
    [locationManager release];
    
    [super dealloc];
}

@end
