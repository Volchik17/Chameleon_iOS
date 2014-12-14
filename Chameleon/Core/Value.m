//
//  Value.m
//  mBSClient
//
//  Created by Maksim Voronin on 18.09.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "Value.h"
#import "DataType.h"

@interface Value()
@property(nonatomic,strong) id obj;
@property(nonatomic,assign) DataType type;
@property(nonatomic,strong) NSValue* value;
@end

@implementation Value

@synthesize type,obj,value;

+(id) unknown
{
    return [[Value alloc] initWithDataType:UNKNOWN value:nil];
}

- (id)initWithDataType:(DataType)dt value:(NSValue*)vl
{
    self = [super init];
    if (self)
    {
        type = dt;
        
        if (vl != nil)
        {
            switch (type)
            {
                case STRING:
                {
                    if (strcmp([vl objCType], @encode(NSString))==0)
                    {
                        obj   = [vl nonretainedObjectValue];
                        value = [NSValue value:&obj withObjCType:@encode(NSString)];
                    }
                    else if (strcmp([vl objCType], @encode(int))==0)
                    {
                        int i; [vl getValue:(void *)&i];
                        obj = [[NSNumber numberWithInt:i] stringValue];
                        value = [NSValue value:&obj withObjCType:@encode(NSString)];
                    }
                    else if (strcmp([vl objCType], @encode(long long))==0)
                    {
                        long long l; [vl getValue:(void *)&l];
                        obj = [[NSNumber numberWithLongLong:l] stringValue];
                        value = [NSValue value:&obj withObjCType:@encode(NSString)];
                    }
                    else if (strcmp([vl objCType], @encode(double))==0)
                    {
                        double d; [vl getValue:(void *)&d];
                        obj = [[NSNumber numberWithDouble:d] stringValue];
                        value = [NSValue value:&obj withObjCType:@encode(NSString)];
                    }
                    else if (strcmp([vl objCType], @encode(NSDate))==0)
                    {
                        self.obj = [vl nonretainedObjectValue];
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:@"dd.MM.yyyy HH:mm:ss"];
                        obj = [dateFormatter stringFromDate:self.obj];
                        value = [NSValue value:&obj withObjCType:@encode(NSString)];
                    }
                    else if (strcmp([vl objCType], @encode(BOOL))==0)
                    {
                        BOOL b; [vl getValue:(void *)&b];
                        obj = [[NSNumber numberWithBool:b] stringValue];
                        value = [NSValue value:&obj withObjCType:@encode(NSString)];
                    }
                    else
                    {
                        NSLog(@"Invalid conversion from type - %s to STRING data type.",[vl objCType]);
                    }
                    break;
                }
                case INTEGER:
                {
                    if (strcmp([vl objCType], @encode(NSString))==0)
                    {
                        NSString* str = [vl nonretainedObjectValue];
                        int i = [str intValue];
                        value = [NSValue value:&i withObjCType:@encode(int)];
                    }
                    else if (strcmp([vl objCType], @encode(int))==0)
                    {
                        value = vl;
                    }
                    else if (strcmp([vl objCType], @encode(long long))==0)
                    {
                        long long l; [vl getValue:(void *)&l];
                        int i = (int)l;
                        value = [NSValue value:&i withObjCType:@encode(int)];
                    }
                    else if (strcmp([vl objCType], @encode(double))==0)
                    {
                        double d; [vl getValue:(void *)&d];
                        int i = (int)d;
                        value = [NSValue value:&i withObjCType:@encode(int)];
                    }
                    else if (strcmp([vl objCType], @encode(NSDate))==0)
                    {
                        NSDate* date = [vl nonretainedObjectValue];
                        int millseconds = [date timeIntervalSince1970] * 1000;
                        value = [NSValue value:&millseconds withObjCType:@encode(int)];
                    }
                    else if (strcmp([vl objCType], @encode(BOOL))==0)
                    {
                        BOOL b; [vl getValue:(void *)&b];
                        int i = (int)b;
                        value = [NSValue value:&i withObjCType:@encode(int)];
                    }
                    else
                    {
                        NSLog(@"Invalid conversion from type - %s to INTEGER data type.",[vl objCType]);
                    }
                    break;
                }
                case LONG:
                {
                    if (strcmp([vl objCType], @encode(NSString))==0)
                    {
                        NSString* str = [vl nonretainedObjectValue];
                        long long l = [str longLongValue];
                        value = [NSValue value:&l withObjCType:@encode(long long)];
                    }
                    else if (strcmp([vl objCType], @encode(int))==0)
                    {
                        int i; [vl getValue:(void *)&i];
                        long long l = (long long)i;
                        value = [NSValue value:&l withObjCType:@encode(long long)];
                    }
                    else if (strcmp([vl objCType], @encode(long long))==0)
                    {
                        value = vl;
                    }
                    else if (strcmp([vl objCType], @encode(double))==0)
                    {
                        double d; [vl getValue:(void *)&d];
                        long long l = (long long)d;
                        value = [NSValue value:&l withObjCType:@encode(long long)];
                    }
                    else if (strcmp([vl objCType], @encode(NSDate))==0)
                    {
                        NSDate* date = [vl nonretainedObjectValue];
                        long long millseconds = (long long)[date timeIntervalSince1970] * 1000;
                        value = [NSValue value:&millseconds withObjCType:@encode(long long)];
                    }
                    else if (strcmp([vl objCType], @encode(BOOL))==0)
                    {
                        BOOL b; [vl getValue:(void *)&b];
                        long long l = (long long)b;
                        value = [NSValue value:&l withObjCType:@encode(long long)];
                    }
                    else
                    {
                        NSLog(@"Invalid conversion from type - %s to LONG data type.",[vl objCType]);
                    }
                    break;
                }
                case DOUBLE:
                {
                    if (strcmp([vl objCType], @encode(NSString))==0)
                    {
                        NSString* str = [vl nonretainedObjectValue];
                        double d = [str doubleValue];
                        value = [NSValue value:&d withObjCType:@encode(double)];
                    }
                    else if (strcmp([vl objCType], @encode(int))==0)
                    {
                        double d = 0;
                        int i; [vl getValue:(void *)&i];
                        d = (double) i;
                        value = [NSValue value:&d withObjCType:@encode(double)];
                    }
                    else if (strcmp([vl objCType], @encode(long long))==0)
                    {
                        long long l; [vl getValue:(void *)&l];
                        double d = (double)l;
                        value = [NSValue value:&d withObjCType:@encode(double)];
                    }
                    else if (strcmp([vl objCType], @encode(double))==0)
                    {
                        value = vl;
                    }
                    else if (strcmp([vl objCType], @encode(NSDate))==0)
                    {
                        NSDate* date = [vl nonretainedObjectValue];
                        double millseconds = (double)[date timeIntervalSince1970] * 1000;
                        value = [NSValue value:&millseconds withObjCType:@encode(double)];
                    }
                    else if (strcmp([vl objCType], @encode(BOOL))==0)
                    {
                        BOOL b; [vl getValue:(void *)&b];
                        double d = (double)b;
                        value = [NSValue value:&d withObjCType:@encode(double)];
                    }
                    else
                    {
                        NSLog(@"Invalid conversion from type - %s to DOUBLE data type.",[vl objCType]);
                    }
                    break;
                }
                case MONEY:
                {
                    if (strcmp([vl objCType], @encode(NSString))==0)
                    {
                        NSString* str = [vl nonretainedObjectValue];
                        double d = [str doubleValue];
                        value = [NSValue value:&d withObjCType:@encode(double)];
                    }
                    else if (strcmp([vl objCType], @encode(int))==0)
                    {
                        int i; [vl getValue:(void *)&i];
                        double d = (double)i;
                        value = [NSValue value:&d withObjCType:@encode(double)];
                    }
                    else if (strcmp([vl objCType], @encode(long long))==0)
                    {
                        long long l; [vl getValue:(void *)&l];
                        double d = (double)l;
                        value = [NSValue value:&d withObjCType:@encode(double)];
                    }
                    else if (strcmp([vl objCType], @encode(double))==0)
                    {
                        value = vl;
                    }
                    else if (strcmp([vl objCType], @encode(NSDate))==0)
                    {
                        NSDate* date = [vl nonretainedObjectValue];
                        double millseconds = (double)[date timeIntervalSince1970] * 1000;
                        value = [NSValue value:&millseconds withObjCType:@encode(double)];
                    }
                    else if (strcmp([vl objCType], @encode(BOOL))==0)
                    {
                        BOOL b; [vl getValue:(void *)&b];
                        double d = (double)b;
                        value = [NSValue value:&d withObjCType:@encode(double)];
                    }
                    else
                    {
                        NSLog(@"Invalid conversion from type - %s to MONEY data type.",[vl objCType]);
                    }
                    break;
                }
                case DATETIME:
                {
                    if (strcmp([vl objCType], @encode(NSString))==0)
                    {
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:@"dd.MM.yyyy HH:mm:ss"];
                        NSString* str = [vl nonretainedObjectValue];
                        obj = [dateFormatter dateFromString:str];
                        value = [NSValue value:&obj withObjCType:@encode(NSDate)];
                    }
                    else if (strcmp([vl objCType], @encode(int))==0)
                    {
                        int i; [vl getValue:(void *)&i];
                        int seconds = i / 1000;
                        obj = [NSDate dateWithTimeIntervalSince1970:seconds];
                        value = [NSValue value:&obj withObjCType:@encode(NSDate)];
                    }
                    else if (strcmp([vl objCType], @encode(long long))==0)
                    {
                        long long l; [vl getValue:(void *)&l];
                        long long seconds = l / 1000;
                        obj = [NSDate dateWithTimeIntervalSince1970:seconds];
                        value = [NSValue value:&obj withObjCType:@encode(NSDate)];
                    }
                    else if (strcmp([vl objCType], @encode(double))==0)
                    {
                        double d; [vl getValue:(void *)&d];
                        double seconds = d / 1000;
                        obj = [NSDate dateWithTimeIntervalSince1970:seconds];
                        value = [NSValue value:&obj withObjCType:@encode(NSDate)];
                    }
                    else if (strcmp([vl objCType], @encode(NSDate))==0)
                    {
                        value = vl;
                    }
                    else
                    {
                        NSLog(@"Invalid conversion from type - %s to DATETIME data type.",[vl objCType]);
                    }
                    break;
                }
                case DATE:
                {
                    if (strcmp([vl objCType], @encode(NSString))==0)
                    {
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:@"dd.MM.yyyy"];
                        NSString* str = [vl nonretainedObjectValue];
                        obj = [dateFormatter dateFromString:str];
                        value = [NSValue value:&obj withObjCType:@encode(NSDate)];
                    }
                    else if (strcmp([vl objCType], @encode(int))==0)
                    {
                        int i; [vl getValue:(void *)&i];
                        int seconds = i / 1000;
                        obj = [NSDate dateWithTimeIntervalSince1970:seconds];
                        value = [NSValue value:&obj withObjCType:@encode(NSDate)];
                    }
                    else if (strcmp([vl objCType], @encode(long long))==0)
                    {
                        long long l; [vl getValue:(void *)&l];
                        long long seconds = l / 1000;
                        obj = [NSDate dateWithTimeIntervalSince1970:seconds];
                        value = [NSValue value:&obj withObjCType:@encode(NSDate)];
                    }
                    else if (strcmp([vl objCType], @encode(double))==0)
                    {
                        double d; [vl getValue:(void *)&d];
                        double seconds = d / 1000;
                        obj = [NSDate dateWithTimeIntervalSince1970:seconds];
                        value = [NSValue value:&obj withObjCType:@encode(NSDate)];
                    }
                    else if (strcmp([vl objCType], @encode(NSDate))==0)
                    {
                        value = vl;
                    }
                    else
                    {
                        NSLog(@"Invalid conversion from type - %s to DATE data type.",[vl objCType]);
                    }
                    break;
                }
                case BOOLEAN:
                {
                    if (strcmp([vl objCType], @encode(NSString))==0)
                    {
                        NSString* str = [vl nonretainedObjectValue];
                        BOOL b = [str boolValue];
                        value = [NSValue value:&b withObjCType:@encode(BOOL)];
                    }
                    else if (strcmp([vl objCType], @encode(int))==0)
                    {
                        int i; [vl getValue:(void *)&i];
                        BOOL b = i != 0;
                        value = [NSValue value:&b withObjCType:@encode(BOOL)];
                    }
                    else if (strcmp([vl objCType], @encode(long long))==0)
                    {
                        long long l; [vl getValue:(void *)&l];
                        BOOL b = l != 0;
                        value = [NSValue value:&b withObjCType:@encode(BOOL)];
                    }
                    else if (strcmp([vl objCType], @encode(double))==0)
                    {
                        double d; [vl getValue:(void *)&d];
                        BOOL b = d != 0;
                        value = [NSValue value:&b withObjCType:@encode(BOOL)];
                    }
                    else if (strcmp([vl objCType], @encode(NSDate))==0)
                    {
                        NSDate* date = [vl nonretainedObjectValue];
                        double millseconds = (double)[date timeIntervalSince1970] * 1000;
                        BOOL b = millseconds != 0;
                        value = [NSValue value:&b withObjCType:@encode(BOOL)];
                    }
                    else if (strcmp([vl objCType], @encode(BOOL))==0)
                    {
                        value = vl;
                    }
                    else
                    {
                        NSLog(@"Invalid conversion from type - %s to DATE data type.",[vl objCType]);
                    }
                    break;
                }
                case UNKNOWN:
                default:
                    break;
            }
        }
    }
    return self;
}

