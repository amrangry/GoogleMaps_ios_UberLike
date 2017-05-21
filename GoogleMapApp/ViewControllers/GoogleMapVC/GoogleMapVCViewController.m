//
//  GoogleMapVCViewController.m
//  GoogleMapApp
//
//  Created by Amr Elghadban on 5/21/17.
//  Copyright © 2017 Karmadam. All rights reserved.
//

#import "GoogleMapVCViewController.h"

#import "ConstantsVariables.h"
#import "PickUpViewController.h"
#import "DbHandler.h"
#import "NSString+extention.h"
@import UIKit;
@import GoogleMaps;
@interface GoogleMapVCViewController () <GMSMapViewDelegate>

@end


@implementation GoogleMapVCViewController


#pragma mark - Variables
// Declare a GMSMarker instance at the class level.
GMSMarker *infoMarker;


//to set current location egypt
//static const double kCameraLatitude = 30.073912;
//static const double kCameraLongitude = 31.649582;


static const double  mapZoomLevel = 16;

#pragma mark - LifeCycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /* get current location update */
    getCurrentLocation = [GetCurrentLocation sharedInstance];
    getCurrentLocation.delegate = self;
    [getCurrentLocation getLocation];
    
    
    //Initializing MapView
   // [self loadingOfMapView];
    
    /**
     *  Adding Current Address and Location Details In appointmentLocation Class
     */
    apLocaion = [AppointmentLocation new];
    
    
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    
    [self.navigationController setNavigationBarHidden:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Get CurrentLocation Methods -

- (void)getAddress:(CLLocation *)coordinate and:(BOOL)isCurrentLocation
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:coordinate
                   completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             
             NSString * address = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
             
             NSLog(@"Selected Address In Home VC:%@",address);
             
             [self  updatedAddress:address];
             
             if(isCurrentLocation)
             {
                 NSLog(@"Current location Address In Home VC:%@",address);
             }
             
         }
         else
         {
             NSLog(@"Failed to update location : %@",error);
         }
     }];
    
}


#pragma mark - GMSMapViewDelegate
// Attach an info window to the POI using the GMSMarker.
- (void)mapView:(GMSMapView *)mapView didTapPOIWithPlaceID:(NSString *)placeID name:(NSString *)name location:(CLLocationCoordinate2D)location {
    
    
    NSLog(@"You tapped %@: %@, %f/%f", name, placeID, location.latitude, location.longitude);
    infoMarker = [GMSMarker markerWithPosition:location];
    infoMarker.snippet = placeID;
    infoMarker.title = name;
    infoMarker.opacity = 0;
    CGPoint pos = infoMarker.infoWindowAnchor;
    pos.y = 1;
    infoMarker.infoWindowAnchor = pos;
    infoMarker.map = mapView;
    mapView.selectedMarker = infoMarker;
}


/**
 invoked when tap in map
 */
- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    
   
    [self creatMarkerForCoordinate:coordinate];
    
}



- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    
    if(marker.userData)
    {
        
        
        
    }
    
    return YES;
    
}




/**
 * Called repeatedly during any animations or gestures on the map (or once, if
 * the camera is explicitly set). This may not be called for all intermediate
 * camera positions. It is always called for the final position of an animation
 * or gesture.
 */
- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position{
    
    
    
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.bookBtn.hidden=YES;
    self.timeAndDistanceView.hidden=YES;
    self.addressView.hidden=YES;
}





/**
 * Called when the map becomes is about to move, after any outstanding gestures or
 * animations have completed (or after the camera has been explicitly set).
 */
- (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture {
    //[mapView clear];
}

/**
 * Called when the map becomes idle, after any outstanding gestures or
 * animations have completed (or after the camera has been explicitly set).
 */
- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)cameraPosition {
    
   
   // [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.bookBtn.hidden=NO;
    self.timeAndDistanceView.hidden=NO;
    self.addressView.hidden=NO;
    
    
    /*
    // handle centerPoint location
    CGPoint point1 = mapView_.center;
    CLLocationCoordinate2D coor = [mapView.projection coordinateForPoint:point1];
    _currentLatitude = coor.latitude;
    _currentLongitude = coor.longitude;
    CLLocation *location = [[CLLocation alloc]initWithLatitude:_currentLatitude longitude:_currentLongitude];
    [self getAddress:location and:NO];
    
    
    // handle nearby location
    id handler = ^(GMSReverseGeocodeResponse *response, NSError *error) {
        if (error == nil) {
            GMSReverseGeocodeResult *result = response.firstResult;
            GMSMarker *marker = [GMSMarker markerWithPosition:cameraPosition.target];
            marker.title = result.lines[0];
            marker.snippet = result.lines[1];
            marker.map = mapView;
        }
    };
    [geocoder_ reverseGeocodeCoordinate:cameraPosition.target completionHandler:handler];
    */
}

