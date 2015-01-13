//
//  FormatterUtils.h
//  mBSClient
//
//  Created by Maksim Voronin on 11.11.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormatterUtils : NSObject
+ (BOOL) checkTextWithRegularPattern:(NSString*)pattern string:(NSString*)string;
+ (NSNumberFormatter*) amountFromatter;
+ (NSDate*)formateStringDate:(NSString*)dateString format:(NSString*)format;
+ (NSString*)formateWithDate:(NSDate*)date format:(NSString*)format;
+ (NSString*)formateWithDate:(NSDate*)date format:(NSString*)format timeZone:(NSTimeZone*)timeZone;
@end
