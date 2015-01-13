//
//  ExpressionEvaluator.m
//  mBSClient
//
//  Created by Maksim Voronin on 14.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "ExpressionEvaluator.h"
#import "IRecord.h"
#import "Expression.h"
#import "Value.h"
#import "FunctionPool.h"
#import "CustomRecord.h"

@interface ExpressionEvaluator()
@end

@implementation ExpressionEvaluator

@synthesize record, infoRecords, callback, bankId;

- (id)init
{
    self = [super init];
    if (self)
    {
        infoRecords = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (id)initWithBankId:(NSString*)newBankId
{
    self = [self init];
    if (self)
    {
        bankId = newBankId;
    }
    return self;
}

-(NSString*) getBankId
{
    return bankId;
}

-(id<IExpressionEvaluatorCallback>) getCallback
{
    return callback;
}

-(void) setCallback:(id <IExpressionEvaluatorCallback>) newCallback
{
    callback = newCallback;
}

-(void) setRecord:(id <IRecord>) newRecord
{
    record = newRecord;
}

-(id <IRecord>)getRecord
{
    return record;
}

-(void) setInfoRecords:(NSMutableDictionary*) newInfoRecords
{
    infoRecords = newInfoRecords;
}

-(NSMutableDictionary*) getInfoRecords
{
    return infoRecords;
}

-(id) copyWithZone:(NSZone *)zone
{
    ExpressionEvaluator* evaluatorCopy=[[ExpressionEvaluator allocWithZone:zone] initWithBankId:bankId];
    evaluatorCopy.record=[[CustomRecord allocWithZone:zone] initWithRecord:record];
    if (infoRecords!=nil) {
        NSMutableDictionary* newInfoRecords = [[NSMutableDictionary allocWithZone:zone] initWithCapacity:infoRecords.count];
        for (NSString* name in infoRecords.allKeys)
        {
            CustomRecord* newRecord=[[CustomRecord allocWithZone:zone] initWithRecord:[infoRecords objectForKey:name]];
            [newInfoRecords setObject:newRecord forKey:name];
        }
        
        evaluatorCopy.infoRecords=newInfoRecords;
    }
    evaluatorCopy.callback=callback;
    return evaluatorCopy;
}

-(Value*) evaluateExpression:(Expression*) expression
{
    return [self evaluateORExpression:expression.expression];
}

-(Value*) evaluateORExpression:(ORExpression*) expr
{
    Value* value = [self evaluateANDExpression:expr.expression];
    for (ANDExpression *rightExpr in expr.operands)
    {
        Value* rightValue = [self evaluateANDExpression:rightExpr];
        value = [Value valueOr:value value:rightValue];
    }
    return value;
}

-(Value*) evaluateANDExpression:(ANDExpression*) expr
{
    Value* value = [self evaluateNOTExpression:expr.expression];
    for (NotExpression *rightExpr in expr.operands)
    {
        Value* rightValue = [self evaluateNOTExpression:rightExpr];
        value = [Value valueAnd:value value:rightValue];
    }
    return value;
}

-(Value*) evaluateNOTExpression:(NotExpression*) expr
{
    Value* value = [self evaluateCompareExpression:expr.expression];
    if (expr.notCount%2 !=0)
        return [Value valueNot:value];
    else
        return value;
}

-(Value*) evaluateCompareExpression:(CompareExpression*) expr
{
    Value* value = [self evaluateAddExpression:expr.expression];
    for(int i=0; i < [expr.operators count]; i++ )
    {
        Value* rightValue = [self evaluateAddExpression:[expr.operands objectAtIndex:i]];
        switch ([[expr.operators objectAtIndex:i] intValue])
        {
            case roEqual:
            {
                value = [Value valueEqual:value value:rightValue];
                break;
            }
            case roNotEqual:
            {
                value = [Value valueNotEqual:value value:rightValue];
                break;
            }
            case roGreater:
            {
                value = [Value valueGreater:value value:rightValue];
                break;
            }
            case roGreatEqual:
            {
                value = [Value valueGreaterEqual:value value:rightValue];
                break;
            }
            case roLesser:
            {
                value = [Value valueLesser:value value:rightValue];
                break;
            }
            case roLessEqual:
            {
                value = [Value valueLesserEqual:value value:rightValue];
                break;
            }
        }
    }
    return value;
}

-(Value*) evaluateAddExpression:(AddExpression*)expr
{
    Value* value = [self evaluateMultExpression:expr.expression];
    for (int i=0; i < [expr.operators count]; i++)
    {
        Value* rightValue = [self evaluateMultExpression:[expr.operands objectAtIndex:i]];
        switch ([[expr.operators objectAtIndex:i] intValue])
        {
            case aoAdd:
            {
                value = [Value valueAdd:value value:rightValue];
                break;
            }
            case aoSubtract:
            {
                value = [Value valueSubtract:value value:rightValue];
                break;
            }
        }
    }
    return value;
}

-(Value*) evaluateMultExpression:(MultExpression*) expr
{
    Value* value = [self evaluateMinusExpression:expr.expression];
    for (int i=0; i<[expr.operators count]; i++)
    {
        Value* rightValue = [self evaluateMinusExpression:[expr.operands objectAtIndex:i]];
        switch([[expr.operators objectAtIndex:i] intValue])
        {
            case moMultiply:
                value = [Value valueMultiply:value value:rightValue];
                break;
            case moDivision:
                value = [Value valueDivide:value value:rightValue];
                break;
        }
    }
    return value;
}

-(Value*) evaluateMinusExpression:(MinusExpression*) expr
{
    Value* value = [self evaluateTermExpression:expr.expression];
    if (expr.minusCount>0 && expr.minusCount % 2!=0)
    {
        value = [Value valueMinus:value];
    }
    return value;
}

-(Value*) evaluateTermExpression:(TermExpression*) expr
{
    switch (expr.type)
    {
        case tetComplex:
            return [self evaluateORExpression:expr.complexExpression];
        case tetConstant:
            return [self evaluateConstantExpression:expr.constantExpression];
        case tetFieldName:
            return [self evaluateFieldNameExpression:expr.fieldNameExpression];
        case tetRecordFieldName:
            return [self evaluateRecordFieldNameExpression:expr.recordFieldNameExpression];
        case tetLocalRes:
            return [self evaluateLocalResExpression:expr.localResExpression];
        case tetFunction:
            return [self evaluateFunctionExpression:expr.functionExpression];
        default:
            return [Value unknown];
    }
}

-(Value*) evaluateConstantExpression:(ConstantExpression*) expr
{
    switch (expr.type)
    {
        case ccFalse:
        {
            return [[Value alloc] initWithBOOL:FALSE];
        }
        case ccTrue:
        {
            return [[Value alloc] initWithBOOL:TRUE];
        }
        case ccNULL:
        {
            return [[Value alloc] initWithDataType:STRING value:nil];
        }
        case ccUnchanged:
            return [Value unknown];
        case ccString:
        {
            return [[Value alloc] initWithString:expr.stringValue];
        }
        case ccFloat:
        {
            return [[Value alloc] initWithDouble:expr.floatValue];
        }
        case ccInteger:
        {
            return [[Value alloc] initWithInt:expr.intValue];
        }
        default:
            return [Value unknown];
    }
}

-(Value*) evaluateFieldNameExpression:(FieldNameExpression*) expr
{
    if (record != nil)
    {
        Field* field = [record getFieldWithName:expr.fieldName];
        if (field != nil)
            return [field getValue];
    }
    if (callback != nil)
        return [callback getFieldValue:expr.fieldName];
    return [Value unknown];
}

-(Value*) evaluateRecordFieldNameExpression:(RecordFieldNameExpression*) expr
{
    if (infoRecords != nil)
    {
        id<IRecord> infoRecord = [infoRecords objectForKey:expr.recordName];
        if (record != nil)
        {
            Field* field = [infoRecord getFieldWithName:expr.fieldName];
            if (field != nil)
                return [field getValue];
        }
    }
    if (callback != nil)
        return [callback getFieldValue:expr.fieldName recordName:expr.recordName];
    return [Value unknown];
}

-(Value*) evaluateLocalResExpression:(LocalResExpression*) expr
{
    if (callback != nil)
    {
        return [[Value alloc] initWithString:[callback getLocalResValue:expr.resId]];
    }
    return [Value unknown];
}

-(Value*) evaluateFunctionExpression:(FunctionExpression*) expr
{
    
    NSMutableArray* arguments = [NSMutableArray arrayWithCapacity:[expr.operands count]];
    for (int i=0; i < [expr.operands count]; i++)
    {
        [arguments addObject:[self evaluateORExpression:[expr.operands objectAtIndex:i]]];
    }
    FunctionPool* pool = [FunctionPool sharedInstance];
    if ([pool functionExists:expr.functionName])
    {
        return[pool calculateFunctionResult:self functionName:expr.functionName args:arguments];
    }
    if (callback != nil)
    {
        return [callback getFunctionValue:expr.functionName arguments:arguments];
    }
    return [Value unknown];
}

@end