- (id)initWithValue:(NSValue*)vl
{
    self = [super init];
    if (self)
    {
        value = vl;
        
        if (vl == nil)
        {
            type = STRING;
        }
        else if (strcmp([vl objCType], @encode(NSString))==0)
        {
            obj  = [vl nonretainedObjectValue];
            type = STRING;
        }
        else if (strcmp([vl objCType], @encode(int))==0)
        {
            type = INTEGER;
        }
        else if (strcmp([vl objCType], @encode(long long))==0)
        {
            type = LONG;
        }
        else if (strcmp([vl objCType], @encode(double))==0)
        {
            type = DOUBLE;
        }
        else if (strcmp([vl objCType], @encode(NSDate))==0)
        {
            obj  = [vl nonretainedObjectValue];
            type = DATETIME;
        }
        else if (strcmp([vl objCType], @encode(BOOL))==0)
        {
            type = BOOLEAN;
        }
        else
        {
            NSLog(@"Unknown value data type - %s .",[vl objCType]);
        }
    }
    return self;
}

- (id)initWithString:(NSString*)string
{
    self = [super init];
    if (self)
    {
        obj   = string;
        value = [NSValue value:&string withObjCType:@encode(NSString)];
        type  = STRING;
        
    }
    return self;
}

- (id)initWithInt:(int)i
{
    self = [super init];
    if (self)
    {
        value = [NSValue value:&i withObjCType:@encode(int)];
        type  = INTEGER;
    }
    return self;
}

