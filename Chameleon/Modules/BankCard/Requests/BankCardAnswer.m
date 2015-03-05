//
//  BankCardAnswer.m
//  Chameleon
//
//  Created by Volchik on 19.01.15.
//  Copyright (c) 2015 Volchik. All rights reserved.
//

#import "BankCardAnswer.h"
#import "BankCard.h"

@implementation BankCardAnswer

-(CustomizableEntity*) createEntity
{
    return [[BankCard alloc] init];
}

@end
