//
//  RouteDetailsViewController.h
//  GoogleMapApp
//
//  Created by Amr Elghadban on 5/21/17.
//  Copyright © 2017 Karmadam. All rights reserved.
//

#import "ParentUIViewController.h"

#import <GoogleMaps/GoogleMaps.h>
#import "AppointmentLocation.h"

@interface RouteDetailsViewController : ParentUIViewController
{

    __weak IBOutlet GMSMapView *mapView_;
    
    


}

@property (nonatomic,retain) AppointmentLocation *appointmentLocaion;


@property (weak, nonatomic) IBOutlet UIView *timeAndDistanceView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end