#pragma mark - mapview helper

/**
 *  Loading Map View Properties
 */
-(void)loadingOfMapView
{
    dispatch_async(dispatch_get_main_queue(),^{
        
       // _currentLatitude = kCameraLatitude;
       // _currentLongitude = kCameraLongitude;
        
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:_currentLatitude longitude:_currentLongitude zoom:mapZoomLevel];
        
        // mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
        
        mapView_.mapType=kGMSTypeNormal;
        mapView_.camera = camera;
        mapView_.settings.compassButton = YES;
        mapView_.delegate = self;
        mapView_.myLocationEnabled = YES;
        
        geocoder_ = [[GMSGeocoder alloc] init];
        
        NSMutableDictionary *markerInfo=[NSMutableDictionary new];
        
        [markerInfo setObject:[NSString stringWithFormat:@"%f",_currentLatitude]  forKey:@"latitude"];
        [markerInfo setObject:[NSString stringWithFormat:@"%f",_currentLongitude] forKey:@"longitude"];
        
        [self addMarkerToMapWithInfo: markerInfo];
        
        
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
    
    
    
    [mapView_ clear];
    
    
    [self addMarkerToMapWithInfo:markerInfo];
    
    
    AppointmentLocation * appointmentLocation=[AppointmentLocation new];
    appointmentLocation.currentLatitude=[NSNumber numberWithFloat:_currentLatitude];
    appointmentLocation.currentLongitude=[NSNumber numberWithFloat:_currentLongitude];
    appointmentLocation.dropOffLatitude=[NSNumber numberWithFloat:coordinate.latitude];
    appointmentLocation.dropOffLongitude=[NSNumber numberWithFloat:coordinate.longitude];
    appointmentLocation.pickUpAddress = self.addressLabel.text;
    
    // set the aplocation equal to the marker in order to get the details later one
    apLocaion = appointmentLocation;
    
    
    
  //  [self showTimeBetweenAppointmentLocation:apLocaion];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self getDirectionInfoForAppointmentLocation:apLocaion completionHandler:^(NSArray *routesArray) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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
            
            
            [self setMinutesLableTitleWithValue:time];
            [self setDistnaceLableTitleWithValue:distance];
            
            
            // [self drawRouteForAppointmentLocation:appointmentLocation];
            //Hint: apLocation have the current and marker info lat and long
            [self drawRouteDirectionForAppointmentLocation:apLocaion];
            
            
        }else {
            // Error in Google API
        }

        
        
    }];

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



-(void) drawLineForAppointmentLocation:(AppointmentLocation *) appointmentLocation{
    
    
    GMSMutablePath *path = [GMSMutablePath path];
    
    CLLocationCoordinate2D firstCoordinate=CLLocationCoordinate2DMake([appointmentLocation.currentLatitude doubleValue], [appointmentLocation.currentLongitude doubleValue]);
    CLLocationCoordinate2D secondCoordinate=CLLocationCoordinate2DMake([appointmentLocation.dropOffLatitude doubleValue], [appointmentLocation.dropOffLongitude doubleValue]);
    
    [path addCoordinate:firstCoordinate];
    [path addCoordinate:secondCoordinate];
    
    GMSPolyline *route = [GMSPolyline polylineWithPath:path];
    route.strokeColor = [UIColor blackColor];
    route.strokeWidth = 3;
    route.geodesic =YES;
    
    route.map = mapView_;
    
    
}



