//
//  ExpressionParser.h
//  mBSClient
//
//  Created by Maksim Voronin on 14.10.14.
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
 <CompareExpression> ::=  <MultExpression> { <RelationOperator> <MultExpression> }
 <RelationOperator> ::= ">" | "<" | "==" | "!=" | ">=" | "<="
 <MultExpression> ::= <AddExpression> { <MultOperator> <AddExpression> }
 <MultOperator> ::= "*" | "/"
 <AddExpression> ::= <MinusExpression> { <AddOperator> <MinusExpression> }
 <AddOperator> ::= "+" | "-"
 <MinusExpression> ::= { "-" } <TermExpression>
 <TermExpression> ::= "(" <ORExpression> ")" | <FieldName> | <RecordFieldName> | <Function> | <LOCALRES> | <STRING> | <NUMBER> | "null" | "unchanged" | "true" | "false"
 <FieldName> ::= <IDENTIFIER>
 <RecordFieldName> ::= <IDENTIFIER> "." <IDENTIFIER>
 <Function> ::= <IDENTIFIER> "(" <Expression> { "," <Expression> }  ")"
 */

@class Expression;
@interface ExpressionParser : NSObject
-(Expression*) parse:(NSString*)source;
@end


