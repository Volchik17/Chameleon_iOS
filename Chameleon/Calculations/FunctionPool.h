//
//  FunctionPool.h
//  mBSClient
//
//  Created by Maksim Voronin on 15.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "objc/runtime.h"

@class Value;
@class ExpressionEvaluator;
@interface FunctionInfo : NSObject
@property(nonatomic,strong,readonly) id pool;
@property(nonatomic,assign,readonly) SEL selector;
@property(nonatomic,assign,readonly) BOOL longRunning;
@end

@interface FunctionPool : NSObject
@property(nonatomic,strong,readonly) NSMutableDictionary* pool;
+ (FunctionPool*) sharedInstance;
- (BOOL) isFunctionLongRunning:(NSString*)functionNam;
-(void) registerFunctions:(id)functions;
-(void) registerFunctions:(id)functions longRunning:(BOOL) longRunning;
- (Value*) calculateFunctionResult:(ExpressionEvaluator*) evaluator functionName:(NSString*)functionName args:(NSArray*)args;
- (BOOL) functionExists:(NSString*)functionName;
@end


