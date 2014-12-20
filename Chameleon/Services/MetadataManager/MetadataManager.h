//
//  MetadataManager.h
//  Chameleon
//
//  Created by Volchik on 17.12.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITaskHandler.h"
@class MetaStructure;

@interface MetadataManager : NSObject
{
    NSCache* cache;
}

-(id<ITaskHandler>) runMetadataRequestForClass:(Class) structureClasee bankId:bankId moduleType:(NSString*) moduleType moduleName:(NSString*) moduleName structureName:(NSString*) structureName langId:(NSString*) localeName completionHandler:(void (^)(MetaStructure* structure, NSError *error))completionHandler;

@end
