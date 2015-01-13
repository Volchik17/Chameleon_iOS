//
//  WidgetTextFormatterFactory.m
//  mBSClient
//
//  Created by Volchik on 09.11.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "WidgetTextFormatterFactory.h"
#import "WidgetTextFormatter.h"
#import "DefaultWidgetTextFormatter.h"
#import "DateWidgetTextFormatter.h"
#import "AccountWidgetTextFormatter.h"
#import "StatusWidgetTextFormatter.h"
#import "CurrCodeISOWidgetTextFormatter.h"
#import "AmountWidgetTextFormatter.h"

@implementation WidgetTextFormatterFactory

+(id<WidgetTextFormatter>) getDataTypeFormatter:(DataType) dataType
{
    switch (dataType)
    {
        case DATETIME:
        case DATE:
            return [[DateWidgetTextFormatter alloc] init];
        default:
            return [[DefaultWidgetTextFormatter alloc] init];
    }
}

+(id<WidgetTextFormatter>) getFormatter:(NSString*) format forDataType:(DataType) dataType
{
    if (format.length==0)
        return [self getDataTypeFormatter:dataType];
    if ([[format lowercaseString] isEqualToString:@"date"])
        return [[DateWidgetTextFormatter alloc] init];
    if ([[format lowercaseString] isEqualToString:@"account"])
        return [[AccountWidgetTextFormatter alloc] init];
    if ([[format lowercaseString] isEqualToString:@"status"])
        return [[StatusWidgetTextFormatter alloc] init];
    if ([[format lowercaseString] isEqualToString:@"currcodeiso"])
        return [[CurrCodeISOWidgetTextFormatter alloc] init];
    if ([[format lowercaseString] isEqualToString:@"amount"])
        return [[AmountWidgetTextFormatter alloc] init];
    else
         return [[DefaultWidgetTextFormatter alloc] init];
}

@end
