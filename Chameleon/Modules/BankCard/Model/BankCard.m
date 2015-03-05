//
//  BankCard.m
//  Chameleon
//
//  Created by Volchik on 26.11.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import "BankCard.h"

@implementation BankCard

- (void) registerFields
{
    [super registerFields];
    [self registerSystemField:@"bankName"];
}

@end