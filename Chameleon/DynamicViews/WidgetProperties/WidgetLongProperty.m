//
//  WidgetLongProperty.m
//  mBSClient
//
//  Created by Maksim Voronin on 21.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "WidgetLongProperty.h"
#import "Value.h"
#import "objc/runtime.h"
#import <objc/message.h>

@implementation WidgetLongProperty

-(Value*) convertFromString:(NSString*)value
{
    return [[Value alloc] initWithLong:[value longLongValue]];
}

-(Value*) convertFromValue:(Value*)value
{
    return [[Value alloc] initWithLong:[value convertToLong]];
}

-(void) setPropertyForWidget:(id)widget value:(Value*)value setterName:(NSString*) setterName
{
    ((void(*)(id,SEL,long long))objc_msgSend)(widget, sel_registerName([setterName UTF8String]),[value convertToLong]);
}

@end
