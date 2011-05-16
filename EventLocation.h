//
//  EventLocation.h
//  GreatNightOut
//
//  Created by Christopher Alford on 24/04/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EventLocation : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * building_number;
@property (nonatomic, retain) NSString * street;
@property (nonatomic, retain) NSString * street_additional;
@property (nonatomic, retain) NSString * area;
@property (nonatomic, retain) NSString * apartment;
//@property (nonatomic, retain) NSNumber * city;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSDecimalNumber * lat;
@property (nonatomic, retain) NSDecimalNumber * lng;
@property (nonatomic, retain) NSString * address_format;
@property (nonatomic, retain) NSString * language;
@property (nonatomic, retain) NSString * is_public;
//@property (nonatomic, retain) NSString * address_type;
@property (nonatomic, retain) NSDecimalNumber * distance;
@property (nonatomic, retain) NSDate * expires;

@property (nonatomic, retain) NSString * status;



@end
