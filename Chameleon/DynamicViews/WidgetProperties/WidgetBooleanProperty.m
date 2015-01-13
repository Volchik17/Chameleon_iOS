//
//  WidgetBooleanProperty.m
//  mBSClient
//
//  Created by Maksim Voronin on 21.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "WidgetBooleanProperty.h"
#import "Value.h"
#import "objc/runtime.h"
#import <objc/message.h>

@implementation WidgetBooleanProperty

-(Value*) convertFromString:(NSString*)value
{
    return [[Value alloc] initWithBOOL:[[value lowercaseString] isEqualToString:@"true"]||[value isEqualToString:@"1"]];
}

-(Value*) convertFromValue:(Value*)value
{
    return [[Value alloc] initWithBOOL:[value convertToBool]];
}

-(void) setPropertyForWidget:(id)widget value:(Value*)value setterName:(NSString*) setterName
{
    ((void(*)(id,SEL,BOOL))objc_msgSend)(widget, sel_registerName([setterName UTF8String]),[value convertToBool]);
}

@end
