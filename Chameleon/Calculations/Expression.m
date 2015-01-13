//
//  Expression.m
//  mBSClient
//
//  Created by Maksim Voronin on 10.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "Expression.h"
#import "FunctionPool.h"

// <Expression> ::= <ORExpression> |
@implementation Expression

@synthesize longRunning,longRunningCalculated,expression;

- (id) initWithORExpression:(ORExpression*)newExpression
{
    self = [self init];
    if (self)
    {
        expression = newExpression;
        longRunningCalculated = NO;
    }
    return self;
}

- (BOOL) isLongRunning
{
    if (longRunningCalculated)
    {
        return longRunning;
    }
    
    longRunning = [expression isLongRunning];
    longRunningCalculated = YES;
    return longRunning;
}

- (NSArray*) getFieldDependencies
{
    NSMutableSet* fields = [NSMutableSet new];
    [expression getFieldDependencies:fields];
    return [NSArray arrayWithArray:[fields allObjects]];
}

@end

// <ORExpression> ::= <ANDExpression> {"|" <ANDExpression>}
@implementation ORExpression

@synthesize expression,operands;

- (id) initWithANDExpression:(ANDExpression*)newExpression
{
    self = [super init];
    if (self)
    {
        operands   = [NSMutableArray new];
        expression = newExpression;
    }
    return self;
}

- (void) addOperand:(ANDExpression*)operand
{
    [operands addObject:operand];
}

- (BOOL) isLongRunning
{
    if ([expression isLongRunning])
    {
        return YES;
    }
    
    for (ANDExpression* expr in operands)
    {
        if ([expr isLongRunning])
        {
            return YES;
        }
    }
    
    return NO;
}

- (void) getFieldDependencies:(NSMutableSet*)fields
{
    [expression getFieldDependencies:fields];
    for (ANDExpression* expr in operands)
    {
        [expr getFieldDependencies:fields];
    }
}

@end

// <ANDExpression> ::= <NotExpression> {"&&" <NotExpression>}
@implementation ANDExpression

@synthesize expression,operands;

- (id) initWithNotExpression:(NotExpression*)newExpression
{
    self = [super init];
    if (self)
    {
        operands   = [NSMutableArray new];
        expression = newExpression;
    }
    return self;
}

- (void) addOperand:(NotExpression*)operand
{
    [operands addObject:operand];
}

- (BOOL) isLongRunning
{
    if ([expression isLongRunning])
    {
        return YES;
    }
    
    for (NotExpression* expr in operands)
    {
        if ([expr isLongRunning])
        {
            return YES;
        }
    }
    return NO;
}

- (void) getFieldDependencies:(NSMutableSet*)fields
{
    [expression getFieldDependencies:fields];
    for (NotExpression* expr in operands)
    {
        [expr getFieldDependencies:fields];
    }
}

@end

// <NotExpression> ::= { "!" } <CompareExpression>
@implementation NotExpression

@synthesize expression,notCount;

- (id) initWithCompareExpression:(CompareExpression*)newExpression notCount:(int)newNotCount
{
    self = [super init];
    if (self)
    {
        expression = newExpression;
        notCount   = newNotCount;
    }
    return self;
}

- (BOOL) isLongRunning
{
    return [expression isLongRunning];
}

- (void) getFieldDependencies:(NSMutableSet*)fields
{
    [expression getFieldDependencies:fields];
}

@end

// <CompareExpression> ::=  <AddExpression> { <RelationOperator> <AddExpression> }
// <RelationOperator> ::= ">" | "<" | "==" | "!=" | ">=" | "<="
@implementation CompareExpression

@synthesize operands,operators,expression;

- (id) initWithAddExpression:(AddExpression*)newExpression
{
    self = [super init];
    if (self)
    {
        operands   = [NSMutableArray new];
        operators  = [NSMutableArray new];
        expression = newExpression;
    }
    return self;
}

-(void) addOperand:(RelationOperator)operator operand:(AddExpression*)operand
{
    [operands addObject:operand];
    [operators addObject:[NSNumber numberWithInt:operator]];
}

