//
//  CurrCodeISOWidgetTextFormatter.m
//  mBSClient
//
//  Created by Maksim Voronin on 11.11.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "CurrCodeISOWidgetTextFormatter.h"
#import "Value.h"

@implementation CurrCodeISOWidgetTextFormatter

-(NSString*) convertValueToString:(Value*)value
{
    if (value.isUnknown)
        return @"";
    
    NSString* currencyCode = [value convertToString];
    return currencyCode;
}

-(Value*) convertStringToValue:(NSString*) string ofType:(DataType) dataType
{
    return [Value unknown];
}

@end
