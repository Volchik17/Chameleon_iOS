//
//  Field.h
//  mBSClient
//
//  Created by Maksim Voronin on 22.09.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataType.h"
#import "Value.h"

@class Field;
@protocol FieldValueChangeDelegate <NSObject>

-(void)onChangeValueOfField:(Field*) field;

@end

@interface Field : NSObject
{
    NSString* fieldName;
}
@property (nonatomic,weak) id<FieldValueChangeDelegate> fieldValueChangeDelegate;
- (void)internalSetValue:(Value*) oValue;
- (void)setValue:(Value*) oValue;
- (Value*)getValue;

- (NSString*)getFieldName;
- (DataType)getDataType;

- (NSString*)getValueAsString;
- (int)getValueAsInteger;
- (long long)getValueAsLong;
- (NSDate*)getValueAsDate;
- (double)getValueAsDouble;
- (BOOL)getValueAsBoolean;

-(void) setStringValue:(NSString*)s;
-(void) setIntValue:(int)i;
-(void) setLongValue:(long long)l;
-(void) setDoubleValue:(double)d;
-(void) setDateValue:(NSDate*)d;
-(void) setBooleanValue:(BOOL)b;
-(void) setNilValue;
-(void) setXMLValue:(NSString*)xmlStr;

-(BOOL) isNilValue;

@end
