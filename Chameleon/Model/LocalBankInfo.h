//
//  Bank.h
//  Chameleon
//
//  Created by Volchik on 27.11.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BankCard.h"

@interface LocalBankInfo : NSObject

@property (nonatomic,strong) NSString* url;
@property (nonatomic, strong) NSString* bankId;
@property (nonatomic,assign) NSUInteger bankIndex;
@property (nonatomic,strong) BankCard* bankCard;

@end
