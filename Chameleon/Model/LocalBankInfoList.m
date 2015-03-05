//
//  BankList.m
//  Chameleon
//
//  Created by Volchik on 27.11.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import "LocalBankInfoList.h"
#import "LocalBankInfo.h"

@implementation NSMutableArray(LocalBankInfoList)

-(NSUInteger) indexOfUrl:(NSString*)url bankId:(NSString*) bankId {
    for (LocalBankInfo* bank in self)
        if ([[bank.url uppercaseString] isEqualToString:[url uppercaseString]] && [bank.bankId isEqualToString:bankId])
            return bank.bankIndex;
    return NSNotFound;
}

-(LocalBankInfo*) getByIndex:(NSUInteger) bankIndex
{
    for (LocalBankInfo* bank in self)
        if (bank.bankIndex==bankIndex)
            return bank;
    return nil;
}

@end
