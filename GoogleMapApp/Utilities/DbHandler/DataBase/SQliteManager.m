//
//  SQliteManager.m
//  GoogleMapApp
//
//  Created by Amr Elghadban on 5/17/17.
//  Copyright © 2017 Karmadam. All rights reserved.
//

#import "SQliteManager.h"
#import <sqlite3.h>
#import "ConstantsVariables.h"

@implementation SQliteManager

- (NSArray*) dataOfQuery:(NSString*)query FromDBWithPath:(NSString*)dbPath AndClass:(Class)objectClass{
    
    NSMutableArray *resultArray = nil;

    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: dbPath ] == YES)
    {
        const char *dbpathString = [dbPath UTF8String];
        
        sqlite3 *database = nil;
        
        if (sqlite3_open(dbpathString, &database) == SQLITE_OK)
        {
            sqlite3_stmt *statement = nil;
            
            const char *sql_stmt = [query UTF8String];
            
             resultArray = [[NSMutableArray alloc]init];
            
            if (sqlite3_prepare_v2(database,sql_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                
//                NSArray* classProperties = [GlobalMethods propertyNames:objectClass];
                
                int columnCount = sqlite3_column_count(statement);
                
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    NSObject* item = [[objectClass alloc]init];
                    
                    for (int i=0; i<columnCount; i++) {
                        
                        NSString *probName = [[NSString alloc] initWithUTF8String:
                                              (const char *) sqlite3_column_name(statement, i)];
                        @try {
//                            if([classProperties containsObject:probName])
                            
                            id probValue = [[NSString alloc] initWithUTF8String:
                                            (const char *) sqlite3_column_text(statement, i)];
                            
                            [item setValue:probValue forKey:probName];
                        }
                        @catch (NSException *exception) {
                            if (NSLOG_ENABLED) {
                                NSLog(@"property not found");
                            }
                            
                        }
                    }
                    
                    [resultArray addObject:item];
                }
                
                sqlite3_finalize(statement);
                
            }else{
                NSLog(@"can't prepare statement");
            }
            
            sqlite3_close(database);
            
        }
        else {
            NSLog(@"database exist but can't open it");
        }
    }else{
        NSLog(@"DB file not found");
    }
    
    return [resultArray copy];
}

- (BOOL) executeQuery:(NSString*)query ToDBWithPath:(NSString*)dbPath AndError:(NSError**)error{
    
    BOOL result = NO;
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath:dbPath] == YES)
    {
        const char *dbpathString = [dbPath UTF8String];
        
        sqlite3 *database = nil;
        
        if (sqlite3_open(dbpathString, &database) == SQLITE_OK)
        {
            sqlite3_stmt *statement = nil;
            
            const char *sql_stmt = [query UTF8String];
            
            sqlite3_prepare_v2(database, sql_stmt,-1, &statement, NULL);
          
            if (sqlite3_step(statement) == SQLITE_DONE){
                result = YES;
            }else {
                result = NO;
            }
            
            sqlite3_reset(statement);
            
            sqlite3_finalize(statement);
            
            sqlite3_close(database);
        
        }
        else {
            NSLog(@"database exist but can't open it");
        }
    }else{
        NSLog(@"DB file not found");
    }
    
    return result;
}

@end
