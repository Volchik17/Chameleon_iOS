//
//  BankConnection.m
//  Chameleon
//
//  Created by Volchik on 28.11.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import "BankConnection.h"

@implementation BankConnection

-(instancetype) initWithBank:(Bank*) bank
{
    self=[super init];
    if (self)
    {
        
    }
    return self;
}

-(Answer*) runRequest:(Request*) request error:(NSError**) error
{
    return nil;
    
}

@end
