//
//  BankList.h
//  Chameleon
//
//  Created by Volchik on 27.11.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bank.h"

@interface BankList : NSObject<NSFastEnumeration>
{
    @private
    NSMutableArray* banks;
}

-(void) save;
-(void) load;
-(Bank*) addBankWithUrl:(NSString*)url bankId:(NSString*) bankId;
-(NSUInteger) indexOf:(NSString*)url bankId:(NSString*) bankId;
-(void) deleteBank:(NSUInteger) index;

@property (readonly,nonatomic,getter=getCount) int count;

@end
