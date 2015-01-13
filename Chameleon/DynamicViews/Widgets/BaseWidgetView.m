//
//  BaseWidgetView.m
//  mBSClient
//
//  Created by Maksim Voronin on 23.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "BaseWidgetView.h"
#import "BaseWidgetDescription.h"
#import "WidgetController.h"

@implementation BaseWidgetView

- (id)init
{
    @throw [NSException
            exceptionWithName:NSInternalInconsistencyException
            reason:@"Must use initWithViewController:"
            userInfo:nil];
}

-(NSString*) getWidgetType
{
    return nil;
}

- (id)initWithController:(WidgetController*)controller
{
    self = [super init];
    if (self)
    {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.autoresizesSubviews = NO;
        _controller = controller;
        [self constructContent];
        
    }
    return self;
}

-(void) constructContent
{
    _textLabel = [[UILabel alloc] init];
    _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _textLabel.autoresizesSubviews = NO;
    [self addSubview:_textLabel];
}

-(BOOL) isStableContent
{
    return YES;
}

-(void) onFieldChanged:(NSString*)fieldName
{
    
}

-(void) registerStaticAttributes:(BaseWidgetDescription *)structureWidget
{
    _widgetId = structureWidget.widgetId;
}

-(void) setLabel:(NSString*)label
{
    _label = label;
    if (_textLabel != nil)
    {
        _textLabel.text = label;
    }
}

-(void) setLabelVisible:(BOOL)labelVisible
{
    _labelVisible = labelVisible;
    if (_textLabel != nil)
    {
        _textLabel.hidden = !labelVisible;
    }
}

-(void) setVisible:(BOOL) visible
{
    _visible = visible;
    self.hidden = !visible;
}

-(void) setWidgetBackground:(NSString*) background
{

}

-(void) setWidgetStyle:(NSString*)widgetStyle
{
    _widgetStyle = widgetStyle;
}

-(void) setEnable:(BOOL)enable
{
    _enable = enable;
}

-(void) setWeight:(double)weight
{
    _weight = weight;
}

#pragma mark constraints

- (void)updateConstraints
{
    [self removeConstraints:self.constraints];
    [self setNewConstraints];
    [super updateConstraints];
}

-(void) setNewConstraints
{
    [self addTopBottomConstraintWithItem:_textLabel toItem:nil];
}

-(void) addTopBottomConstraintWithItem:(id)item toItem:(id)toItem
{
    if (toItem == nil)
        toItem = self;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:toItem attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:toItem attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-0.0]];
}

@end
