//
//  DataLayer.h
//  Hopon
//
//  Created by Guy St on 8/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreLocation/CoreLocation.h"

@interface DataLayer : NSObject {
}

- (void)setLocaiton:(CLLocationCoordinate2D)coordinate;
- (void)fetchNearbyStops;
- (void)fetchRoutesForStop:(long)stopId;

@end
