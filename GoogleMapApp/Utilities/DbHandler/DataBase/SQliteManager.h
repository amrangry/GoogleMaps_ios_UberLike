//
//  SQliteManager.h
//  GoogleMapApp
//
//  Created by Amr Elghadban on 5/17/17.
//  Copyright © 2017 Karmadam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQliteManager : NSObject

- (NSArray*) dataOfQuery:(NSString*)query FromDBWithPath:(NSString*)dbPath AndClass:(Class)objectClass;

- (BOOL) executeQuery:(NSString*)query ToDBWithPath:(NSString*)dbPath AndError:(NSError**)error;

@end
