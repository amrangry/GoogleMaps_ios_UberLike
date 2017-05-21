//
//  AppointmentLocation.h
//
//  Karmadam
//
//  Created by Amr Elghadban on 3/8/15.
//  Copyright (c) 2015 Amr Elghadban. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppointmentLocation : NSObject



@property(nonatomic,strong)NSNumber *currentLatitude;
@property(nonatomic,strong)NSNumber *currentLongitude;
@property(nonatomic,strong)NSNumber *pickupLatitude;
@property(nonatomic,strong)NSNumber *pickupLongitude;
@property(nonatomic,strong)NSNumber *dropOffLatitude;
@property(nonatomic,strong)NSNumber *dropOffLongitude;


@property(nonatomic,strong)NSString *pointsToDrowRoute;

@property(nonatomic,strong)NSString *pickUpAddress;
@property(nonatomic,assign) NSInteger bookingType;

@property(nonatomic,strong)NSString *time;
@property(nonatomic,strong)NSString *distance;


/*  ID From Database */
@property (nonatomic ,strong)NSString *ride_id;
-(instancetype)initWithDictionary:(NSDictionary *)Dictionary;




@end
