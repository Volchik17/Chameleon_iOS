//
//  WidgetDateProperty.m
//  mBSClient
//
//  Created by Maksim Voronin on 21.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "WidgetDateProperty.h"
#import "Value.h"
#import "objc/runtime.h"
#import <objc/message.h>

@implementation WidgetDateProperty

-(Value*) convertFromString:(NSString*)value
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    return [[Value alloc] initWithDate:[dateFormatter dateFromString:value]];
}

-(Value*) convertFromValue:(Value*)value
{
    return [[Value alloc] initWithDate:[value convertToDate]];
}

-(void) setPropertyForWidget:(id)widget value:(Value*)value setterName:(NSString*) setterName
{
    ((void(*)(id, SEL,NSDate*))objc_msgSend)(widget, sel_registerName([setterName UTF8String]),[value convertToDate]);
}

@end
