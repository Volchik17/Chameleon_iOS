//
//  FormatterUtils.m
//  mBSClient
//
//  Created by Maksim Voronin on 11.11.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "FormatterUtils.h"

@implementation FormatterUtils

+ (BOOL) checkTextWithRegularPattern:(NSString*)pattern string:(NSString*)string
{
    NSError *error = NULL;
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                                       options:NSRegularExpressionCaseInsensitive
                                                                                         error:&error];
    NSRange rangeString = NSMakeRange(0,string.length);
    NSArray *matches = [regularExpression matchesInString:string options:0 range:rangeString];
    
    // no match at all
    if ([matches count] == 0)
        return NO;
    
    NSTextCheckingResult *result = (NSTextCheckingResult*)[matches objectAtIndex:0];
    NSRange rng = result.range;
    
    if (rng.location == rangeString.location && rng.length == rangeString.length) return YES;
    return NO;
}

+(NSNumberFormatter*) amountFromatter
{
    NSLocale* locale = [NSLocale currentLocale];
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setCurrencySymbol:@""];
    [formatter setCurrencyGroupingSeparator:@" "];
    [formatter setPositiveSuffix:@""];
    [formatter setLocale:locale];
    [formatter setMaximumFractionDigits:2];
    [formatter setDecimalSeparator:@","];
    
    return formatter;
}

+ (NSDate*)formateStringDate:(NSString*)dateString format:(NSString*)format
{
    if (dateString.length == 0)
    {
        return nil;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *result = [dateFormatter dateFromString:dateString];
    return result;
}

+ (NSString*)formateWithDate:(NSDate*)date format:(NSString*)format
{
    return [self formateWithDate:date format:format timeZone:[NSTimeZone systemTimeZone]];
}

+ (NSString*)formateWithDate:(NSDate*)date format:(NSString*)format timeZone:(NSTimeZone*)timeZone
{
    if ([date isEqualToDate:[NSDate dateWithTimeIntervalSince1970:0]])
    {
        return @"--.--.----";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    NSLocale *locale = [NSLocale currentLocale];
    
    [dateFormatter setLocale:locale];
    [dateFormatter setDateFormat:format];
    [dateFormatter setTimeZone:timeZone];
    
    NSString *result = [dateFormatter stringFromDate:date];
    
    return result;
}

@end
