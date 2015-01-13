//
//  DataType.m
//  mBSClient
//
//  Created by Maksim Voronin on 18.09.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "DataType.h"

DataType getTypeWithName(NSString* name)
{
    if ([[name uppercaseString] isEqualToString:@"STRING"])
    {
        return STRING;
    }
    else if ([[name uppercaseString] isEqualToString:@"INTEGER"])
    {
        return INTEGER;
    }
    else if ([[name uppercaseString] isEqualToString:@"LONG"])
    {
        return LONG;
    }
    else if ([[name uppercaseString] isEqualToString:@"DOUBLE"])
    {
        return DOUBLE;
    }
    else if ([[name uppercaseString] isEqualToString:@"MONEY"])
    {
        return MONEY;
    }
    else if ([[name uppercaseString] isEqualToString:@"DATE"])
    {
        return DATE;
    }
    else if ([[name uppercaseString] isEqualToString:@"DATETIME"])
    {
        return DATETIME;
    }
    else if ([[name uppercaseString] isEqualToString:@"BOOLEAN"])
    {
        return BOOLEAN;
    }
    else
    {
        return UNKNOWN;
    }
}

NSString* getNameWithType(DataType type)
{
    switch (type)
    {
        case STRING:
        {
            return @"STRING";
            break;
        }
        case INTEGER:
        {
            return @"INTEGER";
            break;
        }
        case LONG:
        {
            return @"LONG";
            break;
        }
        case DOUBLE:
        {
            return @"DOUBLE";
            break;
        }
        case MONEY:
        {
            return @"MONEY";
            break;
        }
        case DATETIME:
        {
            return @"DATETIME";
            break;
        }
        case DATE:
        {
            return @"DATE";
            break;
        }
        case BOOLEAN:
        {
            return @"BOOLEAN";
            break;
        }
        case UNKNOWN:
        {
            return @"UNKNOWN";
            break;
        }
    }
    return @"NON TYPE";
}