- (void)drawRouteDirectionForAppointmentLocation:(AppointmentLocation *) appointmentLocation
{
    
    CLLocationCoordinate2D firstCoordinate=CLLocationCoordinate2DMake([appointmentLocation.currentLatitude doubleValue], [appointmentLocation.currentLongitude doubleValue]);
    CLLocationCoordinate2D secondCoordinate=CLLocationCoordinate2DMake([appointmentLocation.dropOffLatitude doubleValue], [appointmentLocation.dropOffLongitude doubleValue]);
    
    
    if (appointmentLocation.pointsToDrowRoute  && appointmentLocation.pointsToDrowRoute.length >0 ) {
        
        GMSPath *path = [GMSPath pathFromEncodedPath:appointmentLocation.pointsToDrowRoute];
        GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
        polyline.strokeColor = [UIColor blackColor];
        polyline.strokeWidth = 3;
        polyline.geodesic =YES;
        polyline.map = mapView_;
        
    }else{
        [self fetchPolylineWithOrigin:firstCoordinate destination:secondCoordinate completionHandler:^(GMSPolyline *polyline){
            if(polyline){
                polyline.strokeColor = [UIColor blackColor];
                polyline.strokeWidth = 3;
                polyline.geodesic =YES;
                polyline.map = mapView_;
            }
        }];
    }
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



- (void)fetchPolylineWithOrigin:(CLLocationCoordinate2D)origin destination:(CLLocationCoordinate2D)destination completionHandler:(void (^)(GMSPolyline *))completionHandler
{
    NSString *originString = [NSString stringWithFormat:@"%f,%f", origin.latitude, origin.longitude];
    NSString *destinationString = [NSString stringWithFormat:@"%f,%f", destination.latitude, destination.longitude];
    
    //https://maps.googleapis.com/maps/api/directions/json?origin=75+9th+Ave+New+York,+NY&destination=MetLife+Stadium+1+MetLife+Stadium+Dr+East+Rutherford,+NJ+07073&key=YOUR_API_KEY
    
    NSString *directionsAPI = @"https://maps.googleapis.com/maps/api/directions/json?";
    NSString *directionsUrlString = [NSString stringWithFormat:@"%@origin=%@&destination=%@&mode=driving&key=%@", directionsAPI, originString, destinationString,googleKeyAPIkey];
    NSURL *directionsUrl = [NSURL URLWithString:directionsUrlString];
    
    
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
                                                     
                                                     GMSPolyline *polyline = nil;
                                                     if ([routesArray count] > 0)
                                                     {
                                                         NSDictionary *routeDict = [routesArray objectAtIndex:0];
                                                         NSDictionary *routeOverviewPolyline = [routeDict objectForKey:@"overview_polyline"];
                                                         NSString *points = [routeOverviewPolyline objectForKey:@"points"];
                                                         GMSPath *path = [GMSPath pathFromEncodedPath:points];
                                                         polyline = [GMSPolyline polylineWithPath:path];
                                                     }
                                                     
                                                     
                                                     
                                                     
                                                     // run completionHandler on main thread
                                                     dispatch_sync(dispatch_get_main_queue(), ^{
                                                         if(completionHandler)
                                                             completionHandler(polyline);
                                                     });
                                                 }];
    [fetchDirectionsTask resume];
}






-(void)setMinutesLableTitleWithValue:(NSString *)value
{
    apLocaion.time=value;
    dispatch_async(dispatch_get_main_queue(),^{
        
        self.timeLabel.text = value;
    });
}

-(void)setDistnaceLableTitleWithValue:(NSString *)value
{
     apLocaion.distance=value;
    dispatch_async(dispatch_get_main_queue(),^{
        
        self.distanceLabel.text = value;
    });
}

- (IBAction)bookBtnPressed:(id)sender {
  
    
    DbHandler *db=[DbHandler sharedInstance];
    AppointmentLocation *temp=apLocaion ;
    
    bool isSaved=[db saveItem:temp];
    
    if (isSaved) {
        NSLog(@"Success");
        
        [@"Trip has been Saved SuccessFully" show:self];
    }else{
       NSLog(@"Failure");
        
        [@"Failure in saving Trip \n Please try again" show:self];
    }
    
    
    
    
    
}

- (IBAction)addBtn:(id)sender {
    
    NSMutableDictionary *markerInfo=[NSMutableDictionary new];
    
    [markerInfo setObject:@"30.43443" forKey:@"latitude"];
    [markerInfo setObject:@"30.4555" forKey:@"longitude"];
    
    [self addMarkerToMapWithInfo: markerInfo];
    
}

#pragma mark - Get Current Location Delegates -

