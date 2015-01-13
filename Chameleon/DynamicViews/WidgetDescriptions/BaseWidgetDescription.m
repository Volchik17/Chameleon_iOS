//
//  BssBaseWidget.m
//  mBSClient
//
//  Created by Maksim Voronin on 31.07.14.
//  Copyright (c) 2014 Самсонов Николай. All rights reserved.
//

#import "BaseWidgetDescription.h"
#import "HierarchicalXMLParser.h"
#import "WidgetStringProperty.h"
#import "WidgetBooleanProperty.h"
#import "WidgetDoubleProperty.h"
#import "RunTimeUtil.h"
#import "objc/runtime.h"
#import <objc/message.h>

@implementation BaseWidgetDescription

- (id)init
{
    if(self = [super init])
    {
        _widgetId = @"";
        _label    = [[WidgetStringProperty alloc] initWithDefaultValue:@"" xmlTagName:nil loadingValue:@"loading..."];
        _visible  = [[WidgetBooleanProperty alloc] initWithDefaultValue:@"true"];
        _enable   = [[WidgetBooleanProperty alloc] initWithDefaultValue:@"true" xmlTagName:@"enabled"];
        _widgetStyle    = [[WidgetStringProperty alloc] initWithDefaultValue:@"" xmlTagName:@"style" ];
        _widgetBackground = [[WidgetStringProperty alloc] initWithDefaultValue:@"" xmlTagName:@"background" ];
        _weight   = [[WidgetDoubleProperty alloc] init];
    }
    return self;
}

-(NSString*) getWidgetType
{
    NSAssert(false,@"Abstract error");
    return @"";
}

-(void) parseAttributeWithName:(NSString*)attributeName attributeValue:(NSString*)attributeValue
{
    if ([[attributeName lowercaseString] isEqualToString:@"id"])
    {
        _widgetId = attributeValue;
    }
}

-(void) parseDynamicAttributes:(NSDictionary*)attributeDict class:(Class)c
{
    Class parentClass = [c superclass];
    
    if (parentClass != [NSObject class])
    {
        [self parseDynamicAttributes:attributeDict class:parentClass];
    }
    
    NSArray* allProperties = [RunTimeUtil propertyNamesWithClass:c];
    for (NSString* propertyName in allProperties)
    {
        Class propClass = [RunTimeUtil propertyClassWithName:propertyName class:c];
        // проверяем тип свойства
        if (![RunTimeUtil currentClass:propClass isKindOfClass:[WidgetProperty class]])
            continue;
        // определяем имя атрибута в xml
        WidgetProperty* widgetProperty = ((WidgetProperty*(*)(id, SEL))objc_msgSend)(self, sel_registerName([propertyName UTF8String]));
        NSString* xmlTagName = widgetProperty.xmlTagName!=nil && [widgetProperty.xmlTagName length]>0 ? widgetProperty.xmlTagName : propertyName;
        // вычитываем значение атрибута
        if ([attributeDict objectForKey:xmlTagName])
        {
            [widgetProperty setXMLValue:[attributeDict objectForKey:xmlTagName]];
        }
        else if (widgetProperty.defaultValue == nil)
        {
            [widgetProperty setUnchanged];
        }
        else
        {
            [widgetProperty setXMLValue:widgetProperty.defaultValue];
        }
    }
}

- (void) didStartElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI
             qualifiedName:(NSString*)qualifiedName attributes:(NSDictionary*)attributeDict
{
    if ([attributeDict count] > 0)
    {
        for (NSString* attributeDictKey in [attributeDict allKeys])
        {
            [self parseAttributeWithName:attributeDictKey attributeValue:[attributeDict objectForKey:attributeDictKey]];
        }
        [self parseDynamicAttributes:attributeDict class:[self class]];
    }
}

@end

