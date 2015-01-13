//
//  ExpressionParserError.h
//  mBSClient
//
//  Created by Maksim Voronin on 13.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExpressionParserError : NSException
+(NSException*)expressionParserError:(NSString*)source position:(int)position errorMessage:(NSString*)errorMessage;
@end
