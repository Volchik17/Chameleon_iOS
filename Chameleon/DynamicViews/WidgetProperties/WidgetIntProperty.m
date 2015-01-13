//
//  WidgetIntProperty.m
//  mBSClient
//
//  Created by Maksim Voronin on 21.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "WidgetIntProperty.h"
#import "Value.h"
#import "objc/runtime.h"
#import <objc/message.h>

@implementation WidgetIntProperty

-(Value*) convertFromString:(NSString*)value
{
    return [[Value alloc] initWithInt:[value intValue]];
}

-(Value*) convertFromValue:(Value*)value
{
    return [[Value alloc] initWithInt:[value convertToInt]];
}

-(void) setPropertyForWidget:(id)widget value:(Value*)value setterName:(NSString*) setterName
{
    ((void(*)(id,SEL,int))objc_msgSend)(widget, sel_registerName([setterName UTF8String]),[value convertToInt]);
}

@end
