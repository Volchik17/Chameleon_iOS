//
//  GroupWidgetView.m
//  mBSClient
//
//  Created by Maksim Voronin on 23.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "GroupWidgetView.h"
#import "GroupWidgetDescription.h"

@implementation GroupWidgetView

- (id)initWithController:(WidgetController*)controller
{
    self = [super initWithController:controller];
    if (self)
    {
        _widgetsView = [NSMutableArray new];
    }
    return self;
}

-(NSString*) getWidgetType
{
    return @"Group";
}

-(void) registerStaticAttributes:(BaseWidgetDescription *)structureWidget
{
    [super registerStaticAttributes:structureWidget];
     self.labelsVisible = ((GroupWidgetDescription *)structureWidget).labelsVisible;
}

-(void) setLabelsVisible:(BOOL) labelsVisible
{
    _labelsVisible = labelsVisible;
    for (BaseWidgetView* widgetView in _widgetsView)
    {
        [widgetView setLabelVisible:self.labelsVisible];
    }
}

-(void) addChildWidget:(BaseWidgetView*)widgetView
{
    [_widgetsView addObject:widgetView];
    [self addSubview:widgetView];
    [widgetView setLabelVisible:self.labelsVisible];
}

-(void) onAfterChildrenInit
{
    for (BaseWidgetView* widgetView in _widgetsView)
    {
        [widgetView setLabelVisible:self.labelsVisible];
    }
    
    if (self.label.length <= 0)
    {
        [self.textLabel removeFromSuperview];
        self.textLabel = nil;
    }
}

#pragma mark constraints

-(void) setNewConstraints
{
    if (self.label.length > 0)
    {
        [self addTopBottomConstraintWithItem:self.textLabel toItem:nil];
        //левая привязка
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
        //ширина - 1\2 super view
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.5f constant:0.00]];
    }
    
    //сумма "весов" всех виджетов
    CGFloat summWeight = 0;
    
    for (int i=0; i < [_widgetsView count]; ++i)
    {
        BaseWidgetView* widgetObj = [_widgetsView objectAtIndex:i];
        summWeight = summWeight + (CGFloat)widgetObj.weight;
    }
    
    for (int i=0; i < [_widgetsView count]; ++i)
    {
        BaseWidgetView* widgetObj = [_widgetsView objectAtIndex:i];
        CGFloat multiplier  = 1.0f;
        if (summWeight != 0)
        {
            multiplier  = (1.0f/summWeight) * (CGFloat)widgetObj.weight;
        }
        
        id toItemWidth = self;
        //если есть лейбл то берем размер от лейбла, иначе от superView
        if (self.textLabel != nil)
        {
            toItemWidth = self.textLabel;
        }
        
        UIView* widgetView = [_widgetsView objectAtIndex:i];
        UIView* previousWidgetView = (i != 0 ? [_widgetsView objectAtIndex:i-1] : nil);        
        //первый виджет
        if (previousWidgetView == nil)
        {
            if (self.textLabel != nil)
            {
                [self addConstraint:[NSLayoutConstraint constraintWithItem:widgetView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.textLabel attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:1.0f]];
                
                [self addTopBottomConstraintWithItem:widgetView toItem:self.textLabel];
            }
            else
            {
                [self addConstraint:[NSLayoutConstraint constraintWithItem:widgetView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f]];
                [self addTopBottomConstraintWithItem:widgetView toItem:nil];
            }
        }
        else
        {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:widgetView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:previousWidgetView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:1.0f]];
            [self addTopBottomConstraintWithItem:widgetView toItem:previousWidgetView];
            
            if (summWeight == 0)
            {
                [self addConstraint:[NSLayoutConstraint constraintWithItem:widgetView attribute: NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:previousWidgetView attribute: NSLayoutAttributeWidth multiplier:1.0f constant:0.00f]];
            }
            else
            {
                if ((CGFloat)widgetObj.weight != 0)
                {
                    [self addConstraint:[NSLayoutConstraint constraintWithItem:widgetView attribute: NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:toItemWidth attribute: NSLayoutAttributeWidth multiplier:multiplier constant:0.00]];
                }
            }
        }
        
        if (i == [_widgetsView count]-1)
        {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:widgetView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:-0.0f]];
        }
    }
}

@end
