//
//  Bank.m
//  Chameleon
//
//  Created by Volchik on 27.11.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import "LocalBankInfo.h"

@implementation LocalBankInfo

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:self.url forKey:@"url"];
    [coder encodeObject:self.bankId forKey:@"bankId"];
    [coder encodeInteger:self.bankIndex forKey:@"bankIndex"];
    [coder encodeObject:self.bankCard forKey:@"bankCard"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [super init];
    if (self != nil)
    {
        self.url = [coder decodeObjectForKey:@"url"];
        self.bankId= [coder decodeObjectForKey:@"bankId"];
        self.bankIndex=[coder decodeIntegerForKey:@"bankIndex"];
        self.bankCard=[coder decodeObjectForKey:@"bankCard"];
    }
    return self;
}

@end
