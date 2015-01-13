//
//  RecordListTableViewDataSource.m
//  mBSClient
//
//  Created by Volchik on 31.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "RecordListTableViewDataSource.h"
#import "WidgetController.h"
#import "DynamicGroupView.h"

@implementation RecordListTableViewDataSource

-(id)initWithBankId:(NSString*) bankId tableView:(UITableView*) tableView structureView:(ViewStructure *) structureView recordList:(NSArray*) recordList extraRecords:(NSMutableDictionary*) extraRecords
{
    self=[super init];
    if (self!=nil)
    {
        _bankId=bankId;
        _tableView=tableView;
        _structureView=structureView;
        _recordList=recordList;
        _extraRecords=extraRecords;
        _controllers=[[NSMutableArray alloc] initWithCapacity:recordList.count];
        [self createControllers];
    }
    return self;
}

-(id)initWithBankId:(NSString*) bankId tableView:(UITableView*) tableView structureView:(ViewStructure *) structureView recordList:(NSArray*) recordList
{
    return [self initWithBankId:bankId tableView:tableView structureView:structureView recordList:recordList extraRecords:nil];
}

-(void) createControllers
{
    [_controllers removeAllObjects];
    for (id<IRecord> record in _recordList)
    {
        WidgetController* controller=[[WidgetController alloc] initWithBankId:_bankId record:record extraFields:_extraRecords viewStructure:_structureView];
        [_controllers addObject:controller];
        [controller startController];
    }
}

-(void)reloadDataWithRecordList:(NSArray*) recordList
{
    _recordList=recordList;
    [self createControllers];
    [_tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _recordList.count;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    DynamicGroupView * groupView=[cell.contentView.subviews objectAtIndex:0];
    if (groupView!=nil && [groupView isKindOfClass:[DynamicGroupView class]])
    {
        groupView.controller=nil;
    }
}

-(DynamicGroupView *) findGroupViewInCell:(UITableViewCell*) cell
{
    if (cell==nil)
        return nil;
    if (cell.contentView==nil)
        return nil;
    if (cell.contentView.subviews==nil)
        return nil;
    if ([cell.contentView.subviews count]==0)
        return nil;
    DynamicGroupView * result=[cell.contentView.subviews objectAtIndex:0];
    if (result==nil)
        return nil;
    if (![result isKindOfClass:[DynamicGroupView class]])
        return nil;
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WidgetController* controller=[_controllers objectAtIndex:indexPath.row];
    NSString* cellId = @"Cell";
    UITableViewCell *selectCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    DynamicGroupView * groupView=[self findGroupViewInCell:selectCell];
    if(selectCell == nil)
    {
        selectCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        groupView=[[DynamicGroupView alloc] initWithViewController:controller];
        [selectCell.contentView addSubview:groupView];
        [groupView startView];
    }
    else
    {
        if (groupView!=nil)
        {
            groupView.controller=controller;
        }
        else
        {
            for (UIView* subview in selectCell.contentView.subviews)
                [subview removeFromSuperview];
            
            groupView=[[DynamicGroupView alloc] initWithViewController:controller];
            [selectCell.contentView addSubview:groupView];
            [groupView startView];
        }
    };
    
    [selectCell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:groupView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:selectCell.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:15.0]];
    [selectCell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:groupView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:selectCell.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:1.0]];
    [selectCell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:groupView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:selectCell.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-1.0]];
    [selectCell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:groupView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:selectCell.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-1.0]];
    
    selectCell.accessoryType = _cellAccessoryType;
    
    return selectCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat result=0;
    WidgetController* controller=[_controllers objectAtIndex:indexPath.row];
    for (BaseWidgetDescription* widget in controller.viewStructure.structureWidgets.widgets)
    {
        if (![controller isWidgetVisible:widget.widgetId])
            continue;
        result=result+44;
    }
    return result;
}

@end