- (id)initWithLong:(long long)l
{
    self = [super init];
    if (self)
    {
        value = [NSValue value:&l withObjCType:@encode(long long)];
        type  = LONG;
    }
    return self;
}

- (id)initWithDouble:(double)d
{
    self = [super init];
    if (self)
    {
        value = [NSValue value:&d withObjCType:@encode(double)];
        type  = DOUBLE;
    }
    return self;
}

- (id)initWithDate:(NSDate*)date
{
    self = [super init];
    if (self)
    {
        obj   = date;
        value = [NSValue value:&date withObjCType:@encode(NSDate)];
        type  = DATE;
    }
    return self;
}

- (id)initWithDateTime:(NSDate*)date
{
    self = [super init];
    if (self)
    {
        obj   = date;
        value = [NSValue value:&date withObjCType:@encode(NSDate)];
        type  = DATETIME;
    }
    return self;
}

- (id)initWithBOOL:(BOOL)b
{
    self = [super init];
    if (self)
    {
        value = [NSValue value:&b withObjCType:@encode(BOOL)];
        type  = BOOLEAN;
    }
    return self;
}


-(DataType) getDataType
{
    return type;
}

-(NSValue*) getValue
{
    return value;
}

-(BOOL) isNil
{
    return value == nil;
}

-(BOOL) isUnknown
{
    return type == UNKNOWN;
}

-(NSString*) convertToString
{
    NSString* defaultValue = @"";
    if (value == nil) return defaultValue;
    
    switch (type)
    {
        case STRING:
        {
            return [value nonretainedObjectValue];
            break;
        }
        case INTEGER:
        {
            int ivalue;
            [value getValue:(void *)&ivalue];
            return [[NSNumber numberWithInt:ivalue] stringValue];
            break;
        }
        case LONG:
        {
            long long lvalue;
            [value getValue:(void *)&lvalue];
            return [[NSNumber numberWithLongLong:lvalue] stringValue];
            break;
        }
        case DOUBLE:
        case MONEY:
        {
            double dValue;
            [value getValue:(void *)&dValue];
            return [[NSNumber numberWithDouble:dValue] stringValue];
            break;
        }
        case DATETIME:
        {
            NSDate* dValue = [value nonretainedObjectValue];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd.MM.yyyy HH:mm:ss"];
            return [dateFormatter stringFromDate:dValue];
            break;
        }
        case DATE:
        {
            NSDate* dValue = [value nonretainedObjectValue];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd.MM.yyyy HH:mm:ss"];
            return [dateFormatter stringFromDate:dValue];
            break;
        }
        case BOOLEAN:
        {
            BOOL bValue;
            [value getValue:(void *)&bValue];
            return [[NSNumber numberWithBool:bValue] stringValue];
            break;
        }
        case UNKNOWN:
        default:
        {
            return defaultValue;
            break;
        }
    }
    return defaultValue;
}

