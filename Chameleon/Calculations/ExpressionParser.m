//
//  ExpressionParser.m
//  mBSClient
//
//  Created by Maksim Voronin on 14.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "ExpressionParser.h"
#import "Tokenizer.h"
#import "Expression.h"
#import "Token.h"
#import "ExpressionParserError.h"

@interface ExpressionParser()
@property(nonatomic,strong) Tokenizer* tokenizer;
@end

@implementation ExpressionParser

@synthesize tokenizer;

-(Expression*) parse:(NSString*)source
{
    tokenizer = [[Tokenizer alloc] initWithString:source];
    return [self parseExpression];
}

-(BOOL) checkNextToken:(TokenType)tokenType
{
    [tokenizer mark];
    @try
    {
        Token* token = [[Token alloc] init];
        return [tokenizer getNextToken:token] && token.type==tokenType;
    }
    @finally
    {
        [tokenizer back];
    }
}

-(Expression*) parseExpression
{
    return [[Expression alloc] initWithORExpression:[self parseORExpression]];
}

-(ORExpression*) parseORExpression
{
    //    <ORExpression> ::= <ANDExpression> { "||" <ANDExpression> }
    ORExpression* expression = [[ORExpression alloc] initWithANDExpression:[self parseANDExpression]];
    while ([self checkNextToken:ttOR])
    {
        [tokenizer getNextToken:[[Token alloc] init]];
        [expression addOperand:[self parseANDExpression]];
    }
    return expression;
}

-(ANDExpression*) parseANDExpression
{
    //    <ANDExpression> ::= <NotExpression> { "&&" <NotExpression> }
    ANDExpression* expression = [[ANDExpression alloc] initWithNotExpression:[self parseNOTExpression]];
    while ([self checkNextToken:ttAND])
    {
        [tokenizer getNextToken:[[Token alloc] init]];
        [expression addOperand:[self parseNOTExpression]];
    }
    return expression;
}

-(NotExpression*) parseNOTExpression
{
    //    <NotExpression> ::= { "!" } <CompareExpression>
    int notCount=0;
    while ([self checkNextToken:ttNot])
    {
        [tokenizer getNextToken:[[Token alloc] init]];
        notCount++;
    }
    return [[NotExpression alloc] initWithCompareExpression:[self parseCompareExpression] notCount:notCount];
}

-(BOOL) isNextRelationToken
{
    [tokenizer mark];
    @try
    {
        Token* token = [[Token alloc] init];//new Token();
        return [tokenizer getNextToken:token] &&
            (token.type==ttEqual ||
             token.type==ttNotEqual ||
             token.type==ttGreater ||
             token.type==ttGreaterEqual ||
             token.type==ttLesser ||
             token.type==ttLesserEqual);
    }
    @finally
    {
        [tokenizer back];
    }
}

-(CompareExpression*) parseCompareExpression
{
    //      <CompareExpression> ::=  <AddExpression> { <RelationOperator> <AddExpression> }
    CompareExpression* expression= [[CompareExpression alloc] initWithAddExpression:[self parseAddExpression]];
    while ([self isNextRelationToken])
    {
        Token* token = [[Token alloc] init];
        [tokenizer getNextToken:token];
        RelationOperator operator;
        switch (token.type) {
            case ttEqual:
            {
                operator=roEqual;
                break;
            }
            case ttNotEqual:
            {
                operator=roNotEqual;
                break;
            }
            case ttGreater:
            {
                operator=roGreater;
                break;
            }
            case ttLesser:
            {
                operator=roLesser;
                break;
            }
            case ttGreaterEqual:
            {
                operator=roGreatEqual;
                break;
            }
            case ttLesserEqual:
            {
                operator=roLessEqual;
                break;
            }
            default:
            {
                operator=roEqual;
                NSAssert(false,@"Unknown operator");
                break;
            }
        }
        [expression addOperand:operator operand:[self parseAddExpression]];
    }
    return expression;
}

-(BOOL) isNextAddToken
{
    [tokenizer mark];
    @try
    {
        Token* token = [[Token alloc] init];
        return [tokenizer getNextToken:token] &&
            (token.type==ttPlus ||
             token.type==ttMinus);
    }
    @finally
    {
        [tokenizer back];
    }
}

-(AddExpression*) parseAddExpression
{
    //    <AddExpression> ::= <MultExpression> { <AddOperator> <MultExpression> }
    AddExpression* expression = [[AddExpression alloc] initWithMultExpression:[self parseMultExpression]];
    while ([self isNextAddToken])
    {
        Token* token = [[Token alloc] init];
        [tokenizer getNextToken:token];
        AddOperator operator;
        switch (token.type)
        {
            case ttPlus:
            {
                operator=aoAdd;
                break;
            }
            case ttMinus:
            {
                operator=aoSubtract;
                break;
            }
            default:
            {
                operator=aoAdd;
                NSAssert(false,@"Unknown operator");
                break;
            }
        }
        [expression addOperand:operator operand:[self parseMultExpression]];
    }
    return expression;
}

-(BOOL) isNextMultToken
{
    [tokenizer mark];
    @try
    {
        Token* token = [[Token alloc] init];
        return [tokenizer getNextToken:token] &&
        (token.type==ttMult ||
         token.type==ttDivide);
    }
    @finally
    {
        [tokenizer back];
    }
}

