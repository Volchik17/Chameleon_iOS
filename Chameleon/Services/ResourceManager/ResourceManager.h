//
//  ResourceManager.h
//  Chameleon
//
//  Created by Volchik on 22.01.15.
//  Copyright (c) 2015 Volchik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITaskHandler.h"

@interface ResourceManager : NSObject

-(id<ITaskHandler>) runResourceRequestForBankIndex:(NSUInteger) bankIndex moduleType:(NSString*) moduleType moduleName:(NSString*) moduleName resourceName:(NSString*) resourceName completionHandler:(void (^)(NSData* data, NSError *error))completionHandler;

-(NSData*) getLocalResourceForBankIndex:(NSUInteger) bankIndex moduleType:(NSString*) moduleType moduleName:(NSString*) moduleName resourceName:(NSString*) resourceName;

@end
