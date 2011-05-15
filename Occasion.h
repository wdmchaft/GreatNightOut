//
//  Occasion.h
//  GreatNightOut
//
//  Created by Christopher Alford on 14/04/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Occasion : NSManagedObject {
@private
}
@property (nonatomic, retain) NSDate * expires;
@property (nonatomic, retain) NSString * building_number;
@property (nonatomic, retain) NSDecimalNumber * distance;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSDecimalNumber * lat;
@property (nonatomic, retain) NSDecimalNumber * lng;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * street;
@property (nonatomic, retain) NSString * title;

@end
