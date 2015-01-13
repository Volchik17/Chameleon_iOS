//
//  DictionarySelectWidgetDescription.m
//  mBSClient
//
//  Created by Maksim Voronin on 20.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "DictionarySelectWidgetDescription.h"

@interface DictionaryFillsParser:NSObject<HierarchicalXMLParserDelegate>
{
    NSMutableDictionary* mFills;
}
-(instancetype) initWithFills:(NSMutableDictionary*) fills;
@end

@implementation DictionarySelectWidgetDescription

- (id)init
{
    self = [super init];
    if (self)
    {
        _dictionary = @"";
        _lookupFieldName = @"";
        _fills = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(NSString*) getWidgetType
{
    return @"DictionarySelect";
}

-(void) parseAttributeWithName:(NSString*)attributeName attributeValue:(NSString*)attributeValue
{
    [super parseAttributeWithName:attributeName attributeValue:attributeValue];
    
    if ([[attributeName lowercaseString] isEqualToString:[@"dictionary" lowercaseString]])
    {
        self.dictionary = attributeValue;
    }
    else if ([[attributeName lowercaseString] isEqualToString:[@"lookupFieldName" lowercaseString]])
    {
        self.lookupFieldName = attributeValue;
    }
}

- (id<HierarchicalXMLParserDelegate>) didStartSubElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qualifiedName attributes:(NSDictionary*)attributeDict
{
    if ([elementName isEqualToString:@"fills"])
    {
        DictionaryFillsParser* subParser=[[DictionaryFillsParser alloc] initWithFills:self.fills];
        return subParser;
    } else
        return [super didStartSubElement:elementName namespaceURI:namespaceURI qualifiedName:qualifiedName attributes:attributeDict];
}

@end

@implementation DictionaryFillsParser

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

