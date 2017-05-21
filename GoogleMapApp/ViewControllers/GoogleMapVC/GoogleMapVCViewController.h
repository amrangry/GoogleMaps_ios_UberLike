//
//  GoogleMapVCViewController.h
//  GoogleMapApp
//
//  Created by Amr Elghadban on 5/21/17.
//  Copyright © 2017 Karmadam. All rights reserved.
//

#import <UIKit/UIKit.h>



#import <GoogleMaps/GoogleMaps.h>

#import "GetCurrentLocation.h"

#import "PickUpViewController.h"

#import "AppointmentLocation.h"

#import "ParentUIViewController.h"

#import "MBProgressHUD.h"

@interface GoogleMapVCViewController : ParentUIViewController <CLLocationManagerDelegate,GetCurrentLocationDelegate,PickUpAddressDelegate>

{
    GetCurrentLocation *getCurrentLocation;
    GMSGeocoder *geocoder_;
    
    __weak IBOutlet GMSMapView *mapView_;
    
    AppointmentLocation *apLocaion;
}

@property(nonatomic,assign) float currentLatitude;
@property(nonatomic,assign) float currentLongitude;
@property(nonatomic,assign) float pickupLatitude;
@property(nonatomic,assign) float pickupLongitude;


//Top Address
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *searchAddressButton;
@property (weak, nonatomic) IBOutlet UIButton *currentLocationButton;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIView *addressView;



- (IBAction)searchAddressButtonAction:(id)sender;
- (IBAction)currentLocationButtonAction:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *bookBtn;
- (IBAction)bookBtnPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *historyBtnPressed;


@property (weak, nonatomic) IBOutlet UIView *timeAndDistanceView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;


@end

