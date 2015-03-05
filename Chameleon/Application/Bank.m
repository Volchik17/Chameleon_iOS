//
//  Bank.m
//  Chameleon
//
//  Created by Volchik on 18.01.15.
//  Copyright (c) 2015 Volchik. All rights reserved.
//

#import "Bank.h"
#import "BSConnection.h"

@implementation Bank

-(instancetype) initWithLocalBankInfo:(LocalBankInfo*)bank
{
    self=[super init];
    if (self)
    {
        _bankIndex=bank.bankIndex;
        _bankId=bank.bankId;
        _url=bank.url;
        _bankCard=bank.bankCard;
    }
    return self;
}

-(instancetype) initWithBankIndex:(NSUInteger) bankIndex bankId:(NSString*) bankId url:(NSString*) url bankCard:(BankCard*) bankCard
{
    self=[super init];
    if (self)
    {
        _bankIndex=bankIndex;
        _bankId=bankId;
        _url=url;
        _bankCard=bankCard;
    }
    return self;
}

-(void) fillLocalBankInfo:(LocalBankInfo*) localBank
{
    localBank.bankIndex=_bankIndex;
    localBank.bankId=_bankId;
    localBank.url=_url;
    localBank.bankCard=_bankCard;
}

-(BSConnection*) getInfoConnection
{
    return [BSConnection plainConnectionToURL:_url];
}

-(BSConnection*) getConnection
{
    return [BSConnection plainConnectionToURL:_url];
}

@end