- (BOOL) isLongRunning
{
    if ([expression isLongRunning])
    {
        return YES;
    }
    
    for (AddExpression* expr in operands)
    {
        if ([expr isLongRunning])
        {
            return YES;
        }
    }
    return NO;
}

- (void) getFieldDependencies:(NSMutableSet*)fields
{
    [expression getFieldDependencies:fields];
    for (AddExpression* expr in operands)
    {
        [expr getFieldDependencies:fields];
    }
}

@end

//    <AddExpression> ::= <MultExpression> { <AddOperator> <MultExpression> }
//    <AddOperator> ::= "+" | "-"
@implementation AddExpression

@synthesize operands,operators,expression;

- (id) initWithMultExpression:(MultExpression*)newExpression
{
    self = [super init];
    if (self)
    {
        operands   = [NSMutableArray new];
        operators  = [NSMutableArray new];
        expression = newExpression;
    }
    return self;
}

-(void) addOperand:(AddOperator)operator operand:(MultExpression*)operand
{
    [operands addObject:operand];
    [operators addObject:[NSNumber numberWithInt:operator]];
}

- (BOOL) isLongRunning
{
    if ([expression isLongRunning])
    {
        return YES;
    }
    
    for (MultExpression* expr in operands)
    {
        if ([expr isLongRunning])
        {
            return YES;
        }
    }
    return NO;
}

- (void) getFieldDependencies:(NSMutableSet*)fields
{
    [expression getFieldDependencies:fields];
    for (MultExpression* expr in operands)
    {
        [expr getFieldDependencies:fields];
    }
}

@end

//    <MultExpression> ::= <MinusExpression> { <MultOperator> <MinusExpression> }
//    <MultOperator> ::= "*" | "/"
@implementation MultExpression

@synthesize operands,operators,expression;

- (id) initWithMinusExpression:(MinusExpression*)newExpression
{
    self = [super init];
    if (self)
    {
        operands   = [NSMutableArray new];
        operators  = [NSMutableArray new];
        expression = newExpression;
    }
    return self;
}

-(void) addOperand:(MultOperator)operator operand:(MinusExpression*)operand
{
    [operands addObject:operand];
    [operators addObject:[NSNumber numberWithInt:operator]];
}

- (BOOL) isLongRunning
{
    if ([expression isLongRunning])
    {
        return YES;
    }
    
    for (MinusExpression* expr in operands)
    {
        if ([expr isLongRunning])
        {
            return YES;
        }
    }
    return NO;
}

- (void) getFieldDependencies:(NSMutableSet*)fields
{
    [expression getFieldDependencies:fields];
    for (MinusExpression* expr in operands)
    {
        [expr getFieldDependencies:fields];
    }
}

@end

//  <MinusExpression> ::= { "-" } <Term>
@implementation MinusExpression

@synthesize expression,minusCount;

- (id) initWithTermExpression:(TermExpression*)newExpression minusCount:(int)newMinusCount
{
    self = [super init];
    if (self)
    {
        expression = newExpression;
        minusCount   = newMinusCount;
    }
    return self;
}

- (BOOL) isLongRunning
{
    return [expression isLongRunning];
}

- (void) getFieldDependencies:(NSMutableSet*)fields
{
    [expression getFieldDependencies:fields];
}

@end

//  <TermExpression> ::= "(" <ORExpression> ")" | <FieldName> | <RecordFieldName> | <Function> | <LOCALRES> | <STRING> | <NUMBER> | "null" | "unchanged" | "true" | "false"
@implementation TermExpression

@synthesize type,complexExpression,fieldNameExpression,recordFieldNameExpression,localResExpression,functionExpression,constantExpression;

- (id) initWithORExpression:(ORExpression*)newComplexExpression
{
    self = [super init];
    if (self)
    {
        type = tetComplex;
        complexExpression = newComplexExpression;
    }
    return self;
}

- (id) initWithFieldNameExpression:(FieldNameExpression*)newFieldNameExpression
{
    self = [super init];
    if (self)
    {
        type = tetFieldName;
        fieldNameExpression = newFieldNameExpression;
    }
    return self;
}

