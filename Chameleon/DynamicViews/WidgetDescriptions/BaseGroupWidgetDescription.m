//
//  BssBaseGroupWidget.m
//  mBSClient
//
//  Created by Maksim Voronin on 31.07.14.
//  Copyright (c) 2014 Самсонов Николай. All rights reserved.
//

#import "BaseGroupWidgetDescription.h"
#import "HierarchicalXMLParser.h"
#import "BaseWidgetDescription.h"
#import "SimpleFieldWidgetDescription.h"
#import "LabelWidgetDescription.h"
#import "ButtonWidgetDescription.h"
#import "EditFieldWidgetDescription.h"
#import "DateSelectWidgetDescription.h"
#import "ListSelectWidgetDescription.h"
#import "WidgetDescriptionFactory.h"

@interface WidgetsParser : NSObject<HierarchicalXMLParserDelegate>
{
    NSMutableArray* mWidgets;
}
-(instancetype) initWithWidgets:(NSMutableArray*) widgets;
@end

@implementation BaseGroupWidgetDescription

@synthesize
    widgets;

- (id)init
{
    if(self = [super init])
    {
        widgets = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id<HierarchicalXMLParserDelegate>) didStartSubElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qualifiedName attributes:(NSDictionary*)attributeDict
{
    if ([elementName isEqualToString:@"widgets"])
    {
        WidgetsParser* subParser=[[WidgetsParser alloc] initWithWidgets:widgets];
        return subParser;
    } else
        return [super didStartSubElement:elementName namespaceURI:namespaceURI qualifiedName:qualifiedName attributes:attributeDict];
}

@end

@implementation WidgetsParser

-(instancetype) initWithWidgets:(NSMutableArray*) widgets
{
    self=[super init];
    if (self)
    {
        mWidgets=widgets;
    }
    return self;
}


- (id<HierarchicalXMLParserDelegate>) didStartSubElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qualifiedName attributes:(NSDictionary*)attributeDict
{
    id<HierarchicalXMLParserDelegate> newParser = nil;
    
    if ([elementName isEqualToString:@"widget"])
    {
        NSString* typeValue = [attributeDict valueForKey:@"type"];
        BaseWidgetDescription* widget = [WidgetDescriptionFactory structureWidgetWithType:typeValue];
        if (widget != nil)
        {
            [mWidgets addObject:widget];
            newParser = widget;
        }
    }
    return newParser;
}

@end