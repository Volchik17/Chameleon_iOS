//
//  BankConnection.m
//  Chameleon
//
//  Created by Volchik on 28.11.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import "BankConnection.h"
#import "BSConnection.h"
#import "Bank.h"

@implementation BankConnection

-(instancetype) initWithBank:(Bank*) bank
{
    self=[super init];
    if (self)
    {
        _bank=bank;
    }
    return self;
}

-(Answer*) runRequest:(Request*) request error:(NSError**) error
{
    return nil;
    
}

-(BSConnection*) getInfoConnection
{
    return [BSConnection plainConnectionToURL:[_bank url]];
}

-(BSConnection*) getConnection
{
    return [BSConnection plainConnectionToURL:[_bank url]];
}

@end
