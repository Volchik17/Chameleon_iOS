//
//  SimpleFieldWidgetView.h
//  mBSClient
//
//  Created by Maksim Voronin on 23.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "BaseFieldWidgetView.h"

@interface SimpleFieldWidgetView : BaseWidgetView
@property(nonatomic,strong) UILabel* detailLabel;
@property(nonatomic,assign) int lines;
@property(nonatomic,strong) NSString* value;
@property(nonatomic,strong) NSString* hint;
@property(nonatomic,strong) NSString* fieldName;
@property(nonatomic,strong) NSString* format;
@property(nonatomic,assign) BOOL editable;
@property(nonatomic,assign) BOOL changing;
@property(nonatomic,readonly) id<WidgetTextFormatter> formatter;
@end
