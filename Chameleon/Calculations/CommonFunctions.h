//
//  CommonFunctions.h
//  mBSClient
//
//  Created by Maksim Voronin on 15.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Value;
@class ExpressionEvaluator;
@interface CommonFunctions : NSObject
@property(nonatomic,assign,readonly) BOOL longRunning; // NO

// !!! Все названия методов должны начинаться с приставки f_,
// т.к. имена иногда совпадают с зарезервированными словами if, swith и т.д.

-(Value*) f_if:(ExpressionEvaluator*)evaluator args:(NSArray*)args;
-(Value*) f_currentDate:(ExpressionEvaluator*)evaluator;
-(Value*) f_currentDateTime:(ExpressionEvaluator*)evaluator;
-(Value*) f_length:(ExpressionEvaluator*)evaluator args:(NSArray*)args;

@end