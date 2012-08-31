//
//  BusRoute.m
//  BusRoutes
//
//  Created by taliasegev on 8/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BusRoute.h"

@implementation BusRoute

@synthesize stops, title , company;
@synthesize routeId, stopsToDestination, distanceOfClosestStopFromDestination;
@synthesize closestStop, yourStop;





-(id)init{
    
    
    self = [super init];
    
    if (self) {        
        stops = [[NSMutableArray alloc]init];
    }
    return self;
    
}


-(id)initWithArray:(NSMutableArray *)busStopsArray{
    
    self = [super init];
    
    if (self) {        
        stops = busStopsArray;
    }
    return self;
    
}


-(id)initWithTitle:(NSString *)_title{
    self = [super init];
    
    if (self) {        
        title = _title;
    }
    return [self init];
     
}

-(id)initWithTitle:(NSString *)_title company:(NSString *)_company stops:(NSMutableArray *)_stops{

    self = [self initWithTitle:_title];
    if (self) {        
        company = _company;
        stops = _stops;
    }
    return self;
}



-(void)addBusStop:(BusStop *)_busStop{
    
    [stops addObject:_busStop];
}


- (NSString *)description {
    
    return [[NSString alloc]initWithFormat:@"title:%@ ; company:%@ ; stopsToDestination:%d ; distanceOfClosestStopFromDestination:%d", title, company,stopsToDestination, distanceOfClosestStopFromDestination];
    
}

-(NSString *)title{
    return title;    
}

-(NSMutableArray *)busStops{
    return stops;
}

// contrubition: Talia 
- (void)findMyStop{
    for(BusStop *stop in stops){ 
        
        // we need to know our stop sequence
        if(stop.stopId == yourStop.stopId) {
            yourStop = stop;
        }    
    }    
}


-(void)refreshByDestination:(CLLocationCoordinate2D)coordinate yourStop:(BusStop *)_yourStop 
{
    
    NSLog(@"routeId: %d, stops: %@", routeId, stops);
    
    yourStop = _yourStop;
    
    CLLocation *destinationLocation= [[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    [self findMyStop];
    
    int minDistance = NSIntegerMax;
    
    for(BusStop *stop in stops){
        CLLocation *stopLocation = [[CLLocation alloc]initWithLatitude:stop.coordinate.latitude longitude:stop.coordinate.longitude];
                
        
        int distance = [destinationLocation distanceFromLocation:stopLocation];
        if (distance < minDistance) {
            minDistance = distance;
            closestStop = stop;
            stopsToDestination = stop.stopSequence - yourStop.stopSequence;            
        }
    }
    
    distanceOfClosestStopFromDestination = minDistance;
}

// NSOrderedAscending = -1, NSOrderedSame, NSOrderedDescending
- (NSComparisonResult)compare:(BusRoute *)otherObject {

    if(distanceOfClosestStopFromDestination == otherObject.distanceOfClosestStopFromDestination) return NSOrderedSame;
    
    if(distanceOfClosestStopFromDestination < otherObject.distanceOfClosestStopFromDestination) {
        return NSOrderedAscending;
    }else{
        return NSOrderedDescending;
    }
}


@end
