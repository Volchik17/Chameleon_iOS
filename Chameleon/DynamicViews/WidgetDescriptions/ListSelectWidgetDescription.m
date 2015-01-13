//
//  BssDataSelectWidget.m
//  mBSClient
//
//  Created by Maksim Voronin on 31.07.14.
//  Copyright (c) 2014 Самсонов Николай. All rights reserved.
//

#import "ListSelectWidgetDescription.h"
#import "HierarchicalXMLParser.h"

@interface ListValuesParser:NSObject<HierarchicalXMLParserDelegate>
{
    NSMutableArray* mValues;
}
-(instancetype) initWithValues:(NSMutableArray*) values;
@end

@interface ListFillsParser:NSObject<HierarchicalXMLParserDelegate>
{
    NSMutableDictionary* mFills;
}
-(instancetype) initWithFills:(NSMutableDictionary*) fills;
@end

@implementation ListSelectWidgetDescription

- (id)init
{
    self = [super init];
    if (self)
    {
        _values = [[NSMutableArray alloc] init];
    }
    return self;
}

-(NSString*) getWidgetType
{
    return @"ListSelect";
}


- (id<HierarchicalXMLParserDelegate>) didStartSubElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qualifiedName attributes:(NSDictionary*)attributeDict
{
    if ([elementName isEqualToString:@"values"])
    {
        ListValuesParser* subParser=[[ListValuesParser alloc] initWithValues:self.values];
        return subParser;
    }
    else
        return [super didStartSubElement:elementName namespaceURI:namespaceURI qualifiedName:qualifiedName attributes:attributeDict];
}

@end

@implementation ListValuesParser

-(instancetype) initWithValues:(NSMutableArray *)values
{
    self=[super init];
    if (self)
    {
        mValues=values;
    }
    return self;
}

- (id<HierarchicalXMLParserDelegate>) didStartSubElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qualifiedName attributes:(NSDictionary*)attributeDict
{
    if ([elementName isEqualToString:@"value"])
    {
        StructureListValue* listValue = [[StructureListValue alloc] init];
        [mValues addObject:listValue];
        return listValue;
    }
    else
        return nil;
}

@end

@implementation StructureListValue

- (id)init
{
    self = [super init];
    if (self)
    {
        _fills = [[NSMutableDictionary alloc] init];
        _value = @"";
    }
    return self;
}

- (void) didStartElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI
           qualifiedName:(NSString*)qualifiedName attributes:(NSDictionary*)attributeDict
{
    if ([attributeDict count] > 0)
    {
        if ([attributeDict valueForKey:@"id"] != nil)
            self.identifier = [attributeDict valueForKey:@"id"];
        if ([attributeDict valueForKey:@"value"] != nil)
            self.value = [attributeDict valueForKey:@"value"];
    }
}

- (id<HierarchicalXMLParserDelegate>) didStartSubElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qualifiedName attributes:(NSDictionary*)attributeDict
{
    if ([elementName isEqualToString:@"fills"])
    {
        ListFillsParser* subParser=[[ListFillsParser alloc] initWithFills: self.fills];
        return subParser;
    } else
        return nil;
}

@end

@implementation ListFillsParser

-(instancetype) initWithFills:(NSMutableDictionary *)fills
{
    self=[super init];
    if (self)
    {
        mFills=fills;
    }
    return self;
}

- (id<HierarchicalXMLParserDelegate>) didStartSubElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qualifiedName attributes:(NSDictionary*)attributeDict
{
    if ([elementName isEqualToString:@"fill"])
    {
        if ([attributeDict valueForKey:@"fieldName"] != nil && [attributeDict valueForKey:@"value"])
        {
            [mFills setObject:[attributeDict valueForKey:@"value"] forKey:[attributeDict valueForKey:@"fieldName"]];
        }
    }
    return nil;
}

@end

