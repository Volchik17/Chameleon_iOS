//
//  LongRunningFunction.m
//  mBSClient
//
//  Created by Maksim Voronin on 16.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "LongRunningFunction.h"
#import "Value.h"
#import "ExpressionEvaluator.h"

@implementation LongRunningFunction

- (id)init
{
    self = [super init];
    if (self)
    {
        _longRunning = YES;
    }
    return self;
}

-(Value*) f_lookup:(ExpressionEvaluator*)evaluator args:(NSArray*)args
{
    return nil;
}

@end
