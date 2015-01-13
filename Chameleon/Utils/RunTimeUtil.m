//
//  RunTimeUtil.m
//  mBSClient
//
//  Created by Maksim Voronin on 22.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "RunTimeUtil.h"
#import <objc/message.h>
#import "objc/runtime.h"

@implementation RunTimeUtil

+ (NSArray *)propertyNamesWithClass:(Class)clss
{
    unsigned count;
    objc_property_t *properties = class_copyPropertyList(clss, &count);
    
    NSMutableArray *rv = [NSMutableArray array];
    
    unsigned i;
    for (i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        [rv addObject:name];
    }
    
    free(properties);
    
    return rv;
}

+ (Class)propertyClassWithName:(NSString*)propertyName class:(Class)clss
{
    objc_property_t property = class_getProperty(clss, [propertyName UTF8String]);
    const char *type = property_getAttributes(property);
    NSArray  * attributes = [[NSString stringWithUTF8String:type] componentsSeparatedByString:@","];
    NSString * typeAttribute = [attributes objectAtIndex:0];
    if ([typeAttribute hasPrefix:@"T@"] && [typeAttribute length] > 1)
    {
        NSString * typeClassName = [typeAttribute substringWithRange:NSMakeRange(3, [typeAttribute length]-4)];
        return NSClassFromString(typeClassName);

    }
    return nil;
}

+ (BOOL) currentClass:(Class)clss1 isKindOfClass:(Class)clss2
{
    Class c = clss1;
    do
    {
        if (c == clss2) return YES;
        c = [c superclass];
    } while (c);
    
    return NO;
}

+(Method) methodWithName:(NSString*)name class:(Class)clss
{
    Method result=nil;
    unsigned int count = 0;
    
    Method* methods = class_copyMethodList(clss, &count);
    for (unsigned int i=0; i < count; i++)
    {
        Method method = methods[i];
        NSString* methodName = [[NSStringFromSelector(method_getName(method)) componentsSeparatedByString:@":"] objectAtIndex:0];
        if ([name isEqualToString:methodName])
        {
            result = method;
        }
    }
    free(methods);
    
    return result;
}

@end
