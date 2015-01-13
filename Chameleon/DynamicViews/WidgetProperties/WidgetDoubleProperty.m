//
//  WidgetDoubleProperty.m
//  mBSClient
//
//  Created by Maksim Voronin on 21.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "WidgetDoubleProperty.h"
#import "Value.h"
#import "objc/runtime.h"
#import <objc/message.h>

@implementation WidgetDoubleProperty

-(Value*) convertFromString:(NSString*)value
{
    return [[Value alloc] initWithDouble:[value doubleValue]];
}

-(Value*) convertFromValue:(Value*)value
{
    return [[Value alloc] initWithDouble:[value convertToDouble]];
}

-(void) setPropertyForWidget:(id)widget value:(Value*)value setterName:(NSString*) setterName
{
    ((void(*)(id,SEL,double))objc_msgSend)(widget, sel_registerName([setterName UTF8String]),[value convertToDouble]);
}

@end
