//
//  GetDirectionController.h
//  Homappy
//
//  Created by Rahul Sharma on 28/07/15.
//  Copyright (c) 2015 Rahul Sharma. All rights reserved.
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
