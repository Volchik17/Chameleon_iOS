//
//  FunctionPool.m
//  mBSClient
//
//  Created by Maksim Voronin on 15.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "FunctionPool.h"
#import "Value.h"
#import "ExpressionEvaluator.h"
#import <objc/message.h>
#import "CommonFunctions.h"

@implementation FunctionInfo

- (id)initWithObject:(id)pool selector:(SEL)selector longRunning:(BOOL)longRunning
{
    self = [super init];
    if (self)
    {
        _pool = pool;
        _selector = selector;
        _longRunning = longRunning;
    }
    return self;
}

@end

@implementation FunctionPool

@synthesize pool = _pool;

+ (FunctionPool *) sharedInstance
{
    static FunctionPool *_functionPool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _functionPool = [[FunctionPool alloc] init];
    });
    return _functionPool;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _pool = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(BOOL) isFunctionLongRunning:(NSString*)functionName
{
    FunctionInfo* info = [_pool objectForKey:functionName];
    return info == nil || info.longRunning;
}

-(Value*) calculateFunctionResult:(ExpressionEvaluator*)evaluator functionName:(NSString*)functionName args:(NSArray*)args
{
    FunctionInfo* info= [_pool objectForKey:functionName];
    if (info == nil)
    {
        @throw [NSException exceptionWithName:[NSString stringWithFormat:@"Function \"%@\" does not exist.",functionName]
                                       reason:nil userInfo:nil];
    }
    if (args.count>0)
        return ((Value*(*)(id, SEL,ExpressionEvaluator*,NSArray*))objc_msgSend)(info.pool, info.selector,evaluator,args);
    else
        return ((Value*(*)(id, SEL,ExpressionEvaluator*))objc_msgSend)(info.pool, info.selector,evaluator);
}

-(void) registerFunctions:(id)functions
{
    [self registerFunctions:functions longRunning:NO];
}

-(void) registerFunctions:(id)functions longRunning:(BOOL) longRunning
{
    unsigned int count = 0;
    Method* methods = class_copyMethodList([functions class], &count);
    for (unsigned int i=0; i < count; i++)
    {
        Method method = methods[i];
        NSString* functionName = [[NSStringFromSelector(method_getName(method)) componentsSeparatedByString:@":"] objectAtIndex:0];
        NSString* keyFunction  = [functionName stringByReplacingOccurrencesOfString:@"f_" withString:@""];
        SEL selector=method_getName(method);
        [_pool setObject:[[FunctionInfo alloc] initWithObject:functions selector:selector longRunning:longRunning] forKey:keyFunction];
    }
    free(methods);
}

-(BOOL) functionExists:(NSString*)functionName
{
    return [_pool objectForKey:functionName] != nil;
}

@end



