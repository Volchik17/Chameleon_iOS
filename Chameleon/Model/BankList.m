//
//  BankList.m
//  Chameleon
//
//  Created by Volchik on 27.11.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import "BankList.h"

@implementation BankList

-(instancetype) init
{
    self=[super init];
    if (self)
    {
        [self load];
    }
    return self;
}

-(int) getCount
{
    return banks.count;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len
{
    return [banks countByEnumeratingWithState:state objects:buffer count:len];
}

-(void) save
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:banks] forKey:@"banks"];
    [defaults synchronize];
    
}

-(void) load
{
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    NSData *dataRepresentingSavedArray = [currentDefaults objectForKey:@"banks"];
    if (dataRepresentingSavedArray != nil)
    {
        NSArray *oldSavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
        if (oldSavedArray != nil)
            banks = [[NSMutableArray alloc] initWithArray:oldSavedArray];
        else
            banks = [[NSMutableArray alloc] init];
    }
}

@end
