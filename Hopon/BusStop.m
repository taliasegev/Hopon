//
//  BusStop.m
//  Hopon
//
//  Created by taliasegev on 8/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BusStop.h"

@implementation BusStop
@synthesize  stopId, stopSequence;

- (NSString *)description {
    
    return [[NSString alloc]initWithFormat:@"%@ ; stopId: %d ; stopSequence: %d",[super description],stopId, stopSequence];
    
}

@end
