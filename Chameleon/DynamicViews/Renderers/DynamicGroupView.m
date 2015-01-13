//
//  DynamicGroupView.m
//  mBSClient
//
//  Created by Maksim Voronin on 27.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "DynamicGroupView.h"
#import "BaseWidgetView.h"
#import "WidgetController.h"
#import "ViewStructure.h"
#import "WidgetDescriptionList.h"
#import "BaseWidgetDescription.h"
#import "GroupWidgetView.h"
#import "GroupWidgetDescription.h"
#import "LabelWidgetView.h"
#import "ButtonWidgetView.h"
#import "GroupWidgetView.h"
#import "SimpleFieldWidgetView.h"
#import "EditTextWidgetView.h"
#import "DateSelectWidgetView.h"
#import "DictionarySelectWidgetView.h"
#import "ListSelectWidgetView.h"

@implementation DynamicGroupView

- (id)init
{
    @throw [NSException
            exceptionWithName:NSInternalInconsistencyException
            reason:@"Must use initWithViewController:"
            userInfo:nil];
}

- (id)initWithViewController:(WidgetController*)controller
{
    self = [super init];
    if (self)
    {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.autoresizesSubviews = NO;
        
        _widgets     = [NSMutableArray new];
        _widgetsView = [NSMutableArray new];
        _controller  = controller;
    }
    return self;
}

-(void)startView
{
    [_controller startController];
    [self refreshContent];
}

-(void) refreshContent
{
    //ToDo: Сделать более умный рефреш чтобы виджеты по возможности не пересоздавались 
    for (BaseWidgetView* widgetView in _widgets)
    {
        [_controller unregisterWidget:widgetView];
    }
    
    [_widgets removeAllObjects];
    [_widgetsView removeAllObjects];
    
    for (UIView* subview in [self subviews])
        [subview removeFromSuperview];
    
    ViewStructure * structureView = _controller.viewStructure;
    for (BaseWidgetDescription * structureWidget in structureView.structureWidgets.widgets)
    {
        if ([_controller isWidgetVisible:structureWidget.widgetId] == NO)
            continue;
        
        BaseWidgetView* widgetView = [self createWidget:structureWidget];
        [self addSubview:widgetView];
        
        [_controller registerWidget:widgetView structureWidget:structureWidget];
        [_widgets addObject:widgetView];
        [_widgetsView addObject:widgetView];
       
        if ([widgetView isKindOfClass:[GroupWidgetView class]])
        {
            GroupWidgetView* groupWidgetView = (GroupWidgetView*)widgetView;
            GroupWidgetDescription * structureGroupWidget = (GroupWidgetDescription *)structureWidget;
            
            for (BaseWidgetDescription * childStructure in structureGroupWidget.widgets)
            {
                BaseWidgetView* childWidgetView = [self createWidget:childStructure];
                [groupWidgetView addChildWidget:childWidgetView];
                [_controller registerWidget:childWidgetView structureWidget:childStructure];
                [_widgets addObject:childWidgetView];
            }            
            [groupWidgetView onAfterChildrenInit];
        }
    }
    [self refreshConstraints];
}

-(void) refreshConstraints
{
    [self removeConstraints:self.constraints];
    
    for (int i=0; i < [_widgetsView count]; ++i)
    {
        BaseWidgetView* widgetView = [_widgetsView objectAtIndex:i];
        BaseWidgetView* previousWidgetView = (i != 0 ? [_widgetsView objectAtIndex:i-1] : nil);
        
        if (previousWidgetView == nil)
        {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:widgetView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:8.0f]];
        }
        else
        {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:previousWidgetView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:widgetView attribute:NSLayoutAttributeTop multiplier:1.f constant:-8.f]];
            
            [self addConstraint:[NSLayoutConstraint constraintWithItem:widgetView attribute: NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:previousWidgetView attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f]];
        }
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:widgetView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:widgetView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f]];
        
        if (i == [_widgetsView count]-1)
        {
            [self addConstraint:[NSLayoutConstraint constraintWithItem:widgetView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-8.0f]];
        }
    }
}

//ToDo: Пока фабрика тупая и прямо здесь
-(BaseWidgetView*) createWidget:(BaseWidgetDescription *)structureWidget
{
    if ([[[structureWidget getWidgetType] lowercaseString] isEqualToString:@"label"])
        return [[LabelWidgetView alloc] initWithController:_controller];
    else if ([[[structureWidget getWidgetType] lowercaseString] isEqualToString:@"button"])
        return [[ButtonWidgetView alloc] initWithController:_controller];
    else if ([[[structureWidget getWidgetType] lowercaseString] isEqualToString:@"group"])
        return [[GroupWidgetView alloc] initWithController:_controller];
    else if ([[[structureWidget getWidgetType] lowercaseString] isEqualToString:@"simplefield"])
        return [[SimpleFieldWidgetView alloc] initWithController:_controller];
    else if ([[[structureWidget getWidgetType] lowercaseString] isEqualToString:@"edittext"])
        return [[EditTextWidgetView alloc] initWithController:_controller];
    else if ([[[structureWidget getWidgetType] lowercaseString] isEqualToString:@"dateselect"])
        return [[DateSelectWidgetView alloc] initWithController:_controller];
    else if ([[[structureWidget getWidgetType] lowercaseString] isEqualToString:@"dictionaryselect"])
        return [[DictionarySelectWidgetView alloc] initWithController:_controller];
    else if ([[[structureWidget getWidgetType] lowercaseString] isEqualToString:@"listselect"])
        return [[ListSelectWidgetView alloc] initWithController:_controller];
    else return nil;
}

-(void) setController:(WidgetController *)controller
{
    [controller startController];
    for (BaseWidgetView* widgetView in _widgets)
    {
        [_controller unregisterWidget:widgetView];
    }
    
    [_widgets removeAllObjects];
    [_widgetsView removeAllObjects];

    _controller=controller;
    [self refreshContent];
}

@end
