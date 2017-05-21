
//
//  GetDirectionController.m
//  Homappy
//
//  Created by Rahul Sharma on 28/07/15.
//  Copyright (c) 2015 Rahul Sharma. All rights reserved.
//

#import "GetCurrentLocation.h"

#import <GoogleMaps/GoogleMaps.h>
#import "LocationServiceViewController.h"
#import "AppDelegate.h"

@interface GetCurrentLocation ()<CLLocationManagerDelegate>
{
    GMSGeocoder *geocoder_;
    CLLocationManager *locationManager;
}
@end

@implementation GetCurrentLocation

static GetCurrentLocation *share;

+ (id)sharedInstance
{
    if (!share)
    {
        share  = [[self alloc] init];
    }
    return share;
}

/**
 *  All Directions Method
 */

/*---------------------------------------*/
#pragma mark - CLLocation Delegate Method
/*---------------------------------------*/

- (void)getLocation
{
//    clmanager = [[CLLocationManager alloc] init];
//    geocoder_ = [[GMSGeocoder alloc]init];
//    
//    clmanager.delegate = self;
//    clmanager.distanceFilter = kCLDistanceFilterNone;
//    clmanager.desiredAccuracy = kCLLocationAccuracyBest;
//    if  ([clmanager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
//        [clmanager requestAlwaysAuthorization];
//    }
//    [clmanager startUpdatingLocation];
    //check location services is enabled
    
    if ([CLLocationManager locationServicesEnabled])
    {
        if (!locationManager) {
            
            locationManager = [[CLLocationManager alloc] init];
            locationManager.delegate = self;
            locationManager.distanceFilter = kCLDistanceFilterNone;
            locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            if  ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
            {
                [locationManager requestWhenInUseAuthorization];
            }
        }
        [locationManager startUpdatingLocation];
        
    }
    else {
        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Location Service" message:@"Unable to find your location, Please enable location services in settings." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alertView show];
    }

}

/*
 To Get Updated lattitude & longitude
 @return nil.
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    NSString *latitude = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
    
    //NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    if(latitude == 0 && longitude == 0)
//    {
//        if (self.delegate && [self.delegate respondsToSelector:@selector(didFailedLocationUpdate)])
//        {
//            [self.delegate didFailedLocationUpdate];
//        }
//    }
//    else
//    {
    
        //---------------OR---------------
        
    
        
        
         /*****************************************************/
        
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
         {
             if (!(error))
             {
                 CLPlacemark *placemark = [placemarks objectAtIndex:0];
                 
                 
                 
                 NSString *UserCurrentAddress = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
                 NSString *UserCurrentCountry= [placemark country];
                 NSString *UserCurrentCity =[placemark locality];
                 NSString * UserCurrentArea =[placemark subLocality];
                 NSString * UserCurrentZipCode= [placemark postalCode] ;
                
                 
                 
                 if (self.delegate && [self.delegate respondsToSelector:@selector(updatedAddress:)]) {
                     
                     [self.delegate updatedAddress:UserCurrentAddress];
                 }
                 
                 NSLog(@"'Get Current Location Class'- Current Location:\nAddress: %@\nLat: %@\nLong :%@\nCity: %@\nZipCode: %@\nCountry: %@\nArea: %@",UserCurrentAddress,latitude,longitude,UserCurrentCity,UserCurrentZipCode,UserCurrentCountry,UserCurrentArea);
             }
             else
             {
                 NSLog(@"Failed to update location : %@",error);
//                 if (self.delegate && [self.delegate respondsToSelector:@selector(didFailLocation)]) {
//                     [self.delegate didFailLocation];
//                 }
             }
         }];
        
        [locationManager stopUpdatingLocation];
        
    if (self.delegate && [self.delegate respondsToSelector:@selector(updatedLocation:and:)]) {
        [self.delegate updatedLocation:latitude.doubleValue and:longitude.doubleValue];
        }

//    }
}

/*
 To print error msg of location manager
 @param error msg.
 @return nil.
 */
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"locationManager failed to update location : %@",[error localizedDescription]);
    
    if ([[error domain] isEqualToString: kCLErrorDomain] && [error code] == kCLErrorDenied)
    {
        // The user denied your app access to location information.
        [self gotoLocationServicesMessageViewController];
    }
    else  if ([[error domain] isEqualToString: kCLErrorDomain] && [error code] == kCLErrorNetwork)
    {
        //Network-related error
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        [self gotoLocationServicesMessageViewController];
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse)//kCLAuthorizationStatusAuthorized
    {
        
        
     /*   AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        AMSlideMenuMainViewController *menu = [AMSlideMenuMainViewController getInstanceForVC:appDelegate.window.rootViewController];
        
        UINavigationController *navigationVC = menu.currentActiveNVC;
        UINavigationController *naviVC = (UINavigationController*) appDelegate.window.rootViewController;
        
        //If location VC Currently Showing
        if([navigationVC.topViewController isKindOfClass:[LocationServiceViewController class]]||
           [naviVC.topViewController isKindOfClass:[LocationServiceViewController class]])
        {
            [AnimationsWrapperClass CATransitionAnimationType:kCATransitionReveal
                                                      subType:kCATransitionFromBottom
                                                      forView:navigationVC.view
                                                 timeDuration:0.3];

            
           
            if(navigationVC == nil)
            {
                 [naviVC popViewControllerAnimated:NO];
            }
            else
            {
                [navigationVC popViewControllerAnimated:NO];
            }

            
        }*/
    }

}

/**
 *  Showing Location Service Message Controller (By Pushing)
 */
-(void)gotoLocationServicesMessageViewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    LocationServiceViewController *locationVC = [storyboard instantiateViewControllerWithIdentifier:@"locationVC"];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    UINavigationController *naviVC = (UINavigationController*) appDelegate.window.rootViewController;
    
     [naviVC pushViewController:locationVC animated:NO];
  
}

@end
