//
//  BusStop.h
//  BusMap
//
//  Created by taliasegev on 8/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Annotation : NSObject <MKAnnotation>{
    
   
    NSString *title;
    NSString *subtitle;
    CLLocationCoordinate2D coordinate;
            
}

@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *subtitle;
@property (nonatomic,readonly)CLLocationCoordinate2D coordinate;

-(id)initWithCoordinate:(CLLocationCoordinate2D)coord title:(NSString *)_title subtitle:(NSString *)_subtitle;
-(id)initWithCoordinate:(CLLocationCoordinate2D)coord;                         

@end
