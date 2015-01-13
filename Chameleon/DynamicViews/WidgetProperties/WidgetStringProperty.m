//
//  WidgetStringProperty.m
//  mBSClient
//
//  Created by Maksim Voronin on 21.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "WidgetStringProperty.h"
#import "Value.h"
#import "objc/runtime.h"
#import <objc/message.h>

@implementation WidgetStringProperty

-(Value*) convertFromString:(NSString*)value
{
    return [[Value alloc] initWithString:value];
}

-(Value*) convertFromValue:(Value*)value
{
    return [[Value alloc] initWithString:[value convertToString]];
}

-(void) setPropertyForWidget:(id)widget value:(Value*)value setterName:(NSString*) setterName
{
    ((void(*)(id,SEL,NSString*))objc_msgSend)(widget, sel_registerName([setterName UTF8String]),[value convertToString]);
}

@end
