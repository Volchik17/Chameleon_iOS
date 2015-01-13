//
//  RecordListTableViewDataSource.h
//  mBSClient
//
//  Created by Volchik on 31.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ViewStructure.h"

@interface RecordListTableViewDataSource : NSObject<UITableViewDataSource>
{
    NSString* _bankId;
    NSArray* _recordList;
    NSMutableDictionary* _extraRecords;
    ViewStructure * _structureView;
    UITableView* __weak _tableView;
    NSMutableArray* _controllers;
}
@property(nonatomic,assign) UITableViewCellAccessoryType cellAccessoryType;

-(id)initWithBankId:(NSString*) bankId tableView:(UITableView*) tableView structureView:(ViewStructure *) structureView recordList:(NSArray*) recordList extraRecords:(NSMutableDictionary*) extraRecords;

-(id)initWithBankId:(NSString*) bankId tableView:(UITableView*) tableView structureView:(ViewStructure *) structureView recordList:(NSArray*) recordList;

-(void)reloadDataWithRecordList:(NSArray*) recordList;

@end
