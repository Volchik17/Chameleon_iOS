//
//  Field.m
//  mBSClient
//
//  Created by Maksim Voronin on 22.09.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "Field.h"
#import "Value.h"
#import "DataType.h"

@implementation Field

-(NSString*) getFieldName
{
    return fieldName;
}

-(void) internalSetValue:(Value*) oValue
{
    NSAssert(false,@"Abstract error");
}

-(void) setValue:(Value*) oValue
{
    [self internalSetValue:oValue];
    if(_fieldValueChangeDelegate)
        [_fieldValueChangeDelegate onChangeValueOfField:self];
}

-(Value*) getValue
{
    NSAssert(false,@"Abstract error");
    return nil;
}

-(DataType) getDataType
{
    return UNKNOWN;
}

-(NSString*) getValueAsString
{
    return [[self getValue] convertToString];
}

-(int) getValueAsInteger
{
    return [[self getValue] convertToInt];
}

-(long long) getValueAsLong
{
    return [[self getValue] convertToLong];
}

-(NSDate*) getValueAsDate
{
    return [[self getValue] convertToDate];
}

-(double) getValueAsDouble
{
    return [[self getValue] convertToDouble];
}

-(BOOL) getValueAsBoolean
{
    return [[self getValue] convertToBool];
}

-(void) setStringValue:(NSString*)s
{
    NSValue *value = [NSValue value:&s withObjCType:@encode(NSString)];
    Value* oValue = [[Value alloc] initWithDataType:[self getDataType] value:value];
    [self setValue:oValue];
}

-(void) setIntValue:(int)i
{
    NSValue *value = [NSValue value:&i withObjCType:@encode(int)];
    Value* oValue = [[Value alloc] initWithDataType:[self getDataType] value:value];
    [self setValue:oValue];
}

-(void) setLongValue:(long long)l
{
    NSValue *value = [NSValue value:&l withObjCType:@encode(long long)];
    Value* oValue = [[Value alloc] initWithDataType:[self getDataType] value:value];
    [self setValue:oValue];
}

-(void) setDoubleValue:(double)d
{
    NSValue *value = [NSValue value:&d withObjCType:@encode(double)];
    Value* oValue = [[Value alloc] initWithDataType:[self getDataType] value:value];
    [self setValue:oValue];
}

-(void) setDateValue:(NSDate*)d
{
    NSValue *value = [NSValue value:&d withObjCType:@encode(NSDate)];
    Value* oValue = [[Value alloc] initWithDataType:[self getDataType] value:value];
    [self setValue:oValue];
}

-(void) setBooleanValue:(BOOL)b
{
    NSValue *value = [NSValue value:&b withObjCType:@encode(BOOL)];
    Value* oValue = [[Value alloc] initWithDataType:[self getDataType] value:value];
    [self setValue:oValue];
}

-(void) setNilValue
{
    [self setValue:[[Value alloc] initWithDataType:[self getDataType] value:nil]];
}

-(void) setXMLValue:(NSString*)xmlStr
{
    if (xmlStr.length > 0)
    {
        [self setStringValue:xmlStr];
    }
    else
    {
        [self setNilValue];
    }
}

-(BOOL) isNilValue
{
    return [self getValue] == nil;
}

-(NSString*) description
{
    return [NSString stringWithFormat:@"<%@: %p, \"%@=%@\" ",
            [self class], self, fieldName, [self getValueAsString]];
}

@end
