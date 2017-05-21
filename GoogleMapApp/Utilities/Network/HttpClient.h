//
//  HttpClient.h
//  Karmadam
//
//  Created by Amr Elghadban on 5/6/17.
//  Copyright © 2017 Karmadam. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    ReturnStructureType_JSON  = 0,
    ReturnStructureType_XML= 1,
}ReturnStructureType;

typedef enum {
    ContentTypeValue_ApplicationJson  = 0,
    ContentTypeValue_MultipartFormData = 1,
    ContentTypeValue_Application_x_www_form_urlencoded=2,
    ContentTypeValue_Custom = 99,ContentTypeValue_None=100,
    ContentTypeValue_MultiValues=200
    
}ContentTypeValue;

typedef enum {
    HTTPRequestGET  = 0,
    HTTPRequestPOST = 1,
    HTTPRequestPUT  = 2,
    HTTPRequestDELETE
}HTTPRequestMethod;

typedef enum {
    requestStructureArray  = 0,
    requestStructureDictionary = 1,
}RequestStructure;

typedef enum {
    paramterStructureTypeJSON  = 0,
    paramterStructureTypeFormData= 1,
    paramterStructureTypeNone= 99,
}ParamterStructureType;

@interface HttpClient : NSObject <NSURLSessionDelegate>

+(HttpClient *_Nonnull)sharedInstance;


-(void)invokeAPI:(NSString *_Nonnull)urlString method:(HTTPRequestMethod)method parameters:(id _Nullable)params paramterFormat:(ParamterStructureType) paramterStructureType
contentTypeValue:(ContentTypeValue)contentTypeValueForHTTPHeaderField
customContentTypeValueForHTTPHeaderField:(id _Nullable)customContentTypeValueForHTTPHeaderField
       onSuccess:(void (^_Nullable)(NSData * _Nullable data))success andFailure:(void (^_Nonnull)(NSString * _Nonnull error))failure;




//
// REST and unprompted HTTP Basic Authentication
//
@property (atomic) BOOL authenticationChallenge;
@property (atomic ,retain) NSString * _Nullable username;
@property (atomic ,retain) NSString * _Nullable password;


@end
