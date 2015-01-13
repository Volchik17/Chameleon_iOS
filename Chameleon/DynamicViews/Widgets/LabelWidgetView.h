//
//  LabelWidgetView.h
//  mBSClient
//
//  Created by Maksim Voronin on 23.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "BaseWidgetView.h"
#import "WidgetTextFormatter.h"

@interface LabelWidgetView : BaseWidgetView
@property(nonatomic,strong) NSString* format;
@property(nonatomic,strong) NSString* fieldName;
@property(nonatomic,readonly) id<WidgetTextFormatter> formatter;
@end
