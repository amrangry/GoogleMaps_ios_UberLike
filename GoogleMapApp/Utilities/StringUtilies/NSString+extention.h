//
//  NSString+extention.h
//  GoogleMapApp
//
//  Created by Amr Elghadban on 5/17/17.
//  Copyright © 2017 Karmadam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (extention)

-(void) show:(id)sender;
+(NSString*) getStringValueForDouble:(double)doubleNumber andFractionPointNumberIs:(int) fractionNumber;
@end
