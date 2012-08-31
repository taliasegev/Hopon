//
//  BusRoute.h
//  BusRoutes
//
//  Created by taliasegev on 8/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BusStop.h"

@interface BusRoute :NSObject{

    
    //iVars
    NSMutableArray * stops;
    
    NSString *title;
    NSString *company;
    int routeId;
    
    int stopsToDestination;
    int distanceOfClosestStopFromDestination;
    
    BusStop *closestStop;
    BusStop *yourStop;

       
    
}

@property (nonatomic, strong) NSMutableArray *stops;
@property (nonatomic, strong)NSString *title , *company;
@property int routeId, stopsToDestination, distanceOfClosestStopFromDestination;
@property (nonatomic, strong) BusStop *closestStop, *yourStop;




-( id)init;
-( id)initWithTitle:(NSString *)_title;
- (id)initWithTitle:(NSString *)_title company:(NSString *)_company stops:(NSMutableArray *)_stops;

- (id)initWithArray:(NSMutableArray *)busStopsArray;
- (void)addBusStop:(BusStop *)_busStop;
- (NSMutableArray *)stops;
- (void)refreshByDestination:(CLLocationCoordinate2D)coordinate yourStop:(BusStop *)_yourStop;





@end
