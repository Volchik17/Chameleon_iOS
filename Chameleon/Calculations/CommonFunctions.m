//
//  CommonFunctions.m
//  mBSClient
//
//  Created by Maksim Voronin on 15.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "CommonFunctions.h"
#import "Value.h"
#import "ExpressionEvaluator.h"

@implementation CommonFunctions

@synthesize longRunning = _longRunning;

- (id)init
{
    self = [super init];
    if (self)
    {
        _longRunning = NO;
    }
    return self;
}

-(Value*) f_if:(ExpressionEvaluator*)evaluator args:(NSArray*)args
{
    Value* condition = [args objectAtIndex:0];
    Value* arg1 = [args objectAtIndex:1];
    Value* arg2 = [args objectAtIndex:2];
    
    if ([condition convertToBool])
        return arg1;
    else
        return arg2;
}

-(Value*) f_currentDate:(ExpressionEvaluator*)evaluator
{
    return [[Value alloc] initWithDate:[NSDate date]]; //отрезать часы минуты секунды
}

-(Value*) f_currentDateTime:(ExpressionEvaluator*)evaluator
{
    return [[Value alloc] initWithDateTime:[NSDate date]];
}

-(Value*) f_length:(ExpressionEvaluator*)evaluator args:(NSArray*)args
{
    Value* value = [args objectAtIndex:0];
    return [[Value alloc] initWithInt:value.convertToString.length];
}

-(Value*) f_in:(ExpressionEvaluator*)evaluator args:(NSArray*)args
{
    Value* checkField = [args objectAtIndex:0];
    for (int i=0; i < [args count]-1; i++)
    {
        Value* value = [args objectAtIndex:i+1];
        if ([[Value valueEqual:checkField value:value] convertToBool])
        {
            return [[Value alloc] initWithBOOL:TRUE];
        }
    }
    return [[Value alloc] initWithBOOL:FALSE];
}

-(Value*) f_switch:(ExpressionEvaluator*)evaluator args:(NSArray*)args
{
    Value* switcher = [args objectAtIndex:0];
    int index = [switcher convertToInt] + 1;
    if (index < 0 || index >= [args count])
    {
        return [Value unknown];
    }
    else
    {
        return [args objectAtIndex:index];
    }
}

@end
