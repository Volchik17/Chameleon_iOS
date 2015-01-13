//
//  LabelWidgetView.m
//  mBSClient
//
//  Created by Maksim Voronin on 23.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "LabelWidgetView.h"
#import "LabelWidgetDescription.h"
#import "WidgetController.h"
#import "WidgetTextFormatterFactory.h"

@implementation LabelWidgetView

-(NSString*) getWidgetType
{
    return @"LABEL";
}

-(void) constructContent
{
    [super constructContent];
}

-(void) registerStaticAttributes:(BaseWidgetDescription *)structureWidget
{
    [super registerStaticAttributes:structureWidget];
    _format = ((LabelWidgetDescription *)structureWidget).format;
    _fieldName = ((LabelWidgetDescription *)structureWidget).fieldName;
    
    Field* field = nil;
    if (_fieldName!=nil && _fieldName.length>0)
    {
        field=[self.controller getFieldByName:_fieldName];
    }
    _formatter = [WidgetTextFormatterFactory getFormatter:_format forDataType:field?[field getDataType]:STRING];
}

-(void) setLabel:(NSString*)label
{
    Field* field = [self.controller getFieldByName:_fieldName];
    Value* value=[[Value alloc] initWithString:label];
    if (field)
        value=[[Value alloc] initWithDataType:[field getDataType] value:[NSValue value:&label withObjCType:@encode(NSString)]];
    NSString* string = [_formatter convertValueToString:value];
    [self.textLabel setText:string];
}

-(void) setEnable:(BOOL)enable
{
    [super setEnable:enable];
    if (self.textLabel != nil)
    {
        self.textLabel.enabled = enable;
    }
}

#pragma mark constraints

-(void) setNewConstraints
{
    [super setNewConstraints];
    //левая привязка
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    //правая привязка
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.textLabel attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
}

@end
