//
//  WidgetsTableViewDelegate.h
//  mBSClient
//
//  Created by Volchik on 30.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WidgetController.h"

@interface WidgetsTableViewDataSource : NSObject<UITableViewDataSource,WidgetVisibilityDelegate>
{
    WidgetController* _controller;
    UITableView* __weak _tableView;
    NSMutableArray* cells;
}
-(id) initWithWidgetController:(WidgetController*) controller tableView:(UITableView*) tableView;
@end
