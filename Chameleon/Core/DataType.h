//
//  DataType.h
//  mBSClient
//
//  Created by Maksim Voronin on 18.09.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    STRING,
    INTEGER,
    LONG,
    DOUBLE,
    MONEY,
    DATE,
    DATETIME,
    BOOLEAN,
    UNKNOWN
} DataType;

DataType getTypeWithName(NSString* name);
NSString* getNameWithType(DataType type);
