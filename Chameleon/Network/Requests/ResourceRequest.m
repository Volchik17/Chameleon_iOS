//
//  ResourceRequest.m
//  Chameleon
//
//  Created by Volchik on 06.01.15.
//  Copyright (c) 2015 Volchik. All rights reserved.
//

#import "ResourceRequest.h"
#import "ResourceAnswer.h"
#import "BSConnection.h"

@implementation ResourceRequest

-(instancetype) initWithBankId:(NSString*) bankId moduleType:(NSString*) moduleType moduleName:(NSString*) moduleName resourceName:(NSString*) resourceName savedHash:(NSString*) savedHash
{
    self=[super init];
    if (self)
    {
        _bankId=bankId;
        _moduleType=moduleType;
        _moduleName=moduleName;
        _resourceName=resourceName;
        _savedHash=savedHash;
        
    }
    return self;
}

-(NSString*) makeURLForRequest:(BSConnection*) connection
{
    NSString* requestString=[NSString stringWithFormat:@"resource?bankId=%@&moduleType=%@&moduleName=%@&resourceName=%@&savedHash=%@",_bankId,_moduleType,_moduleName,_resourceName,_savedHash];
    NSString* url=[self concatURL:connection.url withTail:requestString];
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
    return [ResourceAnswer class];
}

@end
