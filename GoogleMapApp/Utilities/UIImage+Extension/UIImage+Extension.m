//
//  UIImage+Extension.m
//  
//
//  Created by Amr Elghadban on 5/10/17.
//  Copyright © 2017 KarmaDam. All rights reserved.
//

#import "UIImage+Extension.h"
#import "ThreadHelper.h"
@implementation UIImage (Extension)



+ (UIImage *_Nullable)imageWithColor:(UIColor *_Nonnull)color; {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


+ (void) downloadImageURL:(NSString *_Nonnull) imageUrl onSuccess:(void (^_Nullable)(UIImage * _Nullable image))success andFailure:(void (^_Nonnull)(NSString * _Nonnull error))failure{

    NSURL *url=[NSURL URLWithString:imageUrl];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                            timeoutInterval:60];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                  {
                                      if (!error) {
                                          if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                                              NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                                              
                                              if(statusCode == 200){
                                                  dispatch_async(dispatch_get_main_queue(),^
                                                                 {
                                                                     if ( data ){
                                                                         
                                                                         UIImage *img = [[UIImage alloc] initWithData:data];
                                                                         
                                                                         runInUIThread(^{
                                                                             success(img);
                                                                         });
                                                                         
                                                                         
                                                                       
                                                                     }
                                                                 });
                                              }else if (statusCode==404){
                                                  
                                                  runInUIThread(^{
                                                      failure(@"404 Resource not found");
                                                  });
                                              }
                                          }
                                      } else{
                                          runInUIThread(^{
                                              failure(error.localizedDescription);
                                          });
                                      }
                                  }];
    [task resume];

}

@end
