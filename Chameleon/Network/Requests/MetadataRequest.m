//
//  MetadataRequest.m
//  Chameleon
//
//  Created by Volchik on 17.12.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import "MetadataRequest.h"
#import "MetadataAnswer.h"
#import "BSConnection.h"

@implementation MetadataRequest

-(instancetype) initWithBankId:(NSString*) bankId moduleType:(NSString*) moduleType moduleName:(NSString*) moduleName structureName:(NSString*) structureName savedHash:(NSString*) savedHash localeId:(NSString*) localeId
{
    self=[super init];
    if (self)
    {
        _bankId=bankId;
        _moduleType=moduleType;
        _moduleName=moduleName;
        _structureName=structureName;
        _savedHash=savedHash;
        _localeId=localeId;
    }
    return self;
}

-(instancetype) initWithBankId:(NSString*) bankId moduleType:(NSString*) moduleType moduleName:(NSString*) moduleName structureName:(NSString*) structureName savedHash:(NSString*) savedHash
{
    return [self initWithBankId:bankId moduleType:moduleType moduleName:moduleName structureName:structureName savedHash:savedHash localeId:@""];
}

-(NSString*) makeURLForRequest:(BSConnection*) connection
{
    NSString* requestString=[NSString stringWithFormat:@"metadata?bankId=%@&moduleType=%@&moduleName=%@&structureName=%@&langId=%@&savedHash=%@",_bankId,_moduleType,_moduleName,_structureName,_localeId,_savedHash];
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
    return [MetadataAnswer class];
}

@end