-(double) convertToDouble
{
    double defaultValue = 0;
    if (value == nil) return defaultValue;
    
    switch (type)
    {
        case STRING:
        {
            return [(NSString*)[value nonretainedObjectValue] doubleValue];
            break;
        }
        case INTEGER:
        {
            int iValue;
            [value getValue:(void *)&iValue];
            return (double)iValue;
            break;
        }
        case LONG:
        {
            long long lValue;
            [value getValue:(void *)&lValue];
            return (double)lValue;
            break;
        }
        case DOUBLE:
        case MONEY:
        {
            double dValue;
            [value getValue:(void *)&dValue];
            return dValue;
            break;
        }
        case DATETIME:
        case DATE:
        {
            NSDate* dValue = [value nonretainedObjectValue];
            return [dValue timeIntervalSince1970];
            break;
        }
        case BOOLEAN:
        {
            BOOL bValue;
            [value getValue:(void *)&bValue];
            return (double)bValue;
            break;
        }
        case UNKNOWN:
        default:
        {
            return defaultValue;
            break;
        }
    }
    return defaultValue;
}

-(long long) convertToLong
{
    long defaultValue = 0;
    if (value == nil) return defaultValue;
    
    switch (type)
    {
        case STRING:
        {
            return [(NSString*)[value nonretainedObjectValue] doubleValue];
            break;
        }
        case INTEGER:
        {
            int iValue;
            [value getValue:(void *)&iValue];
            return (long long)iValue;
            break;
        }
        case LONG:
        {
            long lValue;
            [value getValue:(void *)&lValue];
            return (long long)lValue;
            break;
        }
        case DOUBLE:
        case MONEY:
        {
            double dValue;
            [value getValue:(void *)&dValue];
            return (long long)dValue;
            break;
        }
        case DATETIME:
        case DATE:
        {
            NSDate* dValue = [value nonretainedObjectValue];
            return [dValue timeIntervalSince1970];
            break;
        }
        case BOOLEAN:
        {
            BOOL bValue;
            [value getValue:(void *)&bValue];
            return (long long)bValue;
            break;
        }
        case UNKNOWN:
        default:
        {
            return defaultValue;
            break;
        }
    }
    return defaultValue;
}

-(int) convertToInt
{
    int defaultValue = 0;
    if (value == nil) return defaultValue;
    
    switch (type)
    {
        case STRING:
        {
            return [(NSString*)[value nonretainedObjectValue] intValue];
            break;
        }
        case INTEGER:
        {
            int iValue;
            [value getValue:(void *)&iValue];
            return (int)iValue;
            break;
        }
        case LONG:
        {
            long long lValue;
            [value getValue:(void *)&lValue];
            return (int)lValue;
            break;
        }
        case DOUBLE:
        case MONEY:
        {
            double dValue;
            [value getValue:(void *)&dValue];
            return (int)dValue;
            break;
        }
        case DATETIME:
        case DATE:
        {
            NSDate* dValue = [value nonretainedObjectValue];
            return (int)[dValue timeIntervalSince1970];
            break;
        }
        case BOOLEAN:
        {
            BOOL bValue;
            [value getValue:(void *)&bValue];
            return (int)bValue;
            break;
        }
        case UNKNOWN:
        default:
        {
            return defaultValue;
            break;
        }
    }
    return defaultValue;
}

-(NSDate*) convertToDate
{
    NSDate* defaultValue = nil;
    if (value == nil) return defaultValue;
    
    switch (type)
    {
        case STRING:
        {
            NSString* sValue = [value nonretainedObjectValue];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd.MM.yyyy"];
            return [dateFormatter dateFromString:sValue];
            break;
        }
        case INTEGER:
        {
            int iValue;
            [value getValue:(void *)&iValue];
            double seconds = iValue / 1000;
            return [NSDate dateWithTimeIntervalSince1970:seconds];
            break;
        }
        case LONG:
        {
            long long lValue;
            [value getValue:(void *)&lValue];
            long long seconds = lValue / 1000;
            return [NSDate dateWithTimeIntervalSince1970:seconds];
            break;
        }
        case DOUBLE:
        {
            double dValue;
            [value getValue:(void *)&dValue];
            double seconds = dValue / 1000;
            return [NSDate dateWithTimeIntervalSince1970:seconds];
            break;
        }
        case MONEY:
        {
            NSLog(@"Invalid conversion from MONEY to DATE data type");
            break;
        }
        case DATETIME:
        {
            return [value nonretainedObjectValue];
            break;
        }
        case DATE:
        {
            return [value nonretainedObjectValue];
            break;
        }
        case BOOLEAN:
        {
            NSLog(@"Invalid conversion from BOOLEAN to DATE data type");
            break;
        }
        case UNKNOWN:
        default:
        {
            return defaultValue;
            break;
        }
    }
    return defaultValue;
}

