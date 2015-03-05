//
//  BankList.h
//  Chameleon
//
//  Created by Volchik on 27.11.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalBankInfo.h"

@interface  NSArray(LocalBankInfoList)

-(NSUInteger) indexOfUrl:(NSString*)url bankId:(NSString*) bankId;
-(LocalBankInfo*) getByIndex:(NSUInteger) bankIndex;

@end
