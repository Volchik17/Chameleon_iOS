//
//  StringArrayParser.m
//  Chameleon
//
//  Created by Volchik on 21.01.15.
//  Copyright (c) 2015 Volchik. All rights reserved.
//

#import "StringArrayParser.h"

@implementation StringArrayParser

-(instancetype) initWithArray:(NSMutableArray*) data tagName:(NSString*) tagName attributeName:(NSString*) attributeName
{
    self=[super init];
    if (self)
    {
        _tagName=tagName;
        _attributeName=attributeName;
        _data=data;
    }
    return self;
}

- (id<HierarchicalXMLParserDelegate>) didStartSubElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qualifiedName attributes:(NSDictionary*)attributeDict
{
    if ([elementName isEqualToString:_tagName])
    {
        NSString* name=[attributeDict objectForKey:_attributeName];
        if (name)
            [_data addObject:name];
    }
    return nil;
}

@end
