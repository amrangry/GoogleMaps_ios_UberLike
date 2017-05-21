//
//  GetDirectionController.h
//
//  Karmadam
//
//  Created by Amr Elghadban on 3/8/15.
//  Copyright (c) 2015 Amr Elghadban. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManager.h>




@protocol GetCurrentLocationDelegate <NSObject>

@optional
/**
 *  Location did update
 */
- (void)updatedLocation:(double)latitude and:(double)longitude;
/**
 *  Current Address
 */
- (void)updatedAddress:(NSString *)currentAddress;
/**
 *  Location did Fail
 */
- (void)didFailedLocationUpdate;

@end

@interface GetCurrentLocation : NSObject 

@property (weak, nonatomic) id<GetCurrentLocationDelegate>delegate;
+ (id)sharedInstance;
- (void)getLocation;

@end
