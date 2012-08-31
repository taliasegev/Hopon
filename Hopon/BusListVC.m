//
//  BusListVC.m
//  Hopon
//
//  Created by taliasegev on 8/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BusListVC.h"
#import "DataLayer.h"

@interface BusListVC ()

@end

@implementation BusListVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    yourStop = [[BusStop alloc] initWithCoordinate:CLLocationCoordinate2DMake(32.079601, 34.780701)];
    yourStop.stopId = 13129;

    DataLayer *dataLayer = [[DataLayer alloc]init];
    [dataLayer fetchRoutesForStop:yourStop.stopId];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fetchRoutesEnd:) name:@"fetchRoutesEnd" object:nil];
   
 //   CLLocationCoordinate2D myLocation = [self getLocation];
 //   [dataLayer setLocaiton:(myLocation)];
    
}

-(void)fetchRoutesEnd:(NSNotification *)notification{

    routes = notification.object;
    CLLocationCoordinate2D fakeDestination = CLLocationCoordinate2DMake(32.055463, 34.772329);
    
    for(BusRoute *busRoute in routes){
        [busRoute refreshByDestination:fakeDestination yourStop:yourStop];  
        
        // is this minus - then side B
        //[busRoute stopsToDestination]
        
        
    }
    
   [routes sortUsingSelector:@selector(compare:)];
    
        
    NSLog(@"fetchRoutesEnd: routes = %@",routes);
    [self.tableView reloadData];
}



-(CLLocationCoordinate2D)getLocation{
    return CLLocationCoordinate2DMake(32.08, 34.7805);     
         
}
     
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [routes count];
}

- (NSString *)distanceTextForMeters:(int)meters {

    NSString *output;
    
    if(meters<1000) {
        output = [[NSString alloc] initWithFormat:@"%d מ'",meters];
    }
    else
    {
        float km = meters / 1000.0;
        output = [[NSString alloc] initWithFormat:@"%4.2f ק\"מ",km];
    }
    
    return output;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BusListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UILabel *uiLabelLineNumber;
    UILabel *uiLabelCompany;
    UILabel *uiLabelStoptoDestination;
    UILabel *uiLabelDistanceFromClosestStop;
    
    // get the model
    BusRoute *route = [routes objectAtIndex:indexPath.row];
    
    uiLabelLineNumber = (UILabel *)[cell viewWithTag:1];
    uiLabelCompany = (UILabel *)[cell viewWithTag:2];
    uiLabelStoptoDestination= (UILabel *)[cell viewWithTag:3];
    uiLabelDistanceFromClosestStop= (UILabel *)[cell viewWithTag:4];
    
    // set the views according to model
    uiLabelLineNumber.text = route.title;
    uiLabelCompany.text = route.company;
    uiLabelStoptoDestination.text = [[NSString alloc]initWithFormat:@"%d", route.stopsToDestination];
    uiLabelDistanceFromClosestStop.text = [self distanceTextForMeters:route.distanceOfClosestStopFromDestination];
    
      
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
