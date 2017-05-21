//
//  NSString+extention.m
//  GoogleMapApp
//
//  Created by Amr Elghadban on 5/17/17.
//  Copyright © 2017 Karmadam. All rights reserved.
//
#import "NSString+extention.h"

@implementation NSString (extention)

-(void) show:(id)sender{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:self preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okay = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okay];
    [sender presentViewController:alert animated:YES completion:nil];
}



+(NSString*) getStringValueForDouble:(double)doubleNumber andFractionPointNumberIs:(int) fractionNumber{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.maximumFractionDigits = fractionNumber;
    NSNumber *totalPriceNumber=[NSNumber numberWithDouble:doubleNumber];
    NSString *result = [formatter stringFromNumber:totalPriceNumber];
   /*solution#1 NSString* floatString = [NSString stringWithFormat:@"%g", totalPrice];*/
    /*
     solution#2
     NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setPositiveFormat:@"0.##"];
    NSLog(@"%@", [fmt stringFromNumber:[NSNumber numberWithFloat:25.342]]);
    */
    return result;
}
/*
 
 // Input
 NSString *originalString = value;
 
 // Intermediate
 NSString *numberString;
 
 NSScanner *scanner = [NSScanner scannerWithString:originalString];
 NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
 // Throw away characters before the first number.
 [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
 // Collect numbers.
 [scanner scanCharactersFromSet:numbers intoString:&numberString];
 
 // Result.
 long number = (long)[numberString longLongValue];
 NSLog(@"%ld",number);
 
 
 NSScanner* scanner2 = [NSScanner scannerWithString:value];
 long long valueToGet;
 if([scanner2 scanLongLong:&valueToGet] == YES) {
 
 }

 */
@end
