//
//  BaseFieldWidget.h
//  mBSClient
//
//  Created by Maksim Voronin on 31.07.14.
//  Copyright (c) 2014 Самсонов Николай. All rights reserved.
//

#import "BaseWidgetDescription.h"

@class WidgetIntProperty;
@interface BaseFieldWidgetDescription : BaseWidgetDescription
@property(nonatomic,strong) NSString* fieldName;
@property(nonatomic,strong) NSString* format;
@property(nonatomic,strong) WidgetStringProperty* value;
@property(nonatomic,strong) WidgetStringProperty* hint;
@property(nonatomic,strong) WidgetBooleanProperty* editable;
@property(nonatomic,strong) WidgetIntProperty* lines;
@property(nonatomic,strong) WidgetIntProperty* size;
@property(nonatomic,strong) WidgetBooleanProperty* labelVisible;
@end



