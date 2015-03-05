//
//  SimpleRequest.m
//  Chameleon
//
//  Created by Volchik on 06.01.15.
//  Copyright (c) 2015 Volchik. All rights reserved.
//

#import "SimpleRequest.h"
#import "BSConnection.h"

@implementation SimpleRequest

-(instancetype) initWithWithBankId:(NSString*) bankId answerClass:(Class) answerClass moduleType:(NSString*) moduleType moduleName:(NSString*) moduleName requestName:(NSString*) requestName
{
    self=[super init];
    if (self)
    {
        _answerClass=answerClass;
        _bankId=bankId;
        _moduleType=moduleType;
        _moduleName=moduleName;
        _requestName=requestName;
        _localeId=@"";
    }
    return self;
}

-(instancetype) initWithWithBankId:(NSString*) bankId answerClass:(Class) answerClass moduleType:(NSString*) moduleType moduleName:(NSString*) moduleName requestName:(NSString*) requestName localeId:(NSString*) localeId
{
    self=[super init];
    if (self)
    {
        _answerClass=answerClass;
        _bankId=bankId;
        _moduleType=moduleType;
        _moduleName=moduleName;
        _requestName=requestName;
        _localeId=localeId;
    }
    return self;
}

-(NSString*) makeURLForRequest:(BSConnection*) connection
{
    NSString* requestString=[NSString stringWithFormat:@"inforequest?bankId=%@&moduleType=%@&moduleName=%@&request=%@",_bankId,_moduleType,_moduleName,_requestName];
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
    return _answerClass;
}

@end