-(MultExpression*) parseMultExpression
{
    //    <MultExpression> ::= <MinusExpression> { <MultOperator> <MinusExpression> }
    MultExpression* expression = [[MultExpression alloc] initWithMinusExpression:[self parseMinusExpression]];
    while ([self isNextMultToken])
    {
        Token* token = [[Token alloc] init];
        [tokenizer getNextToken:token];
        MultOperator operator;
        switch (token.type)
        {
            case ttMult:
            {
                operator=moMultiply;
                break;
            }
            case ttDivide:
            {
                operator=moDivision;
                break;
            }
            default:
            {
                operator=moMultiply;
                NSAssert(false,@"Unknown operator");
                break;
            }
        }
        [expression addOperand:operator operand:[self parseMinusExpression]];
    }
    return expression;
}

-(MinusExpression*) parseMinusExpression
{
    //    <MinusExpression> ::= { "-" } <TermExpression>
    int minusCount=0;
    while ([self checkNextToken:ttMinus])
    {
        [tokenizer getNextToken:[[Token alloc] init]];//(new Token());
        minusCount++;
    }
    return [[MinusExpression alloc] initWithTermExpression:[self parseTermExpression] minusCount:minusCount];
}

-(TermExpression*) parseTermExpression
{
    //    <TermExpression> ::= "(" <ORExpression> ")" | <FieldName> | <RecordFieldName> | <Function> | <LOCALRES> | <STRING> | <NUMBER> | "null" | "unchanged" | "true" | "false"
    Token* token = [[Token alloc] init];
    
    if (![tokenizer getNextToken:token])
        @throw [ExpressionParserError expressionParserError:tokenizer.source
                                                   position:tokenizer.position
                                               errorMessage:@"Expression expected."];
    switch (token.type)
    {
        case ttLeftBracket:
        {
            TermExpression* expr = [[TermExpression alloc] initWithORExpression:[self parseORExpression]];
            if (![tokenizer getNextToken:token] || token.type != ttRightBracket)
                @throw [ExpressionParserError expressionParserError:tokenizer.source
                                                           position:tokenizer.position
                                                       errorMessage:@"\")\" expected."];
            return expr;
        }
        case ttLocalRes:
        {
            return [[TermExpression alloc] initWithLocalResExpression:[[LocalResExpression alloc] initWithResId:token.stringValue]];
        }
        case ttFALSE:
        {
            return [[TermExpression alloc] initWithConstantExpression:[[ConstantExpression alloc] initWithType:ccFalse]];
        }
        case ttTRUE:
        {
            return [[TermExpression alloc] initWithConstantExpression:[[ConstantExpression alloc] initWithType:ccTrue]];
        }
        case ttString:
        {
            return [[TermExpression alloc] initWithConstantExpression:[[ConstantExpression alloc] initWithString:token.stringValue]];
        }
        case ttInteger:
        {
            return [[TermExpression alloc] initWithConstantExpression:[[ConstantExpression alloc] initWithInt:token.intValue]];
        }
        case ttFloat:
        {
            return [[TermExpression alloc] initWithConstantExpression:[[ConstantExpression alloc] initWithDouble:token.floatValue]];
        }
        case ttNULL:
        {
            return [[TermExpression alloc] initWithConstantExpression:[[ConstantExpression alloc] initWithType:ccNULL]];
        }
        case ttUNCHANGED:
        {
            return [[TermExpression alloc] initWithConstantExpression:[[ConstantExpression alloc] initWithType:ccUnchanged]];
        }
        case ttID:
        {
            NSString* name = token.stringValue;
            if ([self checkNextToken:ttDot])
            {
                [tokenizer getNextToken:token];
                if (![tokenizer getNextToken:token] || token.type != ttID)
                {
                    @throw [ExpressionParserError expressionParserError:tokenizer.source
                                                               position:tokenizer.position
                                                           errorMessage:@"Identifier expected."];
                }
                return [[TermExpression alloc] initWithRecordFieldNameExpression:[[RecordFieldNameExpression alloc] initWithRecordName:name fieldName:token.stringValue]];
            }
            else if([self checkNextToken:ttLeftBracket])
            {
                return [[TermExpression alloc] initWithFunctionExpression:[self parseFunctionExpression:name]];
            }
            else
                return [[TermExpression alloc] initWithFieldNameExpression:[[FieldNameExpression alloc] initWithFieldName:name]];
        }
        default:
        {
            @throw [ExpressionParserError expressionParserError:tokenizer.source
                                                       position:tokenizer.position
                                                   errorMessage:@"Expression expected."];
        }
    }
}

-(FunctionExpression*) parseFunctionExpression:(NSString*)name
{
    Token* token = [[Token alloc] init];
    if (![tokenizer getNextToken:token] || token.type!=ttLeftBracket)
    {
        @throw [ExpressionParserError expressionParserError:tokenizer.source
                                                   position:tokenizer.position
                                               errorMessage:@"\"(\" expected."];
    }
    
    FunctionExpression* expr = [[FunctionExpression alloc] initWithFunctionName:name];
    if ([self checkNextToken:ttRightBracket])
    {
        [tokenizer getNextToken:token];
        return expr;
    }
    do
    {
        [expr addOperand:[self parseORExpression]];
        if ([self checkNextToken:ttRightBracket])
        {
            [tokenizer getNextToken:token];
            return expr;
        }
        else if (![tokenizer getNextToken:token] || token.type != ttComma)
        {
            @throw [ExpressionParserError expressionParserError:tokenizer.source
                                                       position:tokenizer.position
                                                   errorMessage:@"\")\" or \",\" expected."];
        }
    } while (true);
}

@end