-(BOOL) convertToBool
{
    BOOL defaultValue = FALSE;
    if (value == nil) return defaultValue;
    
    switch (type)
    {
        case STRING:
        {
            NSString* sValue = [value nonretainedObjectValue];
            return [sValue boolValue];
            break;
        }
        case INTEGER:
        {
            int iValue;
            [value getValue:(void *)&iValue];
            return iValue != 0;
            break;
        }
        case LONG:
        {
            long long lValue;
            [value getValue:(void *)&lValue];
            return lValue != 0;
            break;
        }
        case DOUBLE:
        {
            NSLog(@"Invalid conversion from DOUBLE to BOOLEAN data type");
            break;
        }
        case MONEY:
        {
            NSLog(@"Invalid conversion from MONEY to BOOLEAN data type");
            break;
        }
        case DATETIME:
        {
            NSLog(@"Invalid conversion from DATETIME to BOOLEAN data type");
            break;
        }
        case DATE:
        {
            NSLog(@"Invalid conversion from DATE to BOOLEAN data type");
            break;
        }
        case BOOLEAN:
        {
            BOOL bValue;
            [value getValue:(void *)&bValue];
            return bValue;
            break;
        }
        case UNKNOWN:
        default:
        {
            return defaultValue;
            break;
        }
    }
    return defaultValue;
}

