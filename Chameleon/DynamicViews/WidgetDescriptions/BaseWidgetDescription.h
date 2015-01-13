//
//  BssBaseWidget.h
//  mBSClient
//
//  Created by Maksim Voronin on 31.07.14.
//  Copyright (c) 2014 Самсонов Николай. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HierarchicalXMLParser.h"
#import "WidgetBooleanProperty.h"
#import "WidgetStringProperty.h"
#import "WidgetDoubleProperty.h"

@interface BaseWidgetDescription : NSObject<HierarchicalXMLParserDelegate>

@property(nonatomic,strong) NSString* widgetId;
@property(nonatomic,strong,readonly) WidgetStringProperty*  label;
@property(nonatomic,strong,readonly) WidgetBooleanProperty* visible;
@property(nonatomic,strong,readonly) WidgetBooleanProperty* enable;
@property(nonatomic,strong,readonly) WidgetStringProperty*  widgetStyle;
@property(nonatomic,strong,readonly) WidgetStringProperty*  widgetBackground;
@property(nonatomic,strong,readonly) WidgetDoubleProperty*  weight;

-(NSString*) getWidgetType;
-(void) parseAttributeWithName:(NSString*)attributeName attributeValue:(NSString*)attributeValue;
@end

