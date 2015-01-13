//
//  Expression.h
//  mBSClient
//
//  Created by Maksim Voronin on 10.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 Target -> <Expression>
 Tokens -> <IDENTIFIER> <NUMBER> <STRING> <LOCALRES>
 
 <Expression> ::= <ORExpression> |
 <ORExpression> ::= <ANDExpression> { "||" <ANDExpression> }
 <ANDExpression> ::= <NotExpression> { "&&" <NotExpression> }
 <NotExpression> ::= { "!" } <CompareExpression>
 <CompareExpression> ::=  <AddExpression> { <RelationOperator> <AddExpression> }
 <RelationOperator> ::= ">" | "<" | "==" | "!=" | ">=" | "<="
 <AddExpression> ::= <MultExpression> { <AddOperator> <MultExpression> }
 <AddOperator> ::= "+" | "-"
 <MultExpression> ::= <MinusExpression> { <MultOperator> <MinusExpression> }
 <MultOperator> ::= "*" | "/"
 <MinusExpression> ::= { "-" } <TermExpression>
 <TermExpression> ::= "(" <ORExpression> ")" | <FieldName> | <RecordFieldName> | <Function> | <LOCALRES> | <STRING> | <NUMBER> | "null" | "unchanged" | "true" | "false"
 <FieldName> ::= <IDENTIFIER>
 <RecordFieldName> ::= <IDENTIFIER> "." <IDENTIFIER>
 <Function> ::= <IDENTIFIER> "(" <Expression> { "," <Expression> }  ")"
 */

typedef enum
{
    roEqual,
    roNotEqual,
    roGreater,
    roLesser,
    roGreatEqual,
    roLessEqual,
} RelationOperator;

typedef enum
{
    aoAdd,
    aoSubtract,
} AddOperator;

typedef enum
{
    moMultiply,
    moDivision,
} MultOperator;

typedef enum
{
    tetComplex,
    tetFieldName,
    tetRecordFieldName,
    tetFunction,
    tetLocalRes,
    tetConstant,
} TermType;

typedef enum
{
    ccString,
    ccInteger,
    ccFloat,
    ccNULL,
    ccUnchanged,
    ccFalse,
    ccTrue,
} ConstantType;

@class ORExpression;
@interface Expression : NSObject
@property(nonatomic,assign,readonly) BOOL longRunning;
@property(nonatomic,assign,readonly) BOOL longRunningCalculated;
@property(nonatomic,strong,readonly) ORExpression* expression;
- (id) initWithORExpression:(ORExpression*)newExpression;
- (BOOL) isLongRunning;
- (NSArray*) getFieldDependencies;
@end

@class ANDExpression;
@interface ORExpression : NSObject
@property(nonatomic,strong,readonly) ANDExpression* expression;
@property(nonatomic,strong,readonly) NSMutableArray* operands;
- (id) initWithANDExpression:(ANDExpression*)newExpression;
- (void) addOperand:(ANDExpression*)operand;
- (BOOL) isLongRunning;
- (void) getFieldDependencies:(NSMutableSet*)fields;
@end

@class NotExpression;
@interface ANDExpression : NSObject
@property(nonatomic,strong,readonly) NotExpression* expression;
@property(nonatomic,strong,readonly) NSMutableArray* operands;
- (id) initWithNotExpression:(NotExpression*)newExpression;
- (void) addOperand:(NotExpression*)operand;
- (BOOL) isLongRunning;
- (void) getFieldDependencies:(NSMutableSet*)fields;
@end

@class CompareExpression;
@interface NotExpression : NSObject
@property(nonatomic,strong,readonly) CompareExpression* expression;
@property(nonatomic,assign,readonly) int notCount;
- (id) initWithCompareExpression:(CompareExpression*)newExpression notCount:(int)newNotCount;
- (BOOL) isLongRunning;
- (void) getFieldDependencies:(NSMutableSet*)fields;
@end

@class AddExpression;
@interface CompareExpression : NSObject
@property(nonatomic,strong,readonly) AddExpression* expression;
@property(nonatomic,strong,readonly) NSMutableArray* operators;
@property(nonatomic,strong,readonly) NSMutableArray* operands;
- (id) initWithAddExpression:(AddExpression*)newExpression;
- (void) addOperand:(RelationOperator)operator operand:(AddExpression*)operand;
- (BOOL) isLongRunning;
- (void) getFieldDependencies:(NSMutableSet*)fields;
@end

