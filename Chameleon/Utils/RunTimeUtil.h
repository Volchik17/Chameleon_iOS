//
//  RunTimeUtil.h
//  mBSClient
//
//  Created by Maksim Voronin on 22.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "objc/runtime.h"

@interface RunTimeUtil : NSObject
+ (NSArray *)propertyNamesWithClass:(Class)clss;
+ (Class)propertyClassWithName:(NSString*)propertyName class:(Class)clss;
+ (BOOL) currentClass:(Class)clss1 isKindOfClass:(Class)clss2;
+ (Method) methodWithName:(NSString*)name class:(Class)clss;
@end
