//
//  Bank.h
//  Chameleon
//
//  Created by Volchik on 18.01.15.
//  Copyright (c) 2015 Volchik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalBankInfo.h"
#import "BankCard.h"

@class BSConnection;

@interface Bank : NSObject

@property (nonatomic,assign) NSUInteger bankIndex;
@property (nonatomic,strong) NSString* bankId;
@property (nonatomic,strong) NSString* url;
@property (nonatomic,strong) BankCard* bankCard;

-(instancetype) initWithLocalBankInfo:(LocalBankInfo*)bank;
-(instancetype) initWithBankIndex:(NSUInteger) bankIndex bankId:(NSString*) bankId url:(NSString*) url bankCard:(BankCard*) bankCard;

-(void) fillLocalBankInfo:(LocalBankInfo*) localBank;

-(BSConnection*) getInfoConnection;
-(BSConnection*) getConnection;

@end
