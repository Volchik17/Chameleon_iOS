//
//  ExpressionParserError.m
//  mBSClient
//
//  Created by Maksim Voronin on 13.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "ExpressionParserError.h"

@implementation ExpressionParserError
+(NSException*) expressionParserError:(NSString*)source position:(int)position errorMessage:(NSString*)errorMessage
{
    return [NSException exceptionWithName:[NSString stringWithFormat:@"Error in expression. %@ Position: %i Expression: %@",errorMessage, position,source]
                            reason:nil userInfo:nil];
}
@end
