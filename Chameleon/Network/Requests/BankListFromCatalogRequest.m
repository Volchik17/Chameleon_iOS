//
//  BankListFromCatalogRequest.m
//  Chameleon
//
//  Created by Volchik on 07.12.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import "BankListFromCatalogRequest.h"
#import "XMLNodeWriter.h"
#import "BankListFromCatalogAnswer.h"
#import "BSConnection.h"

@implementation BankListFromCatalogRequest

-(NSString*) makeURLForRequest:(BSConnection*) connection
{
    NSString* url=[self concatURL:connection.url withTail:@"list"];
    NSLog(@"%@",url);
    return url;
}

-(NSURLRequest*) urlRequestForConnection:(BSConnection*) connection
{
    NSMutableURLRequest* request=[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[self makeURLForRequest:connection]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:connection.defaultTimeout];
    [request setHTTPMethod:@"GET"];
    return request;
}

-(Class) getAnswerClass
{
    return [BankListFromCatalogAnswer class];
}

@end
