//
//  SimpleFieldWidgetView.m
//  mBSClient
//
//  Created by Maksim Voronin on 23.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "SimpleFieldWidgetView.h"
#import "BaseFieldWidgetDescription.h"
#import "WidgetController.h"
#import "Field.h"
#import "WidgetTextFormatterFactory.h"

@implementation SimpleFieldWidgetView

-(void) setWidgetStyle:(NSString*)widgetStyle
{
    [super setWidgetStyle:widgetStyle];
}

-(void) constructContent
{
    [super constructContent];    
    _detailLabel = [[UILabel alloc] init];
    _detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _detailLabel.autoresizesSubviews = NO;
    [self addSubview:_detailLabel];
}

-(void) setFieldValue:(Value*) value
{
    if (!_detailLabel)
        return;
    NSString* string = [_formatter convertValueToString:value];
    _detailLabel.text = string;
}

-(void) registerStaticAttributes:(BaseWidgetDescription *)structureWidget
{
    [super registerStaticAttributes:structureWidget];
    _format = ((BaseFieldWidgetDescription *)structureWidget).format;
    _fieldName = ((BaseFieldWidgetDescription *)structureWidget).fieldName;
    Field* field = nil;
    if (_fieldName!=nil && _fieldName.length>0)
    {
        field=[self.controller getFieldByName:_fieldName];
    }
    _formatter = [WidgetTextFormatterFactory getFormatter:_format forDataType:field?[field getDataType]:STRING];
    if (_fieldName!=nil && _fieldName.length>0)
    {
        Field* field = [self.controller getFieldByName:_fieldName];
        if (field != nil)
        {
            if (!_changing)
            {
                _changing = YES;
                [self setFieldValue:[field getValue]];
                _changing = NO;
            }
            [self.controller registerTrackingForWidget:self forField:_fieldName];
        }
    }
}

-(void) onFieldChanged:(NSString*)fieldName
{
    if ([fieldName isEqualToString:_fieldName])
    {
        return;
    }
    Field* field = [self.controller getFieldByName:fieldName];
    if (field == nil)
    {
        return;
    }
    if (!_changing)
    {
        _changing = YES;
    }
    if (_detailLabel != nil)
    {
        _detailLabel.text = [field getValueAsString];
    }
    _changing = NO;
}

-(void) setFieldName:(NSString*)fieldName
{
    _fieldName = fieldName;
}

-(void) setValue:(NSString*)value
{
    if (_detailLabel != nil)
    {
        //тут нужно будет добавить форматирование
        NSString* string = [_formatter convertValueToString:[[Value alloc] initWithString:value]];
        _detailLabel.text = string;
    }
}

-(void) setHint:(NSString*)hint
{

}

-(NSString*) getWidgetType
{
    return @"SimpleField";
}

#pragma mark constraints

-(void) setNewConstraints
{
    [super setNewConstraints];
    
    [self addTopBottomConstraintWithItem:_detailLabel toItem:nil];
    
    if (self.labelVisible)
    {
        //ширина _detailLabel == textLabel
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_detailLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.textLabel attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f]];
    }
    else
    {
        // ширина textLabel
        [self.textLabel addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0.0f]];
    }    
    //левая привязка textLabel
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:1.0]];
    //левая привязка _detailLabel
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_detailLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.textLabel attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:1.0]];
    //правая привязка _detailLabel
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_detailLabel attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-1.0]];
}

@end
