//
//  AppointmentLocation.m
//
//  Karmadam
//
//  Created by Amr Elghadban on 3/8/15.
//  Copyright (c) 2015 Amr Elghadban. All rights reserved.
//

#import "AppointmentLocation.h"

@implementation AppointmentLocation




-(instancetype)initWithDictionary:(NSDictionary *)Dictionary{
    
    self=[super init];
    if (self) {
        NSDictionary *JSONDictionary=Dictionary;
        
        if (JSONDictionary) {
            for (NSString *key in JSONDictionary) {
                if ([key isEqualToString:@"id"]) {
                    NSString *value=[JSONDictionary objectForKey:@"id"];
                    [self setValue:value forKey:@"ride_id"];
                }else{
                    [self setValue:[JSONDictionary valueForKey:key] forKey:key];
                }
            }
            
        }
    }
    
    return self;
}


@end
