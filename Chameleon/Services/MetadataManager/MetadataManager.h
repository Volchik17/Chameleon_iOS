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

-(id<ITaskHandler>) runMetadataRequestForClass:(Class) structureClass bankIndex:(NSInteger)bankIndex moduleType:(NSString*) moduleType moduleName:(NSString*) moduleName structureName:(NSString*) structureName langId:(NSString*) langId completionHandler:(void (^)(MetaStructure* structure, NSError *error))completionHandler;

-(id<ITaskHandler>) runMetadataRequestForClass:(Class) structureClass bankIndex:(NSInteger)bankIndex moduleType:(NSString*) moduleType moduleName:(NSString*) moduleName structureName:(NSString*) structureName completionHandler:(void (^)(MetaStructure* structure, NSError *error))completionHandler;

-(MetaStructure*) getLocalMetadataForClass:(Class) structureClass bankIndex:(NSInteger)bankIndex moduleType:(NSString*) moduleType moduleName:(NSString*) moduleName structureName:(NSString*) structureName;

-(MetaStructure*) getLocalMetadataForClass:(Class) structureClass bankIndex:(NSInteger)bankIndex moduleType:(NSString*) moduleType moduleName:(NSString*) moduleName structureName:(NSString*) structureName langId:(NSString*) langId;

@end
