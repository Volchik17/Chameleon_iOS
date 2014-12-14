//
//  Bank.m
//  Chameleon
//
//  Created by Volchik on 27.11.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import "Bank.h"

@implementation Bank

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:self.url forKey:@"url"];
    [coder encodeObject:self.bankId forKey:@"bankId"];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [super init];
    if (self != nil)
    {
        self.url = [coder decodeObjectForKey:@"url"];
        self.bankId= [coder decodeObjectForKey:@"bankId"];
    }
    return self;
}

@end
