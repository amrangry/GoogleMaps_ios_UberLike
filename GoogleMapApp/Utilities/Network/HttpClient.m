//
//  HttpClient.m
//  Karmadam
//
//  Created by Amr Elghadban on 5/6/17.
//  Copyright © 2017 Karmadam. All rights reserved.
//

#import "HttpClient.h"
#import "ThreadHelper.h"
@implementation HttpClient



+(HttpClient *_Nonnull)sharedInstance{

        static HttpClient *_sharedClient = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _sharedClient = [[HttpClient alloc] init];
            //        [_sharedClient setAuthorizationHeaderWithUsername:@"miworlduser" password:@"miworldpass"];// Didn't work. I had to put user/pass in AFURLConnection didReceiveAuthenticationChallenge: method
        });
        
        return _sharedClient;
    }
    
    
    
    - (id)init {
        self = [super init];
        if (!self) {
            return nil;
        }
        
        return self;
    }




-(void)invokeAPI:(NSString *_Nonnull)urlString method:(HTTPRequestMethod)method parameters:(id _Nullable)params paramterFormat:(ParamterStructureType) paramterStructureType
contentTypeValue:(ContentTypeValue)contentTypeValueForHTTPHeaderField
customContentTypeValueForHTTPHeaderField:(id _Nullable)customContentTypeValueForHTTPHeaderField
       onSuccess:(void (^_Nullable)(NSData * _Nullable data))success andFailure:(void (^_Nonnull)(NSString * _Nonnull error))failure{
    
    NSString *stringURL = [NSString stringWithFormat:@"%@" , urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    
    if (method == HTTPRequestGET)
    {
        [request setHTTPMethod:@"GET"];
        NSDictionary *parameters = params;
        
        if (params) {
            // request body
            for (NSInteger i = 0; i < parameters.count; i++) {
                NSString *currentKey = [parameters.allKeys objectAtIndex:i];
                NSString *currentValue = [parameters.allValues objectAtIndex:i];
                NSString *subString;
                if (i == 0)
                {
                    subString = [NSString stringWithFormat:@"?%@=%@" ,currentKey,currentValue];
                }
                else
                {
                    subString = [NSString stringWithFormat:@"&%@=%@" ,currentKey,currentValue];
                }
                // stringURL = [stringURL stringByAppendingString:[subString stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
                stringURL = [stringURL stringByAppendingString:subString];
                
                //Working with Arabic urls
               // stringURL = [stringURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            }
            //            NSString *unescaped = stringURL;
            //            NSString *escapedString = [unescaped stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
            //            NSLog(@"escapedString: %@", escapedString);
            //            stringURL=escapedString;
        }
        
        
    }else {
    
        if (method == HTTPRequestPOST)         { [request setHTTPMethod:@"POST"];   }
        else if (method == HTTPRequestPUT)     { [request setHTTPMethod:@"PUT"];    }
        else if (method == HTTPRequestDELETE)  { [request setHTTPMethod:@"DELETE"]; }
       
        
        NSString *postDataString;
        
        if (paramterStructureType == paramterStructureTypeJSON) {
            
            NSError *error = nil;
            NSData *jsonData = [NSJSONSerialization
                                dataWithJSONObject:params
                                options:NSJSONWritingPrettyPrinted
                                error:&error];
            
            NSString *jsonString;
            
            if ([jsonData length] > 0 && error == nil){
                NSLog(@"Successfully serialized the dictionary into data = %@", jsonData);
                jsonString = [[NSString alloc] initWithData:jsonData
                                                   encoding:NSUTF8StringEncoding];
                NSLog(@"JSON String = %@", jsonString);
            } else if ([jsonData length] == 0 && error == nil){
                NSLog(@"No data was returned after serialization.");
            } else if (error != nil){
                NSLog(@"An error happened = %@", error);
            }
            
            postDataString = jsonString;
            
        }else{
            // parse data format to data
            if (params)
            {
                NSError *error = nil;
                if ([params isKindOfClass:[NSString class]]) {
                    
                    postDataString = params;
                    
                }else if([params isKindOfClass:[NSDictionary class]]){
                    
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params
                                                                       options:0
                                                                         error:&error];
                    NSString *jsonRequest = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    
                    NSLog(@"jsonRequest : %@",jsonRequest);
                    
                    NSDictionary *parameters=params;
                    
                    NSString *stringParam = @"";
                    if (parameters) {
                        // request body
                        for (NSInteger i = 0; i < parameters.count; i++) {
                            NSString *currentKey = [parameters.allKeys objectAtIndex:i];
                            NSString *currentValue = [parameters.allValues objectAtIndex:i];
                            NSString *subString;
                            if (i == 0)
                            {
                                subString = [NSString stringWithFormat:@"%@=%@" ,currentKey,currentValue];
                            }
                            else
                            {
                                subString = [NSString stringWithFormat:@"&%@=%@" ,currentKey,currentValue];
                            }
                            
                            stringParam = [stringParam stringByAppendingString:subString];
                            //working witharabic urls
                           // stringParam = [stringParam stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                        }
                        NSLog(@"param : %@ ",stringParam );
                    }
                    
                    
                    postDataString =stringParam;
                    
                }
                
                
            }
            
        }
        
        [request setHTTPBody:[postDataString dataUsingEncoding:NSUTF8StringEncoding]];
        
    }
    
    
    
    
    NSURL *url = [NSURL URLWithString:stringURL];
    [request setURL:[url standardizedURL]];
    
   
     // set Headers
    //set request content type we MUST set this value.
    NSString * contentTypeValue=nil;
    if(contentTypeValueForHTTPHeaderField==ContentTypeValue_MultiValues){
        if([customContentTypeValueForHTTPHeaderField isKindOfClass:[NSDictionary class]]){
            
            NSDictionary *parameters=customContentTypeValueForHTTPHeaderField;
            if (parameters) {
                // request body
                for (NSInteger i = 0; i < parameters.count; i++) {
                    
                    NSString *currentKey = [parameters.allKeys objectAtIndex:i];
                    NSString *currentValue = [parameters.allValues objectAtIndex:i];
                    
                    [request setValue:currentValue forHTTPHeaderField:currentKey];
                    
                }//end of for loop of paramters
            }//end of if paramters exist
        }// //end of check if customContent is Dictionary
        
    } else if (contentTypeValueForHTTPHeaderField!=ContentTypeValue_None) {
        switch (contentTypeValueForHTTPHeaderField) {
            case ContentTypeValue_MultipartFormData:
                // We need to add a header field named Content-Type with a value that tells that it's a form and also add a boundary.
                // I just picked a boundary by using one from a previous trace, you can just copy/paste from the traces.
                contentTypeValue=@"multipart/form-data; boundary=----WebKitFormBoundarycC4YiaUFwM44F6rT";
                //contentTypeValue=@"multipart/form-data";
                break;
            case ContentTypeValue_ApplicationJson:
                contentTypeValue=@"application/json; charset=utf-8";
                break;
            case ContentTypeValue_Application_x_www_form_urlencoded:
                contentTypeValue=@"application/x-www-form-urlencoded";
                break;
            default:
                if(customContentTypeValueForHTTPHeaderField){
                    contentTypeValue=customContentTypeValueForHTTPHeaderField;
                }
                break;
        }
        [request setValue:contentTypeValue forHTTPHeaderField:@"Content-Type"];
    }
    
    NSURLSession *session;
   

    // 4 - add custom headers, including the Authorization header
    
    if (_authenticationChallenge) {
        
        // 5 - create an NSURLSessionConfiguration instance
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        // 1 - define credentials as a string with format:
        //    "username:password"
        NSString *username = _username;
        NSString *password = _password;
        NSString *authString = [NSString stringWithFormat:@"%@:%@",
                                username,
                                password];
        
        NSData *authData = [authString dataUsingEncoding:NSUTF8StringEncoding];
        NSString *authValue = [NSString stringWithFormat: @"Basic %@",[authData base64EncodedStringWithOptions:0]];
       // [request setValue:authValue forHTTPHeaderField:@"Authorization"];
        
        [sessionConfig setHTTPAdditionalHeaders:@{
                                                  @"Authorization": authValue
                                                  }
         ];
        
        session =  [NSURLSession sessionWithConfiguration:sessionConfig delegate:self
                                            delegateQueue:nil];
        
    }else{
        session = [NSURLSession sharedSession];
    }

   

    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error)
        {
            // do something with the error
            
            runInUIThread(^{
                failure(error.localizedDescription);
            });
        }
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode == 200)
        {
            // success: do something with returned data
        
            
            runInUIThread(^{
                success(data);
            });
            
            
        } else {
            // failure: do something else on failure
            NSLog(@"httpResponse code: %@", [NSString stringWithFormat:@"%ld", (unsigned long)httpResponse.statusCode]);
            NSLog(@"httpResponse head: %@", httpResponse.allHeaderFields);
            
            runInUIThread(^{
                failure([NSString stringWithFormat:@"httpResponse code: %@", [NSString stringWithFormat:@"%ld", (unsigned long)httpResponse.statusCode]]);
            });
        }
        
    }];
    [task resume];

}
@end
