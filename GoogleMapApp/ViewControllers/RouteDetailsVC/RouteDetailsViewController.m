//
//  RouteDetailsViewController.m
//  GoogleMapApp
//
//  Created by Amr Elghadban on 5/21/17.
//  Copyright © 2017 Karmadam. All rights reserved.
//

#import "RouteDetailsViewController.h"
#import "ConstantsVariables.h"
@interface RouteDetailsViewController ()

@end

@implementation RouteDetailsViewController


#pragma mark - Variables
static const double  mapZoomLevel = 16;



#pragma mark - lifeCycle of viewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    //Initializing MapView
    [self loadingOfMapViewWith :_appointmentLocaion];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



 #pragma mark - mapview helper
 
 /**
 *  Loading Map View Properties
 */
-(void)loadingOfMapViewWith:(AppointmentLocation *) appointmentLocation
{
    dispatch_async(dispatch_get_main_queue(),^{
        
        // _currentLatitude = kCameraLatitude;
        // _currentLongitude = kCameraLongitude;
        
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[appointmentLocation.dropOffLatitude doubleValue] longitude:[appointmentLocation.dropOffLongitude doubleValue] zoom:mapZoomLevel];
        
        // mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
        
        mapView_.mapType=kGMSTypeNormal;
        mapView_.camera = camera;
        mapView_.settings.compassButton = YES;
       // mapView_.delegate = self;
        mapView_.myLocationEnabled = YES;
        
        
         CLLocationCoordinate2D coordinateOne = CLLocationCoordinate2DMake([appointmentLocation.currentLatitude doubleValue],[appointmentLocation.currentLongitude doubleValue]);
        
         CLLocationCoordinate2D coordinateTwo = CLLocationCoordinate2DMake([appointmentLocation.dropOffLatitude doubleValue],[appointmentLocation.dropOffLongitude doubleValue]);
        
        [self creatMarkerForCoordinate:coordinateOne];
        [self creatMarkerForCoordinate:coordinateTwo];
        
        
        
        [self drawRouteDirectionAndDisplayRouteInfoForAppointmentLocation:appointmentLocation];
        
        
    });
    
}



-(void) creatMarkerForCoordinate:(CLLocationCoordinate2D)coordinate
{
    
    
    
    NSLog(@"You tapped at %f,%f", coordinate.latitude, coordinate.longitude);
    
    NSMutableDictionary *markerInfo=[NSMutableDictionary new];
    
    NSString *latitudeString =[NSString stringWithFormat:@"%f",coordinate.latitude];
    NSString *longitudeString =[NSString stringWithFormat:@"%f",coordinate.longitude];
    
    [markerInfo setObject:latitudeString forKey:@"latitude"];
    [markerInfo setObject:longitudeString forKey:@"longitude"];
    
    
    
    //[mapView_ clear];
    
    
    [self addMarkerToMapWithInfo:markerInfo];
   
}



-(void) addMarkerToMapWithInfo:(NSDictionary *)dict{
    
    
    double latitude = [dict[@"latitude"] doubleValue];
    double longitude = [dict[@"longitude"] doubleValue];
    //Adding markers
    __block GMSMarker *marker;
    
    
    UIView *markerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 60)];
    markerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"home_map_pin_profile_icon"]];
    
    UIImageView *markerImageViewInner = [[UIImageView alloc] initWithFrame:CGRectMake(4.2,4,36,36)];
    markerImageViewInner.layer.cornerRadius = markerImageViewInner.frame.size.height/2;
    markerImageViewInner.clipsToBounds = YES;
    
    
    [markerView addSubview:markerImageViewInner];
    
    
    dispatch_async(dispatch_get_main_queue(),^{
        
        marker = [[GMSMarker alloc]init];
        marker.userData = dict;
        marker.position = CLLocationCoordinate2DMake(latitude, longitude);
        marker.tappable = YES;
        marker.flat = YES;
        
        marker.appearAnimation = kGMSMarkerAnimationPop;
        marker.groundAnchor = CGPointMake(0.5f, 0.5f);
        marker.iconView = markerView;
        marker.map = mapView_;
        
    });
    
    
    
    /*
     // Creates a marker in the center of the map.
     GMSMarker *marker = [GMSMarker new];
     marker.position =  CLLocationCoordinate2DMake(kCameraLatitude,kCameraLongitude);
     //CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
     marker.title = @"Sydney";
     marker.snippet = @"Australia";
     marker.map = mapView;
     */
    
}


