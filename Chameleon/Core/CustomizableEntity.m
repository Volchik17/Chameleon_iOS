//
//  CustomizableEntity.m
//  mBSClient
//
//  Created by Maksim Voronin on 03.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "CustomizableEntity.h"
#import "Value.h"
#import "CustomRecord.h"
#import <objc/message.h>
#import "Field.h"
#import "CustomField.h"

@interface SystemField : Field
{
    CustomizableEntity* entity;
    DataType dataType;
    SEL getter;
    SEL setter;
}
-(id) initWithFieldName:(NSString*)fName
                 getter:(SEL)fGetter
                 setter:(SEL)fSetter
               dataType:(DataType)dType
     customizableEntity:(CustomizableEntity*)customizableEntity;
@end

@implementation SystemField

-(id) initWithFieldName:(NSString*)fName
                 getter:(SEL)fGetter
                 setter:(SEL)fSetter
               dataType:(DataType)dType
     customizableEntity:(CustomizableEntity *)customizableEntity
{
    self = [super init];
    if (self)
    {
        fieldName = fName;
        dataType  = dType;
        getter = fGetter;
        setter = fSetter;
        entity    = customizableEntity;
        
    }
    return self;
}

-(Value*) getValue
{
    Value* value = nil;
    @try
    {
        switch (dataType)
        {
            case STRING:
            {
                NSString* retValue=((NSString*(*)(id, SEL))objc_msgSend)(entity, getter);
                return [[Value alloc] initWithString:retValue];
            }
            case INTEGER:
            {
                int retValue=((int(*)(id, SEL))objc_msgSend)(entity, getter);
                return [[Value alloc] initWithInt:retValue];
            }
            case LONG:
            {
                long long retValue=((long(*)(id, SEL))objc_msgSend)(entity, getter);
                return [[Value alloc] initWithLong:retValue];
            }
            case DOUBLE:
            case MONEY:
            {
                long retValue=((double(*)(id, SEL))objc_msgSend)(entity, getter);
                return [[Value alloc] initWithDouble:retValue];
            }
            case DATE:
            case DATETIME:
            {
                NSDate* retValue=((NSDate*(*)(id, SEL))objc_msgSend)(entity, getter);
                return [[Value alloc] initWithDateTime:retValue];
            }
            case BOOLEAN:
            {
                BOOL retValue=((BOOL(*)(id, SEL))objc_msgSend)(entity, getter);
                return [[Value alloc] initWithBOOL:retValue];
            }
            case UNKNOWN:
            {
                @throw [NSException exceptionWithName:@"Value type UNKNOWN." reason:nil userInfo:nil];
            }
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception - %@, class - %@ method getValue.",[exception reason], [self class]);
    }
    return value;
}

-(void) internalSetValue:(Value*) oValue
{
    @try
    {
        switch (dataType)
        {
            case STRING:
            {
                ((void(*)(id,SEL,NSString*))objc_msgSend)(entity, setter,[oValue convertToString]);
                break;
            }
            case INTEGER:
            {
                ((void(*)(id,SEL,int))objc_msgSend)(entity, setter,[oValue convertToInt]);
                break;
            }
            case LONG:
            {
                ((void(*)(id,SEL,long long))objc_msgSend)(entity, setter,[oValue convertToLong]);
                break;
            }
            case DOUBLE:
            {
                ((void(*)(id,SEL,double))objc_msgSend)(entity, setter,[oValue convertToDouble]);
                break;
            }
            case MONEY:
            {
                ((void(*)(id,SEL,double))objc_msgSend)(entity, setter,[oValue convertToDouble]);
                break;
            }
            case DATE:
            {
                ((void(*)(id,SEL,NSDate*))objc_msgSend)(entity, setter,[oValue convertToDate]);
                break;
            }
            case DATETIME:
            {
                ((void(*)(id,SEL,NSDate*))objc_msgSend)(entity, setter,[oValue convertToDate]);
                break;
            }
            case BOOLEAN:
            {
                ((void(*)(id,SEL,BOOL))objc_msgSend)(entity, setter,[oValue convertToBool]);
                break;
            }
            case UNKNOWN:
            {
                @throw [NSException exceptionWithName:@"Value type UNKNOWN." reason:nil userInfo:nil];
            }
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception - %@, class - %@ method internalSetValue.",[exception reason], [self class]);
    }
}

-(DataType) getDataType
{
    return dataType;
}

@end

@implementation CustomizableEntity

- (id)init
{
    self = [super init];
    if (self)
    {        
        customFields = [[CustomRecord alloc] init];
        systemFields = [[NSMutableDictionary alloc] init];
        [self registerFields];
    }
    return self;
}

- (Field*)getFieldWithName:(NSString*)name
{
    Field* field = [systemFields objectForKey:[name uppercaseString]];
    
    if (field != nil)
    {
        return field;
    }
    else
    {
        return [customFields getFieldWithName:name];
    }
    
    return nil;
}

- (NSArray*)getFieldNames
{
    NSMutableArray* fields = [NSMutableArray arrayWithArray:[systemFields allKeys]];
    [fields addObjectsFromArray:[customFields getFieldNames]];
    return fields;
}

- (int)size
{
    return [systemFields count] + [customFields size];
}

-(CustomRecord*) getCustomFields
{
    return customFields;
}

-(void) setCustomFields:(CustomRecord*)newCustomFields
{
    customFields = newCustomFields;
}

- (void) registerSystemField:(NSString*)fieldName
{
    [self registerSystemField:fieldName ForPropertyName:fieldName];
}

- (void) registerSystemField:(NSString*)fieldName ForPropertyName:(NSString*)propertyName
{
    objc_property_t property = class_getProperty([self class], [propertyName UTF8String]);
    if (property==NULL)
        return;
    SEL getter=sel_registerName([propertyName UTF8String]);
    NSMutableString * setterName=[propertyName mutableCopy];
    [setterName replaceCharactersInRange:NSMakeRange(0,1) withString:[[propertyName substringToIndex:1] uppercaseString]
     ];
    [setterName insertString:@"set" atIndex:0];
    [setterName appendString:@":"];
    SEL setter=sel_registerName([setterName UTF8String]);
    if (![self respondsToSelector:getter])
        return;
    if (![self respondsToSelector:setter])
        return;
    SystemField* systemField = nil;
    const char *type = property_getAttributes(property);
    NSString * typeString = [NSString stringWithUTF8String:type];
    NSArray  * attributes = [typeString componentsSeparatedByString:@","];
    NSString * typeAttribute = [attributes objectAtIndex:0];
    NSString * propertyType = [typeAttribute substringFromIndex:1];
    const char * rawPropertyType = [propertyType UTF8String];
    
    if (strcmp(rawPropertyType, @encode(BOOL)) == 0)
    {
        systemField = [[SystemField alloc] initWithFieldName:fieldName
                                                      getter:getter
                                                      setter:setter
                                                    dataType:BOOLEAN
                                          customizableEntity:self];
    }
    else if (strcmp(rawPropertyType, @encode(int)) == 0)
    {
        systemField = [[SystemField alloc] initWithFieldName:fieldName
                                                      getter:getter
                                                      setter:setter
                                                    dataType:INTEGER
                                          customizableEntity:self];
    }
    else if (strcmp(rawPropertyType, @encode(double)) == 0)
    {
        systemField = [[SystemField alloc] initWithFieldName:fieldName
                                                      getter:getter
                                                      setter:setter
                                                    dataType:DOUBLE
                                          customizableEntity:self];
    }
    else if (strcmp(rawPropertyType, @encode(long)) == 0)
    {
        systemField = [[SystemField alloc] initWithFieldName:fieldName
                                                      getter:getter
                                                      setter:setter
                                                    dataType:LONG
                                          customizableEntity:self];
    }
    else if ([typeAttribute hasPrefix:@"T@"] && [typeAttribute length] > 1)
    {
        NSString * typeClassName = [typeAttribute substringWithRange:NSMakeRange(3, [typeAttribute length]-4)];
        Class typeClass = NSClassFromString(typeClassName);
        if (typeClass != nil)
        {
            if (typeClass == [NSDate class])
            {
                systemField = [[SystemField alloc] initWithFieldName:fieldName
                                                              getter:getter
                                                              setter:setter
                                                            dataType:DATETIME
                                                  customizableEntity:self];
            }
            else if (typeClass == [NSString class])
            {
                systemField = [[SystemField alloc] initWithFieldName:fieldName
                                                              getter:getter
                                                              setter:setter
                                                            dataType:STRING
                                                  customizableEntity:self];
            }
        }
    }
    else
    {
        NSLog(@"Unknown system field type - %s .",rawPropertyType);
    }
    
    if (systemField != nil)
    {
        [systemFields setObject:systemField forKey:[fieldName uppercaseString]];
    }
}

- (void) registerFields
{}

- (void)encodeWithCoder:(NSCoder *)coder;
{
    for (NSString* fieldName in [systemFields allKeys])
        [coder encodeObject:[[self getFieldWithName:fieldName] getValue] forKey:[NSString stringWithFormat: @"systemFields.%@",fieldName]];
    [coder encodeObject:customFields forKey:@"customFields"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [super init];
    if (self != nil)
    {
        systemFields = [[NSMutableDictionary alloc] init];
        customFields = [coder decodeObjectForKey:@"customFields"];
        [self registerFields];
        for (NSString* fieldName in [systemFields allKeys])
            [[self getFieldWithName:fieldName] setValue:[coder decodeObjectForKey:[NSString stringWithFormat: @"systemFields.%@",fieldName]]];
        
    }
    return self;
}

@end

@implementation CustomizableEntityFullXMLParser

-(instancetype) initWithEntity:(CustomizableEntity*) entity
{
    self=[super init];
    if (self)
    {
        _entity=entity;
    }
    return self;
}

- (id<HierarchicalXMLParserDelegate>) didStartSubElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qualifiedName attributes:(NSDictionary*)attributeDict
{
    if ([elementName isEqualToString:@"field"])
    {
        NSString* name=[attributeDict objectForKey:@"name"];
        NSString* value=[attributeDict objectForKey:@"value"];
        if (value==nil)
            value=@"";
        Field* field=[_entity getFieldWithName:name];
        if (field)
        {
            [field setXMLValue:value];
            
        } else
        {
            NSString* typeStr=[attributeDict objectForKey:@"dataType"];
            if (typeStr==nil)
                typeStr=@"string";
            DataType type=getTypeWithName(typeStr);
            field=[_entity.getCustomFields addFieldWithName:name dataType:type];
            [field setXMLValue:value];
        }
    }
    return nil;
}

@end
