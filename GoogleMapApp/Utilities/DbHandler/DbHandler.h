//
//  DirectoriesDbHandler.h
//  GoogleMapApp
//
//  Created by Amr Elghadban on 5/17/17.
//  Copyright © 2017 Karmadam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConstantsVariables.h"


#import "AppointmentLocation.h"

@interface DbHandler : NSObject



//+(DbHandler *)getSharedInstance;
+(instancetype)sharedInstance;

-(BOOL)saveItem:(AppointmentLocation *)model;
-(NSArray *)getItems;



@end
