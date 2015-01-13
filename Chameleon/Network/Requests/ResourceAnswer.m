//
//  ResourceAnswer.m
//  Chameleon
//
//  Created by Volchik on 06.01.15.
//  Copyright (c) 2015 Volchik. All rights reserved.
//

#import "ResourceAnswer.h"

@implementation ResourceAnswer

-(NSError*) parseResponse:(NSURLResponse*) response withData:(NSData*) data
{
    NSHTTPURLResponse* r=(NSHTTPURLResponse*)response;
    if (r.statusCode==404)
        return [NSError errorWithDomain:@"ResourceRequest" code:404 userInfo:nil];
    if (r.statusCode==304)
    {
        _isUnchanged=YES;
        _data=nil;
        return nil;
    }
    _isUnchanged=NO;
    _data=data;
    return nil;
}

@end
