//
//  PingRequest.m
//  Chameleon
//
//  Created by Volchik on 15.12.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import "PingRequest.h"
#import "PingAnswer.h"

@implementation PingRequest

-(NSString*) makeURLForRequest:(BSConnection*) connection
{
    NSString* url=[self concatURL:connection.url withTail:@"ping"];
    NSLog(@"%@",url);
    return url;
}

-(NSURLRequest*) urlRequestForConnection:(BSConnection*) connection
{
    NSMutableURLRequest* request=[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[self makeURLForRequest:connection]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:connection.defaultTimeout];
    [request setHTTPMethod:@"POST"];
    return request;
}

-(Class) getAnswerClass
{
    return [PingAnswer class];
}

@end
