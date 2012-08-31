//
//  DataLayer.m
//  Hopon
//
//  Created by Guy St on 8/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataLayer.h"
#import "BusRoute.h"



NSString *const APIpath = @"http://localhost/hopon/api";

@implementation DataLayer

- (void)setLocaiton:(CLLocationCoordinate2D)coordinate {
    
    NSString *requestParametersFormat = @"{'latitude':%f,'longitude':%f}";
    requestParametersFormat = [requestParametersFormat stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
    
    NSString *requestParametersJSON = [[NSString alloc] initWithFormat:requestParametersFormat, coordinate.latitude, coordinate.longitude];
    
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@/setLocation", APIpath];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSData *requestData = [NSData dataWithBytes:[requestParametersJSON UTF8String] length:[requestParametersJSON length]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] 
   forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPBody: requestData];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *urlResponse, NSData *data, NSError *error){
        //NSLog(@"%@", [self stringFromData:data]);
        [self performSelectorOnMainThread:@selector(postNotificationCoordinateSet:) withObject:nil waitUntilDone:NO];
    }];
}

- (void)postNotificationCoordinateSet:(id)object {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"coordinateSet" object:object];
}

- (void)fetchNearbyStops {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"fetchNearbyStopsStart" object:nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSMutableArray* stopsRawArray;
        
        NSString *urlString = [[NSString alloc] initWithFormat:@"%@/stopsByLocation", APIpath];
        NSURL *url = [[NSURL alloc] initWithString:urlString];
        
        NSData* data = [[NSData alloc] initWithContentsOfURL:url];
        //NSLog(@"%@", [self stringFromData:data]);
        
        NSError* error;
        stopsRawArray = [NSJSONSerialization  JSONObjectWithData:data options:kNilOptions error:&error];
        
        NSMutableArray *stopsArray = [self parseStops:stopsRawArray];
        
        [self performSelectorOnMainThread:@selector(postNotificationFetchNearbyStops:) withObject:stopsArray waitUntilDone:NO];
    });
}

- (void)postNotificationFetchNearbyStops:(id)object {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"fetchNearbyStopsEnd" object:object];
}


- (NSMutableArray *)parseStops:(NSMutableArray *)stopsRawArray {
    // {"stop_id":"13129","stop_code":"21520","stop_name":"","stop_desc"","stop_lat":"32.0796","stop_lon":"34.7807","distance":"50.3977682031398"}
    
    NSMutableArray *stopsArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dictionary in stopsRawArray) {
        int stopId = [[dictionary objectForKey:@"stop_id"] intValue];
        NSString *title = [dictionary objectForKey:@"stop_name"];
        float latitude = [[dictionary objectForKey:@"stop_lat"] floatValue];
        float longitude = [[dictionary objectForKey:@"stop_lon"] floatValue];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        
        BusStop  *busStop = [[BusStop alloc] initWithCoordinate:coordinate title:title subtitle:@""];
        busStop.stopId = stopId;
        
        [stopsArray addObject:busStop];
    }
    
    
    return stopsArray;
}

- (void)fetchRoutesForStop:(long)stopId {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"fetchRoutesStart" object:nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSMutableArray* routesRawArray;
        
        NSString *urlString = [[NSString alloc] initWithFormat:@"%@/stops/%d/routes", APIpath, stopId];
        NSURL *url = [[NSURL alloc] initWithString:urlString];
        NSData* data = [[NSData alloc] initWithContentsOfURL:url];
        
        NSError* error;
        routesRawArray = [NSJSONSerialization  JSONObjectWithData:data options:kNilOptions error:&error];
        
        NSMutableArray *routeArray =  [self parseRoutes:routesRawArray];
        [self performSelectorOnMainThread:@selector(postNotificationFetchRoutesForStop:) withObject:routeArray waitUntilDone:NO];
    });
    
}

- (void)postNotificationFetchRoutesForStop:(NSMutableArray *)routeArray {
    NSNotification *notification = [NSNotification notificationWithName:@"fetchRoutesEnd" object:routeArray];

    [[NSNotificationCenter defaultCenter] postNotification:notification];
}


- (NSMutableArray *)parseRoutes:(NSMutableArray *)routesRawArray {
    // {"route_id":"1082555","agency_id":"5","route_short_name":"82","stop_id":"13034","stop_sequence":"33", "stop_id":"13129","stop_code":"21520","stop_name":"","stop_desc"","stop_lat":"32.0796","stop_lon":"34.7807","distance":"50.3977682031398"}
    
    NSDictionary *agencies = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"אגד",@"אגד תעבורה",@"דן",@"שאמ",@"נסיעות ותיירות",@"גי.בי.טורס",@"אומני אקספרקס",@"עילית",@"נתיב אקספרס",@"מטרופולין",@"סופרבוס",@"קונקס",@"קווים",@"מטרודן",@"גלים",@"מועצה אזורית גולן",@"אפיקים",@"דן צפון", nil] 
                                                           forKeys:[NSArray arrayWithObjects:@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"11",@"14",@"15",@"16",@"17",@"18",@"19",@"23",@"24",@"25",@"30", nil]];
    
    
    NSMutableArray *routesArray = [[NSMutableArray alloc] init];
    NSMutableArray *stopsArray = [[NSMutableArray alloc] init];
    
    BusRoute *busRoute;
    
    for (NSDictionary *dictionary in routesRawArray) {
        int stopId = [[dictionary objectForKey:@"stop_id"] intValue];
        NSString *title = [dictionary objectForKey:@"stop_name"];
        float latitude = [[dictionary objectForKey:@"stop_lat"] floatValue];
        float longitude = [[dictionary objectForKey:@"stop_lon"] floatValue];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        int stopSequence = [[dictionary objectForKey:@"stop_sequence"] intValue] ;
        
        BusStop  *busStop = [[BusStop alloc] initWithCoordinate:coordinate title:title subtitle:@""];
        busStop.stopId = stopId;
        busStop.stopSequence = stopSequence;
        
        int routeId = [[dictionary objectForKey:@"route_id"] intValue];
        NSString *routeTitle = [dictionary objectForKey:@"route_short_name"];
        NSString *routeAgencyIdKey = [dictionary objectForKey:@"agency_id"];
        NSString *routeAgency = [agencies objectForKey:routeAgencyIdKey];
        
        if(!busRoute || busRoute.routeId != routeId) 
        {
            stopsArray = [[NSMutableArray alloc] init];
            
            busRoute = [[BusRoute alloc] initWithTitle:routeTitle company:routeAgency stops:stopsArray];
            busRoute.routeId = routeId;
            [routesArray addObject:busRoute];
        }
        
        [stopsArray addObject:busStop];
    }
    
    //NSLog(@"%@", routesArray);
    return routesArray;
}

- (NSString *)stringFromData:(NSData *)data {
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
