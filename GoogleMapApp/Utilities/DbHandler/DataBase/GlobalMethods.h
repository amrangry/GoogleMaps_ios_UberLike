//
//  GlobalMethods.h
//  GoogleMapApp
//
//  Created by Amr Elghadban on 5/17/17.
//  Copyright © 2017 Karmadam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalMethods : NSObject

+(NSArray*)propertyNames: (Class) class;

+(NSString*)getUserDocsFilePathWithName:(NSString*)FileName;
// the same as
+(NSString *)getAppDocsFilePathWithName:(NSString*)FileName;

+(BOOL)copyFileIfNeededFromPath:(NSString*)fromPath ToPath:(NSString*)toPath AndError:(NSError**)error;

+ (BOOL)copyAppDBWithName:(NSString*)dbName;

@end