- (void)updatedLocation:(double)latitude and:(double)longitude
{
   
    /*
    //change map camera postion to current location
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude
                                                            longitude:longitude
                                                                 zoom:mapZoomLevel];
    [mapView_ setCamera:camera];
    */
    
    
    
    //save current location to plot direciton on map
    _currentLatitude = latitude;
    _currentLongitude =  longitude;
    
    
    
    
    [self loadingOfMapView];
    
}

-(void)updatedAddress:(NSString *)currentAddress
{
    NSString * address= currentAddress;
    NSLog(@"Current Address In Home VC:%@",address);
    
    
    apLocaion.pickUpAddress=address;
    self.addressLabel.text=address;
    
}





/**
 *  Current Location Changed called when address picked manually
 *
 *  @param dictAddress <#dictAddress description#>
 */
- (void) changeCurrentLocation:(NSDictionary *)dictAddress
{
    
    //    mapView_.camera = [GMSCameraPosition cameraWithTarget:location.coordinate zoom:mapZoomLevel];
    
    GMSCameraUpdate *zoomCamera = [GMSCameraUpdate setTarget:CLLocationCoordinate2DMake(_currentLatitude, _currentLongitude) zoom:mapZoomLevel];
    
    [mapView_ animateWithCameraUpdate:zoomCamera];
    
    NSMutableDictionary *markerInfo=[NSMutableDictionary new];
    
    [markerInfo setObject:[NSString stringWithFormat:@"%f",_currentLatitude]  forKey:@"latitude"];
    [markerInfo setObject:[NSString stringWithFormat:@"%f",_currentLongitude] forKey:@"longitude"];
    
    [self addMarkerToMapWithInfo: markerInfo];
    
}





- (IBAction)currentLocationButtonAction:(id)sender {
    
    CLLocation *location = mapView_.myLocation;
    _currentLatitude = location.coordinate.latitude;
    _currentLongitude = location.coordinate.longitude;
    
    if (location) {
        
        GMSCameraUpdate *zoomCamera = [GMSCameraUpdate setTarget:CLLocationCoordinate2DMake(_currentLatitude, _currentLongitude) zoom:mapZoomLevel];
        [mapView_ animateWithCameraUpdate:zoomCamera];
    }
    
}



- (IBAction)searchAddressButtonAction:(id)sender
{
    [self performSegueWithIdentifier:@"toPickupAddressVC" sender:self];
    
}


#pragma mark - prepare Segue Navigation-

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"toPickupAddressVC"]) {
        
        PickUpViewController *pickController = [segue destinationViewController];
        pickController.latitude =  [NSString stringWithFormat:@"%f",mapView_.myLocation.coordinate.latitude];
        pickController.longitude = [NSString stringWithFormat:@"%f",mapView_.myLocation.coordinate.longitude];
        pickController.pickUpAddressDelegate = self;
        
        /* [AnimationsWrapperClass CATransitionAnimationType:kCATransitionMoveIn
         subType:kCATransitionFromTop
         forView:self.navigationController.view
         timeDuration:0.3];
         */
    }
    
    
    
    
}


#pragma mark - pickUpAddressDelegate
-(void)getAddressFromPickUpAddressVC:(NSDictionary *)addressDetails{

    
    
    NSString *latitudeString =[addressDetails objectForKey:@"lat"];
    NSString *longitudeString =[addressDetails objectForKey:@"lon"];
    NSString *AddressString =[addressDetails objectForKey:@"address"];
    
    [self updatedAddress:AddressString];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([latitudeString doubleValue],[longitudeString doubleValue]);
    
    AppointmentLocation * appointmentLocation=[AppointmentLocation new];
    appointmentLocation.currentLatitude=[NSNumber numberWithFloat:_currentLatitude];
    appointmentLocation.currentLongitude=[NSNumber numberWithFloat:_currentLongitude];
    appointmentLocation.dropOffLatitude=[NSNumber numberWithFloat:coordinate.latitude];
    appointmentLocation.dropOffLongitude=[NSNumber numberWithFloat:coordinate.longitude];
    appointmentLocation.pickUpAddress = AddressString;
    
    // set the aplocation equal to the marker in order to get the details later one
    apLocaion = appointmentLocation;
    
    [self creatMarkerForCoordinate:coordinate];

}

@end
