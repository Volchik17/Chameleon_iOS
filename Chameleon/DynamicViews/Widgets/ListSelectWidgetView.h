//
//  ListSelectWidgetView.h
//  mBSClient
//
//  Created by Maksim Voronin on 23.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "BaseSelectWidgetView.h"

// ToDo: @interface ListSelectWidgetView : BaseSelectWidgetView<ListSelectTableViewControllerDelegate>
@interface ListSelectWidgetView : BaseSelectWidgetView
@property(nonatomic,strong) NSArray* values;
@end
