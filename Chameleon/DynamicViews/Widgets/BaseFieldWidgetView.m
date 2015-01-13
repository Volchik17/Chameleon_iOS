//
//  BaseFieldWidgetView.m
//  mBSClient
//
//  Created by Maksim Voronin on 23.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "BaseWidgetView.h"
#import "BaseFieldWidgetView.h"
#import "BaseFieldWidgetDescription.h"
#import "WidgetController.h"
#import "WidgetTextFormatterFactory.h"
#import "Field.h"

@implementation BaseFieldWidgetView

-(void) constructContent
{
    [super constructContent];
    _textField = [[UITextField alloc] init];
    _textField.delegate = self;
    _textField.clearButtonMode = UITextFieldViewModeAlways;
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.translatesAutoresizingMaskIntoConstraints = NO;
    _textField.autoresizesSubviews = NO;
    _textField.autoresizingMask = UIViewAutoresizingNone;
    [self addSubview:_textField];
}

-(void) setFieldValue:(Value*) value
{
    if (!_textField)
        return;
    NSString* string = [_formatter convertValueToString:value];
    _textField.text = string;
}

-(void) registerStaticAttributes:(BaseWidgetDescription *)structureWidget
{
    [super registerStaticAttributes:structureWidget];
    _fieldName = ((BaseFieldWidgetDescription *)structureWidget).fieldName;
    Field* field = nil;
    if (_fieldName!=nil && _fieldName.length>0)
    {
        field=[self.controller getFieldByName:_fieldName];
    }
    _format = ((BaseFieldWidgetDescription *)structureWidget).format;
    _formatter = [WidgetTextFormatterFactory getFormatter:_format forDataType:field?[field getDataType]:STRING];
    if ([_formatter respondsToSelector:@selector(getMask)])
        _textField.placeholder = [_formatter getMask];
    else
        _textField.placeholder = @"";
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
    [self setFieldValue:[field getValue]];
    _changing = NO;
}

-(void) setFieldName:(NSString*)fieldName
{
    _fieldName = fieldName;
}

-(void) setHint:(NSString*)hint
{
    if (_textField != nil)
    {
        _hint = hint;
        if (_textField != nil)
        {
            _textField.placeholder = hint;
        }
    }
}

-(void) setEnable:(BOOL)enable
{
    [super setEnable:enable];
    if (_textField != nil)
    {
        _textField.enabled = enable;
    }
}

#pragma mark constraints

-(void) setNewConstraints
{
    [super setNewConstraints];
    
    [self addTopBottomConstraintWithItem:_textField toItem:nil];
    
    if (self.labelVisible)
    {
        //ширина _textField == textLabel
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_textField attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.textLabel attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f]];
    }
    else
    {
        // ширина textLabel
        [self.textLabel addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0.0f]];
    }    
    //левая привязка textLabel
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:1.0]];
    //левая привязка textField
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_textField attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.textLabel attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:1.0]];
    //правая привязка _detailLabel
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_textField attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-1.0]];
}

#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL bResult = NO;
    if ([_formatter respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)])
    {
        if ([_formatter textField:textField shouldChangeCharactersInRange:range replacementString:string])
        {
            Field* field = [self.controller getFieldByName:self.fieldName];
            if (field && self.enable && !self.changing)
            {
                _changing = YES;
                [field setValue:[_formatter convertStringToValue:textField.text ofType:[field getDataType]]];
                _changing = NO;
            }
        }
    }
    return bResult;
}

@end
