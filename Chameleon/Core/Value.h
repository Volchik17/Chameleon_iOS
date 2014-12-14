//
//  Value.h
//  mBSClient
//
//  Created by Maksim Voronin on 18.09.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataType.h"

@interface Value : NSObject

+ (id)unknown;
- (id)initWithDataType:(DataType)dt value:(NSValue*)vl;
- (id)initWithValue:(NSValue*)vl;
- (id)initWithString:(NSString*)string;
- (id)initWithInt:(int)i;
- (id)initWithLong:(long long)l;
- (id)initWithDouble:(double)d;
- (id)initWithDate:(NSDate*)date;
- (id)initWithDateTime:(NSDate*)date;
- (id)initWithBOOL:(BOOL)b;

- (DataType)getDataType;
- (NSValue*)getValue;
- (BOOL)isNil;
- (BOOL)isUnknown;

- (NSString*)convertToString;
- (double)convertToDouble;
- (long long)convertToLong;
- (int)convertToInt;
- (NSDate*)convertToDate;
- (BOOL)convertToBool;

+(Value*) valueOr:(Value*)v1 value:(Value*)v2;
+(Value*) valueAnd:(Value*)v1 value:(Value*)v2;
+(Value*) valueNot:(Value*)v1;
+(Value*) valueEqual:(Value*)v1 value:(Value*)v2;
+(Value*) valueNotEqual:(Value*)v1 value:(Value*)v2;
+(Value*) valueGreater:(Value*)v1 value:(Value*)v2;
+(Value*) valueGreaterEqual:(Value*)v1 value:(Value*)v2;
+(Value*) valueLesser:(Value*)v1 value:(Value*)v2;
+(Value*) valueLesserEqual:(Value*)v1 value:(Value*)v2;
+(Value*) valueAdd:(Value*)v1 value:(Value*)v2;
+(Value*) valueSubtract:(Value*)v1 value:(Value*)v2;
+(Value*) valueMultiply:(Value*)v1 value:(Value*)v2;
+(Value*) valueDivide:(Value*)v1 value:(Value*)v2;
+(Value*) valueMinus:(Value*)v;

@end
