//
//  BssDocumentFormStructure.m
//  mBSClient
//
//  Created by Maksim Voronin on 30.07.14.
//  Copyright (c) 2014 Самсонов Николай. All rights reserved.
//

#import "ViewStructure.h"
#import "WidgetDescriptionFactory.h"
#import "HierarchicalXMLParser.h"
#import "WidgetDescriptionList.h"

@implementation ViewStructure

- (id)init
{
    if(self = [super init])
    {
        self.structureWidgets = [[WidgetDescriptionList alloc] init];
    }
    return self;
}

-(BaseWidgetDescription *) getWidgetById:(NSString*) widgetId
{
    for(BaseWidgetDescription * widget in _structureWidgets.widgets)
    {
        if([widget.widgetId isEqualToString:widgetId])
            return widget;
    }
    return nil;
}

- (id<HierarchicalXMLParserDelegate>) didStartSubElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qualifiedName attributes:(NSDictionary*)attributeDict
{
    if ([elementName isEqualToString:@"widget"] || [elementName isEqualToString:@"group"] || [elementName isEqualToString:@"vgroup"])
    {
        NSString* typeValue;
        if ([elementName isEqualToString:@"group"] || [elementName isEqualToString:@"vgroup"])
            typeValue = elementName;
        else
            typeValue = [attributeDict valueForKey:@"type"];
        BaseWidgetDescription * widget = [WidgetDescriptionFactory structureWidgetWithType:typeValue];
        if (widget != nil)
        {
            [self.structureWidgets.widgets addObject:widget];
            return widget;
        }
    }
    return nil;
}

@end

