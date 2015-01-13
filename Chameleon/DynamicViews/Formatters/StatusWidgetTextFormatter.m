//
//  StatusWidgetTextFormatter.m
//  mBSClient
//
//  Created by Maksim Voronin on 11.11.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "StatusWidgetTextFormatter.h"
#import "Value.h"
//#import "BssUtils.h"

@implementation StatusWidgetTextFormatter

-(NSString*) convertValueToString:(Value*)value
{
    if (value.isUnknown)
        return @"";
    return @"";
    //ToDo:return [BssUtils getStatusName:[value convertToInt]];
}

-(Value*) convertStringToValue:(NSString*) string ofType:(DataType) dataType
{
    return [Value unknown];
}

@end
