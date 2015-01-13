//
//  LongRunningFunction.h
//  mBSClient
//
//  Created by Maksim Voronin on 16.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Value;
@class ExpressionEvaluator;
@interface LongRunningFunction : NSObject
@property(nonatomic,assign,readonly) BOOL longRunning; // YES

// !!! Все названия методов должны начинаться с приставки f_,
// т.к. имена иногда совпадают с зарезервированными словами if, swith и т.д.

-(Value*) f_lookup:(ExpressionEvaluator*)evaluator args:(NSArray*)args;
//dictionaryName:(Value*)dictionaryName targetField:(Value*)targetField values:(NSArray*)args;


@end
