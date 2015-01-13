//
//  BaseFieldWidgetView.h
//  mBSClient
//
//  Created by Maksim Voronin on 23.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "BaseWidgetView.h"
#import "WidgetTextFormatter.h"

@interface BaseFieldWidgetView : BaseWidgetView <UITextFieldDelegate>

@property(nonatomic,strong) UITextField* textField;

@property(nonatomic,assign) int lines;
@property(nonatomic,strong) NSString* value;
@property(nonatomic,strong) NSString* hint;
@property(nonatomic,strong) NSString* fieldName;
@property(nonatomic,strong) NSString* format;
@property(nonatomic,assign) BOOL editable;
@property(nonatomic,assign) BOOL changing;
@property(nonatomic,readonly) id<WidgetTextFormatter> formatter;

-(void) setFieldValue:(Value*) value;

@end
