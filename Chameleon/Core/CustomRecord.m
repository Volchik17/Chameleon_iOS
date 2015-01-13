//
//  CustomRecord.m
//  mBSClient
//
//  Created by Maksim Voronin on 03.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "CustomRecord.h"
#import "CustomField.h"

@implementation CustomRecord

- (id)init
{
    self = [super init];
    if (self)
    {
        fields = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (id)initWithRecord:(id<IRecord>)record
{
    self = [self init];
    if (self)
    {
        NSArray* fieldNames = [record getFieldNames];
        for (NSString* fieldName in fieldNames)
        {
            Field* field = [record getFieldWithName:fieldName];
            [fields setObject:[[CustomField alloc] initWithField:field] forKey:fieldName];
        }
    }
    return self;
}

- (void)clear
{
    [fields removeAllObjects];
}

- (void)addFieldWithCustomField:(CustomField*)field
{
    [fields setObject:field forKey:[[field getFieldName] uppercaseString]];
}

- (CustomField*)addFieldWithName:(NSString*)name
{
    CustomField* field = [[CustomField alloc] initWithFieldName:name dataType:INTEGER];
    [fields setObject:field forKey:[name uppercaseString]];
    return field;
}

- (CustomField*)addFieldWithName:(NSString*)name dataType:(DataType)type
{
    CustomField* field = [[CustomField alloc] initWithFieldName:name dataType:type];
    [fields setObject:field forKey:[name uppercaseString]];
    return field;
}

- (Field*)getFieldWithName:(NSString*)name;
{
    return [fields objectForKey:[name uppercaseString]];
}

- (NSArray*)getFieldNames
{
    return [fields allKeys];
}

-(int) size
{
    return [fields count];
}

-(NSEnumerator*) objectEnumerator
{
    return [[CustomRecordEnumerator alloc] initWithFields:fields];
}

-(id) copyWithZone:(NSZone *)zone
{
    CustomRecord* newRecord=[[CustomRecord allocWithZone:zone] initWithRecord:self];
    return newRecord;
}

@end

@implementation CustomRecordEnumerator

- (id)initWithFields:(NSMutableDictionary*)fields;
{
    self = [super init];
    if (self)
    {
        stack = [[NSMutableDictionary alloc] initWithCapacity:[fields count]];
        [stack setValuesForKeysWithDictionary:fields];
        internalEnumerator = [stack objectEnumerator];
    }
    return self;
}

- (NSArray *)allObjects
{
    return [[stack objectEnumerator] allObjects];
}

- (id)nextObject
{
    return [internalEnumerator nextObject];
}

@end

@implementation RecordXMLParser

-(instancetype) initWithRecord:(id<IRecord>) record
{
    self=[super init];
    if (self)
    {
        _record=record;
    }
    return self;
}

- (id<HierarchicalXMLParserDelegate>) didStartSubElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qualifiedName attributes:(NSDictionary*)attributeDict
{
    if ([elementName isEqualToString:@"field"])
    {
        NSString* name=[attributeDict objectForKey:@"name"];
        Field* field=[_record getFieldWithName:name];
        if (field!=nil)
        {
            NSString* value=[attributeDict objectForKey:@"value"];
            if (value==nil)
                value=@"";
            [field setXMLValue:value];
        }
    }
    return nil;
}

@end

@implementation CustomRecordFullXMLParser

-(instancetype) initWithRecord:(CustomRecord*) record
{
    self=[super init];
    if (self)
    {
        _record=record;
    }
    return self;
}

- (id<HierarchicalXMLParserDelegate>) didStartSubElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qualifiedName attributes:(NSDictionary*)attributeDict
{
    if ([elementName isEqualToString:@"field"])
    {
        NSString* name=[attributeDict objectForKey:@"name"];
        NSString* typeStr=[attributeDict objectForKey:@"dataType"];
        if (typeStr==nil)
            typeStr=@"string";
        DataType type=getTypeWithName(typeStr);
        CustomField* field=[_record addFieldWithName:name dataType:type];
        NSString* value=[attributeDict objectForKey:@"value"];
        if (value==nil)
            value=@"";
        [field setXMLValue:value];
    }
    return nil;
}

@end
