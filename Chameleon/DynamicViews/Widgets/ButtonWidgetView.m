//
//  ButtonWidgetView.m
//  mBSClient
//
//  Created by Maksim Voronin on 23.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "ButtonWidgetView.h"

@implementation ButtonWidgetView

-(void) constructContent
{
    [super constructContent];
    _button = [[UIButton alloc] init];
    _button.backgroundColor = [UIColor colorWithRed:60.0/255.0 green:171.0/255.0 blue:255.0/255.0 alpha:1];
    _button.translatesAutoresizingMaskIntoConstraints = NO;
    _button.autoresizesSubviews = NO;
    [self addSubview:_button];
}

-(NSString*) getWidgetType
{
    return @"BUTTON";
}

-(void) setLabel:(NSString*)label
{
   // Текст метки всегда пустой, вместо этого устанавливаем текст самой кнопки.
    if (_button != nil)
    {
        [_button setTitle:label forState:UIControlStateNormal];
    }
}

#pragma mark constraints

-(void) setNewConstraints
{
    [super setNewConstraints];
    
    [self addTopBottomConstraintWithItem:_button toItem:nil];
    //левая привязка textLabel
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:1.0]];
    //левая привязка textField
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_button attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.textLabel attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:1.0]];
    //ширина _button == textLabel
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.textLabel attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f]];
    //правая привязка _button
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_button attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-1.0]];
}

@end
