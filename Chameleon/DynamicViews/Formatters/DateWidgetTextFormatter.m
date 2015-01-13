//
//  DateWidgetTextFormatter.m
//  mBSClient
//
//  Created by Volchik on 09.11.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "DateWidgetTextFormatter.h"
#import "Value.h"
#import "FormatterUtils.h"

@implementation DateWidgetTextFormatter

-(NSString*) convertValueToString:(Value*) value
{
    if (value.isUnknown)
        return @"";
    return [FormatterUtils formateWithDate:[value convertToDate] format:@"dd.MM.yyyy"];
}

-(Value*) convertStringToValue:(NSString*)string ofType:(DataType) dataType
{
    if (string.length==0)
        return [Value unknown];
    
    NSDate* date = [FormatterUtils formateStringDate:string format:@"dd.MM.yyyy"];
    
    switch (dataType)
    {
        case STRING:
        {
            return [[Value alloc] initWithString:string];
        }
        case INTEGER:
        {
            int intervalMillis = [date timeIntervalSince1970] * 1000;
            return [[Value alloc] initWithInt:intervalMillis];
        }
        case DOUBLE:
        {
            double intervalMillis = [date timeIntervalSince1970] * 1000;
            return [[Value alloc] initWithDouble:intervalMillis];
        }
        case LONG:
        {
            NSDate* date = [FormatterUtils formateStringDate:string format:@"dd.MM.yyyy"];
            long long intervalMillis = [date timeIntervalSince1970] * 1000;
            return [[Value alloc] initWithLong:intervalMillis];
        }
        case MONEY:
        {
            return [Value unknown];
        }
        case DATE:
        {
            NSDate* date = [FormatterUtils formateStringDate:string format:@"dd.MM.yyyy"];
            return [[Value alloc] initWithDate:date];
        }
        case DATETIME:
        {
            NSDate* date = [FormatterUtils formateStringDate:string format:@"dd.MM.yyyy"];
            return [[Value alloc] initWithDateTime:date];
        }
        case BOOLEAN:
        {
            return [Value unknown];
        }
        case UNKNOWN:
        {
            return [Value unknown];
        }
    }
}

#pragma mark optional

-(NSString*) getMask
{
    return @"__.__.____";
}

- (BOOL)textField:(UITextField *)currentTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // ToDo: Реализовать
    return YES;
}

@end
