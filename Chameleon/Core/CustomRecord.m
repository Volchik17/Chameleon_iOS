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
