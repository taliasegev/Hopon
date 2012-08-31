//
//  BusListVC.h
//  Hopon
//
//  Created by taliasegev on 8/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusRoute.h"

@interface BusListVC : UITableViewController{
    
    NSMutableArray *routesSideA;
    NSMutableArray *routesSideB;

    
    BusStop *yourStop;
    
    // are we on sideA or not - every table dataSource method will check this
    BOOL sideA;
}

@end