- (id) initWithRecordFieldNameExpression:(RecordFieldNameExpression*)newRecordFieldNameExpression
{
    self = [super init];
    if (self)
    {
        type= tetRecordFieldName;
        recordFieldNameExpression = newRecordFieldNameExpression;
    }
    return self;
}

- (id) initWithFunctionExpression:(FunctionExpression*)newFunctionExpression
{
    self = [super init];
    if (self)
    {
        type = tetFunction;
        functionExpression = newFunctionExpression;
    }
    return self;
}

- (id) initWithLocalResExpression:(LocalResExpression*)newLocalResExpression
{
    self = [super init];
    if (self)
    {
        type = tetLocalRes;
        localResExpression = newLocalResExpression;
    }
    return self;
}

- (id) initWithConstantExpression:(ConstantExpression*)newConstantExpression
{
    self = [super init];
    if (self)
    {
        type = tetConstant;
        constantExpression = newConstantExpression;
    }
    return self;
}

- (BOOL) isLongRunning
{
    switch (type)
    {
        case tetComplex:
        {
            return [complexExpression isLongRunning];
            break;
        }
        case tetFunction:
        {
            return [[FunctionPool sharedInstance] isFunctionLongRunning:functionExpression.functionName];
            break;
        }            
        default:
        {
            return NO;
            break;
        }
    }
}

- (void) getFieldDependencies:(NSMutableSet*)fields
{
    switch (type)
    {
        case tetComplex:
        {
            [complexExpression getFieldDependencies:fields];
            break;
        }
        case tetFunction:
        {
            for (ORExpression* expr in functionExpression.operands)
            {
                [expr getFieldDependencies:fields];
            }
            break;
        }
        case tetFieldName:
        {
            [fields addObject:fieldNameExpression.fieldName];
            break;
        }
        case tetRecordFieldName:
        {
            [fields addObject:[NSString stringWithFormat:@"%@.%@",recordFieldNameExpression.recordName,recordFieldNameExpression.fieldName]];
            break;
        }
        default:
        {
            break;
        }
    }
}

@end

//    <FieldName> ::= <IDENTIFIER>
@implementation FieldNameExpression

@synthesize fieldName;

- (id)initWithFieldName:(NSString*)newFieldName
{
    self = [super init];
    if (self)
    {
        fieldName  = newFieldName;
    }
    return self;
}

@end

//    <RecordFieldName> ::= <IDENTIFIER> "." <IDENTIFIER>
@implementation RecordFieldNameExpression

@synthesize fieldName,recordName;

- (id)initWithRecordName:(NSString*)newRecordName fieldName:(NSString*)newFieldName
{
    self = [super init];
    if (self)
    {
        fieldName  = newFieldName;
        recordName = newRecordName;
    }
    return self;
}

@end

//    <Function> ::= <IDENTIFIER> "(" <Expression> { "," <Expression> }  ")"
@implementation FunctionExpression

@synthesize functionName,operands;

- (id)initWithFunctionName:(NSString*)newFunctionName
{
    self = [super init];
    if (self)
    {
        functionName = newFunctionName;
        operands = [NSMutableArray new];
        
    }
    return self;
}

-(void) addOperand:(ORExpression*)expression
{
    [operands addObject:expression];
}

@end

// <LOCALRES>
@implementation LocalResExpression

@synthesize resId;

- (id)initWithResId:(NSString*)newResId
{
    self = [super init];
    if (self)
    {
        resId = newResId;
    }
    return self;
}
@end

//  <STRING> | <NUMBER> | "null" | "unchanged" | "true" | "false"
@implementation ConstantExpression

@synthesize type,stringValue,intValue,floatValue;

- (id)initWithString:(NSString*)string
{
    self = [super init];
    if (self)
    {
        type = ccString;
        stringValue = string;
    }
    return self;
}

- (id)initWithInt:(int)ivalue
{
    self = [super init];
    if (self)
    {
        type = ccInteger;
        intValue = ivalue;
    }
    return self;
}

- (id)initWithDouble:(double)dvalue
{
    self = [super init];
    if (self)
    {
        type = ccFloat;
        intValue = dvalue;
    }
    return self;
}

- (id)initWithType:(ConstantType)newType
{
    self = [super init];
    if (self)
    {
        type = newType;
    }
    return self;
}

@end









