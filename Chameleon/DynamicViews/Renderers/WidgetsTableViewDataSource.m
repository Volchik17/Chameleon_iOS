//
//  WidgetsTableViewDelegate.m
//  mBSClient
//
//  Created by Volchik on 30.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "WidgetsTableViewDataSource.h"
#import "SimpleFieldWidgetView.h"
#import "EditableTextWidgetView.h"
#import "ButtonWidgetView.h"
#import "LabelWidgetView.h"
#import "DictionarySelectWidgetView.h"
#import "ListSelectWidgetView.h"
#import "DateSelectWidgetView.h"
#import "GroupWidgetView.h"
#import "GroupWidgetDescription.h"

@implementation WidgetsTableViewDataSource

-(void) populateCellList
{
    [cells removeAllObjects];
    for (BaseWidgetDescription* widget in _controller.viewStructure.structureWidgets.widgets)
    {
        if ([_controller isWidgetVisible:widget.widgetId])
            [cells addObject:widget.widgetId];
    }
}

-(id) initWithWidgetController:(WidgetController*) controller tableView:(UITableView*) tableView;
{
    self=[super init];
    if (self)
    {
        cells = [[NSMutableArray alloc] init];
        _tableView=tableView;
        _controller=controller;
        _controller.widgetVisibilityDelegate=self;
        [_controller startController];
        [self populateCellList];
    }
    return self;
}

-(void) onChangedVisibilityOfWidget:(NSString *)widgetId
{
    [self populateCellList];
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cells.count;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(BaseWidgetView*) createWidgetByType:(NSString*) widgetType
{
    if (widgetType == nil ||  [[widgetType lowercaseString] isEqualToString:@"string"])
    {
        return [[SimpleFieldWidgetView alloc] initWithController:_controller];
    }
    else if ([[widgetType lowercaseString] isEqualToString:@"edittext"])
    {
        return [[EditableTextWidgetView alloc] initWithController:_controller];
    }
    else if ([[widgetType lowercaseString] isEqualToString:@"button"])
    {
        return [[ButtonWidgetView alloc] initWithController:_controller];
    }
    else if ([[widgetType lowercaseString] isEqualToString:@"label"])
    {
        return [[LabelWidgetView alloc] initWithController:_controller];
    }
    else if ([[widgetType lowercaseString] isEqualToString:@"dictionaryselect"])
    {
        return [[DictionarySelectWidgetView alloc] initWithController:_controller];
    }
    else if ([[widgetType lowercaseString] isEqualToString:@"listselect"])
    {
        return [[ListSelectWidgetView alloc] initWithController:_controller];
    }
    else if ([[widgetType lowercaseString] isEqualToString:@"dateselect"])
    {
        return [[DateSelectWidgetView alloc] initWithController:_controller];
    }
    else if ([[widgetType lowercaseString] isEqualToString:@"group"])
    {
        return [[GroupWidgetView alloc] initWithController:_controller];
    }
    else if ([[widgetType lowercaseString] isEqualToString:@"simplefield"])
    {
        return [[SimpleFieldWidgetView alloc] initWithController:_controller];
    }
    else
    {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    BaseWidgetView* widget=[cell.contentView.subviews objectAtIndex:0];
    if (widget!=nil && [widget isKindOfClass:[BaseWidgetView class]])
        [_controller unregisterWidget:widget];
}

-(BaseWidgetView*) findWidgetInCell:(UITableViewCell*)selectCell
{
    if ([selectCell.contentView.subviews count]==0)
        return nil;
    id view=[selectCell.contentView.subviews objectAtIndex:0];
    if (view==nil)
        return nil;
    if (![view isKindOfClass:[BaseWidgetView class]] )
        return nil;
    return (BaseWidgetView*) view;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* widgetId=(NSString*)[cells objectAtIndex:indexPath.row];
    BaseWidgetDescription * widgetDescription = [_controller.viewStructure getWidgetById:widgetId];
    NSString *cellId = [widgetDescription getWidgetType];
    //[tableView reloadData]
    UITableViewCell *selectCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(selectCell == nil)
    {
        selectCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    BaseWidgetView* widget = [self findWidgetInCell:selectCell];
    if (widget != nil && [widget isKindOfClass:[BaseWidgetView class]] && [widget isStableContent])
    {
        [_controller unregisterWidget:widget];
        [_controller registerWidget:widget structureWidget:widgetDescription];
    }
    else
    {
        for (UIView* subview in selectCell.contentView.subviews)
           [subview removeFromSuperview];
        
        widget = [self createWidgetByType:[widgetDescription getWidgetType]];
        [selectCell.contentView addSubview:widget];
        [_controller registerWidget:widget structureWidget:widgetDescription];
        
        //for group widget
        if ([widget isKindOfClass:[GroupWidgetView class]])
        {
            GroupWidgetView* groupWidgetView = (GroupWidgetView*)widget;
            GroupWidgetDescription * structureGroupWidget = (GroupWidgetDescription*)widgetDescription;
            
            for (BaseWidgetDescription * childStructure in structureGroupWidget.widgets)
            {
                BaseWidgetView* childWidgetView = [self createWidgetByType:[[childStructure getWidgetType] lowercaseString]];
                [groupWidgetView addChildWidget:childWidgetView];
                [_controller registerWidget:childWidgetView structureWidget:childStructure];
            }
            [groupWidgetView onAfterChildrenInit];
        }
        
        [selectCell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:widget attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:selectCell.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:15.0]];
        [selectCell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:widget attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:selectCell.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:1.0]];
        [selectCell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:widget attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:selectCell.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-1.0]];
        [selectCell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:widget attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:selectCell.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-1.0]];
    }
    [selectCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return selectCell;
}

@end
