//
//  BusStop.m
//  BusMap
//
//  Created by taliasegev on 8/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Annotation.h"

@implementation Annotation

@synthesize  title,subtitle,coordinate;


-(id)initWithCoordinate:(CLLocationCoordinate2D)coord title:(NSString *)_title subtitle:(NSString *)_subtitle{
    
    self = [super init];
    
    if (self) {
        coordinate = coord;
        title = _title;
        subtitle = _subtitle;
    }
    return self;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D)coord{
    
    return [self initWithCoordinate:coord title:@"" subtitle:@""];
        
}

- (NSString *)description {
    
    return [[NSString alloc]initWithFormat:@"name:%@ ; lat:%f ; lng:%f",title,coordinate.latitude, coordinate.longitude];
    
}

@end
