//
//  GlobalMethods.m
//  GoogleMapApp
//
//  Created by Amr Elghadban on 5/17/17.
//  Copyright © 2017 Karmadam. All rights reserved.
//

#import "GlobalMethods.h"
#import "ConstantsVariables.h"
#import <objc/runtime.h>



@implementation GlobalMethods

#pragma makr-
#pragma mark class related methods

+ (NSArray *) propertyNames:(Class) class {
    
    NSMutableArray *propertyNames = [[NSMutableArray alloc] init];
    
    unsigned int propertyCount = 0;
    
    objc_property_t *properties = class_copyPropertyList(class, &propertyCount);
    
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        
        const char * name = property_getName(property);
        
        [propertyNames addObject:[NSString stringWithUTF8String:name]];
    }
    
    free(properties);
    
    return [propertyNames copy];
}

+(NSString*)getUserDocsFilePathWithName:(NSString*)fileName
{
    //Search for standard documents using NSSearchPathForDirectoriesInDomains
    //First Param = Searching the documents directory
    //Second Param = Searching the Users directory and not the System
    //Expand any tildes and identify home directories.
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    
    NSString *documentsDir = [paths objectAtIndex:0];
    if (NSLOG_ENABLED) {
    NSLog(@" document Dir : %@",documentsDir);
    }
	NSString* result=[documentsDir stringByAppendingPathComponent:fileName];
	
    
    if (NSLOG_ENABLED) {
        NSLog(@"path of db result:: %@",result);
    }
	
	
    return result;
}

+ (NSString *)getAppDocsFilePathWithName:(NSString*)FileName{
    
	NSString* result=[[[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]absoluteString] stringByAppendingPathComponent:FileName];
    
	NSLog(@"result:: %@",result);
	
    return result;
}

+(BOOL)copyFileIfNeededFromPath:(NSString*)fromPath ToPath:(NSString*)toPath AndError:(NSError**)error{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL success = [fileManager fileExistsAtPath:toPath];
    
    if(!success) {
        
        success = [fileManager copyItemAtPath:fromPath toPath:toPath error:error];
        
    }
    
    return success;
}


static bool success = NO;

+ (BOOL)copyAppDBWithName:(NSString*)dbName
{
    static dispatch_once_t onceToken1;
    
    dispatch_once(&onceToken1, ^{
        
        NSError* error;
        
       // success= [GlobalMethods copyFileIfNeededFromPath:[[NSBundle mainBundle] pathForResource:dbName ofType:@"sqlite"] ToPath:[GlobalMethods getUserDocsFilePathWithName:dbName]AndError:&error];
        
      success= [GlobalMethods copyFileIfNeededFromPath:[[NSBundle mainBundle] pathForResource:dbName ofType:@"db"] ToPath:[GlobalMethods getUserDocsFilePathWithName:[NSString stringWithFormat:@"%@%@.sqlite",dbName,DatabaseFileVersion]]AndError:&error];

        if(!success){
            NSLog(@"error coping DB %@",error.description);
        }
    });
    
    return success;
}




@end