- (void)drawRouteDirectionAndDisplayRouteInfoForAppointmentLocation:(AppointmentLocation *) appointmentLocation
{
    
    CLLocationCoordinate2D firstCoordinate=CLLocationCoordinate2DMake([appointmentLocation.currentLatitude doubleValue], [appointmentLocation.currentLongitude doubleValue]);
    CLLocationCoordinate2D secondCoordinate=CLLocationCoordinate2DMake([appointmentLocation.dropOffLatitude doubleValue], [appointmentLocation.dropOffLongitude doubleValue]);
    
    
    if (appointmentLocation.pointsToDrowRoute  && appointmentLocation.pointsToDrowRoute.length > 0 ) {
        
        
         [self drawInfoOnScreenTime:appointmentLocation.time andDistance:appointmentLocation.distance andAddress:appointmentLocation.pickUpAddress andPoints:appointmentLocation.pointsToDrowRoute];
        
    }else{
        [self getDirectionInfoForAppointmentLocation:appointmentLocation completionHandler:^(NSArray *routesArray) {
            
            if ([routesArray count] > 0)
            {
                NSDictionary *routeDict = [routesArray objectAtIndex:0];
                NSDictionary *routeOverviewPolyline = [routeDict objectForKey:@"overview_polyline"];
                NSString *points = [routeOverviewPolyline objectForKey:@"points"];
                
                appointmentLocation.pointsToDrowRoute = points;
                
                //GMSPath *path = [GMSPath pathFromEncodedPath:points];
                //GMSPolyline * polyline = [GMSPolyline polylineWithPath:path];
                
                NSMutableArray *arrLeg=[[routesArray objectAtIndex:0]objectForKey:@"legs"];
                NSMutableDictionary *dictleg=[arrLeg objectAtIndex:0];
                
                NSString *time =  [[dictleg   objectForKey:@"duration"] objectForKey:@"text"] ;
                
                NSString *distance =  [[dictleg   objectForKey:@"distance"] objectForKey:@"text"];
                
                
                [self drawInfoOnScreenTime:time andDistance:distance andAddress:appointmentLocation.pickUpAddress andPoints:points];
                
               
            }else {
                // Error in Google API
            }

        }];
    }
}


-(void) drawInfoOnScreenTime:(NSString *)time andDistance:(NSString *)distance andAddress:(NSString *)address andPoints:(NSString *)points{

    
    dispatch_async(dispatch_get_main_queue(),^{
        
        self.timeLabel.text = time;
          self.distanceLabel.text = distance;
        self.addressLabel.text=address;
        
        GMSPath *path = [GMSPath pathFromEncodedPath:points];
        GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
        polyline.strokeColor = [UIColor blackColor];
        polyline.strokeWidth = 3;
        polyline.geodesic =YES;
        polyline.map = mapView_;
        
        
    });
    
    
    
    
   
    



}


#pragma mark - Map Directions (Time/Distance/Point) Methods

-(void)getDirectionInfoForAppointmentLocation:(AppointmentLocation *) appointmentLocation completionHandler:(void (^)(NSArray *routesArray))completionHandler

{
    
    CLLocationCoordinate2D firstCoordinate=CLLocationCoordinate2DMake([appointmentLocation.currentLatitude doubleValue], [appointmentLocation.currentLongitude doubleValue]);
    CLLocationCoordinate2D secondCoordinate=CLLocationCoordinate2DMake([appointmentLocation.dropOffLatitude doubleValue], [appointmentLocation.dropOffLongitude doubleValue]);
    
    
    NSString *strUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&key=%@",firstCoordinate.latitude,firstCoordinate.longitude,secondCoordinate.latitude,secondCoordinate.longitude,googleKeyAPIkey];
    
    NSURL *directionsUrl = [NSURL URLWithString:[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask *fetchDirectionsTask = [[NSURLSession sharedSession] dataTaskWithURL:directionsUrl completionHandler:
                                                 ^(NSData *data, NSURLResponse *response, NSError *error)
                                                 {
                                                     NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                     if(error)
                                                     {
                                                         if(completionHandler)
                                                             completionHandler(nil);
                                                         return;
                                                     }
                                                     
                                                     NSArray *routesArray = [json objectForKey:@"routes"];
                                                     
                                                    // run completionHandler on main thread
                                                     dispatch_sync(dispatch_get_main_queue(), ^{
                                                         if(completionHandler)
                                                             completionHandler(routesArray);
                                                     });
                                                 }];
    [fetchDirectionsTask resume];

}




@end
