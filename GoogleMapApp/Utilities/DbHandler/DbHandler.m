
//  DbHandler.m
//
//  GoogleMapApp
//
//  Created by Amr Elghadban on 5/17/17.
//  Copyright © 2017 Karmadam. All rights reserved.
//

#import <sqlite3.h>
#import "DbHandler.h"
#import "GlobalMethods.h"
#import "SQliteManager.h"
#import "ConstantsVariables.h"
@implementation DbHandler

+(instancetype)sharedInstance{
    
    static DbHandler *sharedInstance = nil;
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
    }
    
    return sharedInstance;
    
}


- (instancetype)init
{
    if ((self = [super init]))
    {
        
    }
    return self;
}


-(BOOL)saveItem:(AppointmentLocation *)model {
    
    Boolean dbCopied = [GlobalMethods copyAppDBWithName:DatabaseFileName];
    
    if(dbCopied){
    
          NSString *   insertSQL = [NSString stringWithFormat:@"insert into RIDE (currentLatitude,currentLongitude,pickupLatitude,pickupLongitude,dropOffLatitude,dropOffLongitude,pointsToDrowRoute,pickUpAddress,bookingType,time,distance) values (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%ld\",\"%@\",\"%@\")",model.currentLatitude,model.currentLongitude,model.pickupLatitude,model.pickupLongitude,model.dropOffLatitude,model.dropOffLongitude,model.pointsToDrowRoute,model.pickUpAddress,(long)model.bookingType,model.time,model.distance];
      
        if(NSLOG_ENABLED)
            NSLog(@"inset %@",insertSQL);
        
        SQliteManager* manager=[[SQliteManager alloc]init];
        
        NSError * error;
       
        if(![manager executeQuery:insertSQL ToDBWithPath:[GlobalMethods getUserDocsFilePathWithName:DatabaseFileNameSqlite] AndError:&error]){
            
            if(NSLOG_ENABLED)
                NSLog(@"ERROR in SAVING:: %@",error.description);
            
            return false;
        }
    }else{
        return false;
    }
    return true;
}




-(NSArray *)getItems{
    [GlobalMethods copyAppDBWithName:DatabaseFileName];
    
    NSString *querySQL = [NSString stringWithFormat:@"select * from RIDE"];
    
    SQliteManager* manager=[[SQliteManager alloc]init];
    
    NSArray *data = [self ArrayOfItemFromArryOfRowData:[manager dataOfQuery:querySQL FromDBWithPath:[GlobalMethods getUserDocsFilePathWithName:DatabaseFileNameSqlite] AndClass:[NSMutableDictionary class]] ];
    
    
    return data;
}

#pragma -mark -
//////////////

-(NSMutableArray *) ArrayOfItemFromArryOfRowData:(id)arrayOfRowData {
    
    NSMutableArray *ArrayOfModels = [NSMutableArray new];
    if([arrayOfRowData isKindOfClass:[NSDictionary class]]){
        
        AppointmentLocation * model;
        
        model =[self dbDictToModel:arrayOfRowData];
        
        
        [ArrayOfModels addObject:model];
        
    }else{
        for (NSDictionary *dict in arrayOfRowData) {
            
            AppointmentLocation *model;
            
            model =[self dbDictToModel:dict];
            
            [ArrayOfModels addObject:model];
            
        }
    }
    return ArrayOfModels;
    
}








-(AppointmentLocation *)dbDictToModel:(NSDictionary*)dict{
    
    AppointmentLocation *model=[[AppointmentLocation alloc] initWithDictionary:dict];
    
    return model;
}



@end
