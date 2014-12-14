//
//  CustomField.m
//  mBSClient
//
//  Created by Maksim Voronin on 02.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "CustomField.h"
#import "DataType.h"
#import "FieldDescription.h"
#import "Value.h"

@implementation CustomField

- (id)initWithFieldName:(NSString*)aFieldName dataType:(DataType)aDataType
{
    self = [super init];
    if (self)
    {
        fieldName = aFieldName;
        dataType  = aDataType;
        value     = [[Value alloc] initWithDataType:dataType value:nil];
    }
    return self;
}

-(id) initWithFieldMetaStructure:(FieldDescription *)fieldTable
{
    self = [super init];
    if (self)
    {
        fieldName = fieldTable.fieldName;
        dataType  = fieldTable.dataType;
        value     = [[Value alloc] initWithDataType:dataType value:nil];
    }
    return self;
}

-(id) initWithField:(Field*)field
{
    self = [super init];
    if (self)
    {
        fieldName = [field getFieldName];
        dataType  = [field getDataType];
        value     = [field getValue];
    }
    return self;
}

-(Value*) getValue
{
    return value;
}

-(DataType) getDataType
{
    return dataType;
}

-(void) internalSetValue:(Value*) oValue
{
    value = [[Value alloc] initWithDataType:dataType value:[oValue getValue]];
}

@end