+(Value*) valueOr:(Value*)v1 value:(Value*)v2
{
    if (v1.type==UNKNOWN || v2.type==UNKNOWN)
    {
        return [self unknown];
    }
    else
    {
        BOOL bResult = [v1 convertToBool] || [v2 convertToBool];
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
}

+(Value*) valueAnd:(Value*)v1 value:(Value*)v2
{
    if (v1.type==UNKNOWN || v2.type==UNKNOWN)
    {
        return [self unknown];
    }
    else
    {
        BOOL bResult = [v1 convertToBool] && [v2 convertToBool];
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
}

+(Value*) valueNot:(Value*)v1
{
    if (v1.type==UNKNOWN)
    {
        return [Value unknown];
    }
    else
    {
        BOOL bResult = ![v1 convertToBool];
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
}

+(Value*) valueEqual:(Value*)v1 value:(Value*)v2
{
    if (v1.type==UNKNOWN || v2.type==UNKNOWN)
    {
        return [self unknown];
    }
    else if (v1.type==STRING || v2.type==STRING)
    {
        BOOL bResult = [[v1 convertToString] isEqualToString:[v2 convertToString]];
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else if (v1.type==DOUBLE || v2.type==DOUBLE)
    {
        BOOL bResult = [v1 convertToDouble] == [v2 convertToDouble];
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else if (v1.type==MONEY || v2.type==MONEY)
    {
        BOOL bResult = [v1 convertToDouble] == [v2 convertToDouble];
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else if (v1.type==DATETIME || v2.type==DATETIME)
    {
        BOOL bResult = [v1 convertToLong] == [v2 convertToLong];
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else if (v1.type==DATE || v2.type==DATE)
    {
        BOOL bResult = [v1 convertToLong] == [v2 convertToLong];
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else if (v1.type==LONG || v2.type==LONG)
    {
        BOOL bResult = [v1 convertToLong] == [v2 convertToLong];
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else if (v1.type==INTEGER || v2.type==INTEGER)
    {
        BOOL bResult = [v1 convertToInt] == [v2 convertToInt];
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else if (v1.type==BOOLEAN || v2.type==BOOLEAN)
    {
        BOOL bResult = [v1 convertToBool] == [v2 convertToBool];
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else
    {
        return [Value unknown];
    }
}

+(Value*) valueNotEqual:(Value*)v1 value:(Value*)v2
{
    if (v1.type==UNKNOWN || v2.type==UNKNOWN)
    {
        return [self unknown];
    }
    else if (v1.type==STRING || v2.type==STRING)
    {
        BOOL bResult = ![[v1 convertToString] isEqualToString:[v2 convertToString]];
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else if (v1.type==DOUBLE || v2.type==DOUBLE)
    {
        BOOL bResult = [v1 convertToDouble] != [v2 convertToDouble];
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else if (v1.type==MONEY || v2.type==MONEY)
    {
        BOOL bResult = [v1 convertToDouble] != [v2 convertToDouble];
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else if (v1.type==DATETIME || v2.type==DATETIME)
    {
        BOOL bResult = [v1 convertToLong] != [v2 convertToLong];
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else if (v1.type==DATE || v2.type==DATE)
    {
        BOOL bResult = [v1 convertToLong] != [v2 convertToLong];
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else if (v1.type==LONG || v2.type==LONG)
    {
        BOOL bResult = [v1 convertToLong] != [v2 convertToLong];
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else if (v1.type==INTEGER || v2.type==INTEGER)
    {
        BOOL bResult = [v1 convertToInt] != [v2 convertToInt];
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else if (v1.type==BOOLEAN || v2.type==BOOLEAN)
    {
        BOOL bResult = [v1 convertToBool] != [v2 convertToBool];
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else
    {
        return [Value unknown];
    }
}

+(Value*) valueGreater:(Value*)v1 value:(Value*)v2
{
    if (v1.type==UNKNOWN || v2.type==UNKNOWN)
    {
        return [self unknown];
    }
    else if (v1.type==STRING || v2.type==STRING)
    {
        BOOL bResult = [[v1 convertToString] compare:[v2 convertToString]] > 0;
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else if (v1.type==DOUBLE || v2.type==DOUBLE)
    {
        BOOL bResult = [v1 convertToDouble] > [v2 convertToDouble];
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else if (v1.type==MONEY || v2.type==MONEY)
    {
        BOOL bResult = [v1 convertToDouble] > [v2 convertToDouble];
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else if (v1.type==DATETIME || v2.type==DATETIME)
    {
        BOOL bResult = [v1 convertToLong] > [v2 convertToLong];
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else if (v1.type==DATE || v2.type==DATE)
    {
        BOOL bResult = [v1 convertToLong] > [v2 convertToLong];
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else if (v1.type==LONG || v2.type==LONG)
    {
        BOOL bResult = [v1 convertToLong] > [v2 convertToLong];
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else if (v1.type==INTEGER || v2.type==INTEGER)
    {
        BOOL bResult = [v1 convertToInt] > [v2 convertToInt];
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else if (v1.type==BOOLEAN || v2.type==BOOLEAN)
    {
        NSNumber* n1 = [NSNumber numberWithBool:[v1 convertToBool]];
        NSNumber* n2 = [NSNumber numberWithBool:[v2 convertToBool]];
        BOOL bResult = [n1 compare:n2] > 0;
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else
    {
        return [Value unknown];
    }
}

+(Value*) valueGreaterEqual:(Value*)v1 value:(Value*)v2
{
    if (v1.type==UNKNOWN || v2.type==UNKNOWN)
    {
        return [self unknown];
    }
    else if (v1.type==STRING || v2.type==STRING)
    {
        BOOL bResult = [[v1 convertToString] compare:[v2 convertToString]] >= 0;
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else if (v1.type==DOUBLE || v2.type==DOUBLE)
    {
        BOOL bResult = [v1 convertToDouble] >= [v2 convertToDouble];
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else if (v1.type==MONEY || v2.type==MONEY)
    {
        BOOL bResult = [v1 convertToDouble] >= [v2 convertToDouble];
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else if (v1.type==DATETIME || v2.type==DATETIME)
    {
        BOOL bResult = [v1 convertToLong] >= [v2 convertToLong];
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else if (v1.type==DATE || v2.type==DATE)
    {
        BOOL bResult = [v1 convertToLong] >= [v2 convertToLong];
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else if (v1.type==LONG || v2.type==LONG)
    {
        BOOL bResult = [v1 convertToLong] >= [v2 convertToLong];
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else if (v1.type==INTEGER || v2.type==INTEGER)
    {
        BOOL bResult = [v1 convertToInt] >= [v2 convertToInt];
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else if (v1.type==BOOLEAN || v2.type==BOOLEAN)
    {
        NSNumber* n1 = [NSNumber numberWithBool:[v1 convertToBool]];
        NSNumber* n2 = [NSNumber numberWithBool:[v2 convertToBool]];
        BOOL bResult = [n1 compare:n2] >= 0;
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else
    {
        return [Value unknown];
    }
}

+(Value*) valueLesser:(Value*)v1 value:(Value*)v2
{
    if (v1.type==UNKNOWN || v2.type==UNKNOWN)
    {
        return [self unknown];
    }
    else if (v1.type==STRING || v2.type==STRING)
    {
        BOOL bResult = [[v1 convertToString] compare:[v2 convertToString]] < 0;
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else if (v1.type==DOUBLE || v2.type==DOUBLE)
    {
        BOOL bResult = [v1 convertToDouble] < [v2 convertToDouble];
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else if (v1.type==MONEY || v2.type==MONEY)
    {
        BOOL bResult = [v1 convertToDouble] < [v2 convertToDouble];
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else if (v1.type==DATETIME || v2.type==DATETIME)
    {
        BOOL bResult = [v1 convertToLong] < [v2 convertToLong];
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else if (v1.type==DATE || v2.type==DATE)
    {
        BOOL bResult = [v1 convertToLong] < [v2 convertToLong];
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else if (v1.type==LONG || v2.type==LONG)
    {
        BOOL bResult = [v1 convertToLong] < [v2 convertToLong];
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else if (v1.type==INTEGER || v2.type==INTEGER)
    {
        BOOL bResult = [v1 convertToInt] < [v2 convertToInt];
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else if (v1.type==BOOLEAN || v2.type==BOOLEAN)
    {
        NSNumber* n1 = [NSNumber numberWithBool:[v1 convertToBool]];
        NSNumber* n2 = [NSNumber numberWithBool:[v2 convertToBool]];
        BOOL bResult = [n1 compare:n2] < 0;
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else
    {
        return [Value unknown];
    }
}


+(Value*) valueLesserEqual:(Value*)v1 value:(Value*)v2
{
    if (v1.type==UNKNOWN || v2.type==UNKNOWN)
    {
        return [self unknown];
    }
    else if (v1.type==STRING || v2.type==STRING)
    {
        BOOL bResult = [[v1 convertToString] compare:[v2 convertToString]] <= 0;
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else if (v1.type==DOUBLE || v2.type==DOUBLE)
    {
        BOOL bResult = [v1 convertToDouble] <= [v2 convertToDouble];
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else if (v1.type==MONEY || v2.type==MONEY)
    {
        BOOL bResult = [v1 convertToDouble] <= [v2 convertToDouble];
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else if (v1.type==DATETIME || v2.type==DATETIME)
    {
        BOOL bResult = [v1 convertToLong] <= [v2 convertToLong];
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else if (v1.type==DATE || v2.type==DATE)
    {
        BOOL bResult = [v1 convertToLong] <= [v2 convertToLong];
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else if (v1.type==LONG || v2.type==LONG)
    {
        BOOL bResult = [v1 convertToLong] <= [v2 convertToLong];
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else if (v1.type==INTEGER || v2.type==INTEGER)
    {
        BOOL bResult = [v1 convertToInt] <= [v2 convertToInt];
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else if (v1.type==BOOLEAN || v2.type==BOOLEAN)
    {
        NSNumber* n1 = [NSNumber numberWithBool:[v1 convertToBool]];
        NSNumber* n2 = [NSNumber numberWithBool:[v2 convertToBool]];
        BOOL bResult = [n1 compare:n2] <= 0;
        NSValue *value = [NSValue value:&bResult withObjCType:@encode(BOOL)];
        return [[Value alloc] initWithDataType:BOOLEAN value:value];
    }
    else
    {
        return [Value unknown];
    }
}

+(Value*) valueAdd:(Value*)v1 value:(Value*)v2
{
    if (v1.type==UNKNOWN || v2.type==UNKNOWN)
    {
        return [self unknown];
    }
    else if (v1.type==STRING || v2.type==STRING)
    {
        NSString* sResult = [NSString stringWithFormat:@"%@%@",[v1 convertToString],[v1 convertToString]];
        NSValue* value = [NSValue value:&sResult withObjCType:@encode(NSString)];
        return [[Value alloc] initWithDataType:STRING value:value];
    }
    else if (v1.type==DOUBLE || v2.type==DOUBLE)
    {
        double dResult = [v1 convertToDouble] + [v2 convertToDouble];
        NSValue *value = [NSValue value:&dResult withObjCType:@encode(double)];
        return [[Value alloc] initWithDataType:DOUBLE value:value];
    }
    else if (v1.type==MONEY || v2.type==MONEY)
    {
        double dResult = [v1 convertToDouble] + [v2 convertToDouble];
        NSValue *value = [NSValue value:&dResult withObjCType:@encode(double)];
        return [[Value alloc] initWithDataType:MONEY value:value];
    }
    else if (v1.type==DATETIME || v2.type==DATETIME)
    {
        long long lResult = [v1 convertToLong] + [v2 convertToLong];
        NSValue *value = [NSValue value:&lResult withObjCType:@encode(long long)];
        return [[Value alloc] initWithDataType:DATETIME value:value];
    }
    else if (v1.type==DATE || v2.type==DATE)
    {
        long long lResult = [v1 convertToLong] + [v2 convertToLong];
        NSValue *value = [NSValue value:&lResult withObjCType:@encode(long long)];
        return [[Value alloc] initWithDataType:DATE value:value];
    }
    else if (v1.type==LONG || v2.type==LONG)
    {
        long long lResult = [v1 convertToLong] + [v2 convertToLong];
        NSValue *value = [NSValue value:&lResult withObjCType:@encode(long long)];
        return [[Value alloc] initWithDataType:LONG value:value];
    }
    else if (v1.type==INTEGER || v2.type==INTEGER)
    {
        int iResult = [v1 convertToInt] + [v2 convertToInt];
        NSValue *value = [NSValue value:&iResult withObjCType:@encode(int)];
        return [[Value alloc] initWithDataType:INTEGER value:value];
    }
    else if (v1.type==BOOLEAN || v2.type==BOOLEAN)
    {
        NSLog(@"Invalid operation \"add\" with BOOL type.");
        return nil;
    }
    else
    {
        return [Value unknown];
    }
}

+(Value*) valueSubtract:(Value*)v1 value:(Value*)v2
{
    if (v1.type==UNKNOWN || v2.type==UNKNOWN)
    {
        return [self unknown];
    }
    else if (v1.type==STRING || v2.type==STRING)
    {
        NSLog(@"Invalid operation \"subtract\" with STRING type.");
        return nil;
    }
    else if (v1.type==DOUBLE || v2.type==DOUBLE)
    {
        double dResult = [v1 convertToDouble] - [v2 convertToDouble];
        NSValue *value = [NSValue value:&dResult withObjCType:@encode(double)];
        return [[Value alloc] initWithDataType:DOUBLE value:value];
    }
    else if (v1.type==MONEY || v2.type==MONEY)
    {
        double dResult = [v1 convertToDouble] - [v2 convertToDouble];
        NSValue *value = [NSValue value:&dResult withObjCType:@encode(double)];
        return [[Value alloc] initWithDataType:MONEY value:value];
    }
    else if (v1.type==DATETIME || v2.type==DATETIME)
    {
        long long lResult = [v1 convertToLong] - [v2 convertToLong];
        NSValue *value = [NSValue value:&lResult withObjCType:@encode(long long)];
        return [[Value alloc] initWithDataType:DATETIME value:value];
    }
    else if (v1.type==DATE || v2.type==DATE)
    {
        long long lResult = [v1 convertToLong] - [v2 convertToLong];
        NSValue *value = [NSValue value:&lResult withObjCType:@encode(long long)];
        return [[Value alloc] initWithDataType:DATE value:value];
    }
    else if (v1.type==LONG || v2.type==LONG)
    {
        long long lResult = [v1 convertToLong] - [v2 convertToLong];
        NSValue *value = [NSValue value:&lResult withObjCType:@encode(long long)];
        return [[Value alloc] initWithDataType:LONG value:value];
    }
    else if (v1.type==INTEGER || v2.type==INTEGER)
    {
        int iResult = [v1 convertToInt] - [v2 convertToInt];
        NSValue *value = [NSValue value:&iResult withObjCType:@encode(int)];
        return [[Value alloc] initWithDataType:INTEGER value:value];
    }
    else if (v1.type==BOOLEAN || v2.type==BOOLEAN)
    {
        NSLog(@"Invalid operation \"subtract\" with BOOL type.");
        return nil;
    }
    else
    {
        return [Value unknown];
    }
}

+(Value*) valueMultiply:(Value*)v1 value:(Value*)v2
{
    if (v1.type==UNKNOWN || v2.type==UNKNOWN)
    {
        return [self unknown];
    }
    else if (v1.type==STRING || v2.type==STRING)
    {
        NSLog(@"Invalid operation \"multiply\" with STRING type.");
        return nil;
    }
    else if (v1.type==DOUBLE || v2.type==DOUBLE)
    {
        double dResult = [v1 convertToDouble] * [v2 convertToDouble];
        NSValue *value = [NSValue value:&dResult withObjCType:@encode(double)];
        return [[Value alloc] initWithDataType:DOUBLE value:value];
    }
    else if (v1.type==MONEY || v2.type==MONEY)
    {
        double dResult = [v1 convertToDouble] * [v2 convertToDouble];
        NSValue *value = [NSValue value:&dResult withObjCType:@encode(double)];
        return [[Value alloc] initWithDataType:MONEY value:value];
    }
    else if (v1.type==DATETIME || v2.type==DATETIME)
    {
        long long lResult = [v1 convertToLong] * [v2 convertToLong];
        NSValue *value = [NSValue value:&lResult withObjCType:@encode(long long)];
        return [[Value alloc] initWithDataType:DATETIME value:value];
    }
    else if (v1.type==DATE || v2.type==DATE)
    {
        long long lResult = [v1 convertToLong] * [v2 convertToLong];
        NSValue *value = [NSValue value:&lResult withObjCType:@encode(long long)];
        return [[Value alloc] initWithDataType:DATE value:value];
    }
    else if (v1.type==LONG || v2.type==LONG)
    {
        long long lResult = [v1 convertToLong] * [v2 convertToLong];
        NSValue *value = [NSValue value:&lResult withObjCType:@encode(long long)];
        return [[Value alloc] initWithDataType:LONG value:value];
    }
    else if (v1.type==INTEGER || v2.type==INTEGER)
    {
        int iResult = [v1 convertToInt] * [v2 convertToInt];
        NSValue *value = [NSValue value:&iResult withObjCType:@encode(int)];
        return [[Value alloc] initWithDataType:INTEGER value:value];
    }
    else if (v1.type==BOOLEAN || v2.type==BOOLEAN)
    {
        NSLog(@"Invalid operation \"multiply\" with BOOL type.");
        return nil;
    }
    else
    {
        return [Value unknown];
    }
}

+(Value*) valueDivide:(Value*)v1 value:(Value*)v2
{
    if (v1.type==UNKNOWN || v2.type==UNKNOWN)
    {
        return [self unknown];
    }
    else if (v1.type==STRING || v2.type==STRING)
    {
        NSLog(@"Invalid operation \"divide\" with STRING type.");
        return nil;
    }
    else if (v1.type==DOUBLE || v2.type==DOUBLE)
    {
        double dResult = [v1 convertToDouble] / [v2 convertToDouble];
        NSValue *value = [NSValue value:&dResult withObjCType:@encode(double)];
        return [[Value alloc] initWithDataType:DOUBLE value:value];
    }
    else if (v1.type==MONEY || v2.type==MONEY)
    {
        double dResult = [v1 convertToDouble] / [v2 convertToDouble];
        NSValue *value = [NSValue value:&dResult withObjCType:@encode(double)];
        return [[Value alloc] initWithDataType:MONEY value:value];
    }
    else if (v1.type==DATETIME || v2.type==DATETIME)
    {
        long long lResult = [v1 convertToLong] / [v2 convertToLong];
        NSValue *value = [NSValue value:&lResult withObjCType:@encode(long long)];
        return [[Value alloc] initWithDataType:DATETIME value:value];
    }
    else if (v1.type==DATE || v2.type==DATE)
    {
        long long lResult = [v1 convertToLong] / [v2 convertToLong];
        NSValue *value = [NSValue value:&lResult withObjCType:@encode(long long)];
        return [[Value alloc] initWithDataType:DATE value:value];
    }
    else if (v1.type==LONG || v2.type==LONG)
    {
        long long lResult = [v1 convertToLong] / [v2 convertToLong];
        NSValue *value = [NSValue value:&lResult withObjCType:@encode(long long)];
        return [[Value alloc] initWithDataType:LONG value:value];
    }
    else if (v1.type==INTEGER || v2.type==INTEGER)
    {
        int iResult = [v1 convertToInt] / [v2 convertToInt];
        NSValue *value = [NSValue value:&iResult withObjCType:@encode(int)];
        return [[Value alloc] initWithDataType:INTEGER value:value];
    }
    else if (v1.type==BOOLEAN || v2.type==BOOLEAN)
    {
        NSLog(@"Invalid operation \"divide\" with BOOL type.");
        return nil;
    }
    else
    {
        return [Value unknown];
    }
}

+(Value*) valueMinus:(Value*)v
{
    if (v.type==STRING)
    {
        NSLog(@"Invalid operation \"minus\" with STRING type.");
        return nil;
    }
    else if (v.type==DOUBLE)
    {
        double dResult = -[v convertToDouble];
        NSValue *value = [NSValue value:&dResult withObjCType:@encode(double)];
        return [[Value alloc] initWithDataType:DOUBLE value:value];
    }
    else if (v.type==MONEY)
    {
        double dResult = -[v convertToDouble];
        NSValue *value = [NSValue value:&dResult withObjCType:@encode(double)];
        return [[Value alloc] initWithDataType:DOUBLE value:value];
    }
    else if (v.type==DATETIME)
    {
        NSLog(@"Invalid operation \"minus\" with DATETIME type.");
        return nil;
    }
    else if (v.type==DATE)
    {
        NSLog(@"Invalid operation \"minus\" with DATE type.");
        return nil;
    }
    else if (v.type==LONG)
    {
        long long lResult = -[v convertToLong];
        NSValue *value = [NSValue value:&lResult withObjCType:@encode(long long)];
        return [[Value alloc] initWithDataType:LONG value:value];
    }
    else if (v.type==INTEGER)
    {
        int iResult = -[v convertToInt];
        NSValue *value = [NSValue value:&iResult withObjCType:@encode(int)];
        return [[Value alloc] initWithDataType:INTEGER value:value];
    }
    else if (v.type==BOOLEAN)
    {
        NSLog(@"Invalid operation \"divide\" with BOOL type.");
        return nil;
    }
    else
    {
        return [Value unknown];
    }
}

-(NSString*) description
{
    return [NSString stringWithFormat:@"<%@: %p, \"%@, %s\" >",
            [self class], self, getNameWithType(type), [value objCType]];
}

@end
