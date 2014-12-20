//
//  MetadataRequest.m
//  Chameleon
//
//  Created by Volchik on 17.12.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import "MetadataRequest.h"
#import "MetadataAnswer.h"

@implementation MetadataRequest

-(instancetype) initWithBankId:(NSString*) bankId structureClass: (Class) structureClass moduleType:(NSString*) moduleType moduleName:(NSString*) moduleName structureName:(NSString*) structureName savedHash:(NSString*) savedHash localeName:(NSString*) localeName
{
    self=[super init];
    if (self)
    {
        _bankId=bankId;
        structureClass=_structureClass;
        _moduleType=moduleType;
        _moduleName=moduleName;
        _structureName=structureName;
        _savedHash=savedHash;
        _localeName=localeName;
    }
    return self;
}

-(instancetype) initWithBankId:(NSString*) bankId structureClass: (Class) structureClass moduleType:(NSString*) moduleType moduleName:(NSString*) moduleName structureName:(NSString*) structureName savedHash:(NSString*) savedHash
{
    return [self initWithBankId:bankId structureClass:structureClass moduleType:moduleType moduleName:moduleName structureName:structureName savedHash:savedHash localeName:@""];
}

-(NSString*) makeURLForRequest:(BSConnection*) connection
{
    NSString* requestString=[NSString stringWithFormat:@"metadata?bankId=%@:moduleType=%@:moduleName=%@:structureName=%@:langId=%@:savedHash=%@",_bankId,_moduleType,_moduleName,_structureName,_localeName,_savedHash];
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