@class MultExpression;
@interface AddExpression : NSObject
@property(nonatomic,strong,readonly) MultExpression* expression;
@property(nonatomic,strong,readonly) NSMutableArray* operators;
@property(nonatomic,strong,readonly) NSMutableArray* operands;
- (id) initWithMultExpression:(MultExpression*)newExpression;
- (void) addOperand:(AddOperator)operator operand:(MultExpression*)operand;
- (BOOL) isLongRunning;
- (void) getFieldDependencies:(NSMutableSet*)fields;
@end

@class MinusExpression;
@interface MultExpression : NSObject
@property(nonatomic,strong,readonly) MinusExpression* expression;
@property(nonatomic,strong,readonly) NSMutableArray* operators;
@property(nonatomic,strong,readonly) NSMutableArray* operands;
- (id) initWithMinusExpression:(MinusExpression*)newExpression;
- (void) addOperand:(MultOperator)operator operand:(MinusExpression*)operand;
- (BOOL) isLongRunning;
- (void) getFieldDependencies:(NSMutableSet*)fields;
@end

@class TermExpression;
@interface MinusExpression : NSObject
@property(nonatomic,strong,readonly) TermExpression* expression;
@property(nonatomic,assign,readonly) int minusCount;
- (id) initWithTermExpression:(TermExpression*)newExpression minusCount:(int)newMinusCount;
- (BOOL) isLongRunning;
- (void) getFieldDependencies:(NSMutableSet*)fields;
@end

@class ORExpression;
@class FieldNameExpression;
@class RecordFieldNameExpression;
@class LocalResExpression;
@class FunctionExpression;
@class ConstantExpression;
@interface TermExpression : NSObject
@property(nonatomic,assign,readonly) TermType type;
@property(nonatomic,strong,readonly) ORExpression* complexExpression;
@property(nonatomic,strong,readonly) FieldNameExpression* fieldNameExpression;
@property(nonatomic,strong,readonly) RecordFieldNameExpression* recordFieldNameExpression;
@property(nonatomic,strong,readonly) LocalResExpression* localResExpression;
@property(nonatomic,strong,readonly) FunctionExpression* functionExpression;
@property(nonatomic,strong,readonly) ConstantExpression* constantExpression;
- (id) initWithORExpression:(ORExpression*)newComplexExpression;
- (id) initWithFieldNameExpression:(FieldNameExpression*)newFieldNameExpression;
- (id) initWithRecordFieldNameExpression:(RecordFieldNameExpression*)newRecordFieldNameExpression;
- (id) initWithLocalResExpression:(LocalResExpression*)newLocalResExpression;
- (id) initWithFunctionExpression:(FunctionExpression*)newFunctionExpression;
- (id) initWithConstantExpression:(ConstantExpression*)newConstantExpression;
- (BOOL) isLongRunning;
- (void) getFieldDependencies:(NSMutableSet*)fields;
@end

@interface FieldNameExpression : NSObject
@property(nonatomic,strong,readonly) NSString* fieldName;
- (id) initWithFieldName:(NSString*)newFieldName;
@end

@interface RecordFieldNameExpression : NSObject
@property(nonatomic,strong,readonly) NSString* fieldName;
@property(nonatomic,strong,readonly) NSString* recordName;
- (id)initWithRecordName:(NSString*)newRecordName fieldName:(NSString*)newFieldName;
@end

@interface FunctionExpression : NSObject
@property(nonatomic,strong,readonly) NSString* functionName;
@property(nonatomic,strong,readonly) NSMutableArray* operands;
- (id) initWithFunctionName:(NSString*)newFunctionName;
- (void) addOperand:(ORExpression*)expression;
@end

@interface LocalResExpression : NSObject
@property(nonatomic,strong,readonly) NSString* resId;
- (id) initWithResId:(NSString*)newResId;
@end

@interface ConstantExpression : NSObject
@property(nonatomic,assign,readonly) ConstantType type;
@property(nonatomic,strong,readonly) NSString* stringValue;
@property(nonatomic,assign,readonly) int intValue;
@property(nonatomic,assign,readonly) float floatValue;
- (id) initWithString:(NSString*)string;
- (id) initWithInt:(int)ivalue;
- (id) initWithDouble:(double)dvalue;
- (id) initWithType:(ConstantType)newType;
@end
