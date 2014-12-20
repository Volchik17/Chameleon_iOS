//
//  MetadataAnswer.m
//  Chameleon
//
//  Created by Volchik on 17.12.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import "MetadataAnswer.h"

@implementation MetadataAnswer

-(NSError*) parseResponse:(NSURLResponse*) response withData:(NSData*) data
{
    NSHTTPURLResponse* r=(NSHTTPURLResponse*)response;
    if (r.statusCode==404)
        return [NSError errorWithDomain:@"MetadataRequest" code:404 userInfo:nil];
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
