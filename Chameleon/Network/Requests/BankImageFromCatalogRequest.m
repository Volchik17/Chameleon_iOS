//
//  BankImageFromCatalogRequest.m
//  Chameleon
//
//  Created by Volchik on 10.12.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import "BankImageFromCatalogRequest.h"
#import "BankImageFromCatalogAnswer.h"
#import "BSConnection.h"

@implementation BankImageFromCatalogRequest

-(instancetype) initWithId:(NSString*) catalogBankId
{
    self=[super init];
    if (self)
    {
        _catalogBankId=catalogBankId;
    }
    return self;
}

-(NSString*) makeURLForRequest:(BSConnection*) connection
{
    NSString* url=[self concatURL:connection.url withTail:[NSMutableString stringWithFormat:@"logo?id=%@",_catalogBankId]];
    NSLog(@"%@",url);
    return url;
}

-(NSURLRequest*) urlRequestForConnection:(BSConnection*) connection
{
    NSMutableURLRequest* request=[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[self makeURLForRequest:connection]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:connection.defaultTimeout];
    [request setHTTPMethod:@"GET"];
    return request;
}

-(Class) getAnswerClass
{
    return [BankImageFromCatalogAnswer class];
}

@end
