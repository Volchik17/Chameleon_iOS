//
//  MetadataManager.m
//  Chameleon
//
//  Created by Volchik on 17.12.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#include <CommonCrypto/CommonDigest.h>

#import "MetadataManager.h"
#import "MetaStructure.h"
#import "ITaskHandler.h"
#import "MetadataRequest.h"
#import "MetadataAnswer.h"
#import "Application.h"

@interface MetadataItem:NSObject
    @property (nonatomic,strong) MetaStructure* structure;
    @property (nonatomic,strong) NSString* savedHash;
    @property (nonatomic,assign) long long size;
@end

@implementation MetadataItem

@end

@implementation MetadataManager

-(instancetype) init
{
    self=[super init];
    if (self)
    {
        NSString *storeURL = [[[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"metadata"] path];
        NSError* error;
        [[NSFileManager defaultManager] createDirectoryAtPath:storeURL withIntermediateDirectories:YES attributes:nil error:&error];
        if (error)
            NSLog(@"Error creating metadata cache directory \"%@\" with error: %@",storeURL,error);
    }
    return self;
}

#pragma mark - Application's Documents directory
// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(NSString*) calcHash:(NSData*) data
{
    unsigned char digest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(data.bytes, data.length, digest);
    NSData* hashData=[NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    return [hashData base64EncodedStringWithOptions:0];
}

-(NSString*) getMetadataFilePath:(NSString*) resourceId
{
    NSURL *storeURL = [[[[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"metadata"] URLByAppendingPathComponent:resourceId]URLByAppendingPathExtension:@"xml"];
    return [storeURL path];
}

-(MetadataItem*)  updateCacheWithStructure:(MetaStructure*) structure data:(NSData*) data resourceId:(NSString*) resourceId
{
    NSString* hash=[self calcHash:data];
    MetadataItem* item=[[MetadataItem alloc] init];
    item.structure=structure;
    item.savedHash=hash;
    item.size=data.length;
    @synchronized(self) {
        [cache setObject:item forKey:resourceId];
    }
    return item;
}

-(MetadataItem*) updateStructure:(MetaStructure*) structure data:(NSData*) data resourceId:(NSString*) resourceId
{
    MetadataItem* item=[self updateCacheWithStructure:structure data:data resourceId:resourceId];
    NSString* fileName=[self getMetadataFilePath:resourceId];
    NSError* error;
    [data writeToFile:fileName options:0 error:&error];
    if (error)
        NSLog(@"Error creating metadata cache file \"%@\" with error : %@",fileName,error);
    return item;
}

-(id<ITaskHandler>) runMetadataRequestForClass:(Class) structureClass bankIndex:(NSInteger)bankIndex moduleType:(NSString*) moduleType moduleName:(NSString*) moduleName structureName:(NSString*) structureName langId:(NSString*) langId completionHandler:(void (^)(MetaStructure* structure, NSError *error))completionHandler
{
    NSString* resourceId = [[NSString stringWithFormat:@"%d.%@.%@.%@.%@", bankIndex, moduleType, moduleName, structureName, langId] uppercaseString];
    
    MetadataItem* structure=nil;
    @synchronized(self) {
        structure=[cache objectForKey:resourceId];
    }
    if (!structure)
    {
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        NSString* fileName=[self getMetadataFilePath:resourceId];
        if ([fileManager fileExistsAtPath:fileName])
        {
            NSData* data=[NSData dataWithContentsOfFile:fileName];
            MetaStructure* newStructure=[[structureClass alloc] init];
            NSError* error=[newStructure parseFromData:data];
            if (!error)
            {
                structure=[self updateStructure:newStructure data:data resourceId:resourceId];
            }
            
        }
    }
    MetadataRequest* request;
    LocalBankInfo* bank=[APP getLocalBankByIndex:bankIndex];
    if (structure)
        request=[[MetadataRequest alloc] initWithBankId:bank.bankId moduleType:moduleType moduleName:moduleName structureName:structureName savedHash:structure.savedHash localeId:langId];
    else
        request=[[MetadataRequest alloc] initWithBankId:bank.bankId moduleType:moduleType moduleName:moduleName structureName:structureName savedHash:@"" localeId:langId];
    __weak MetadataManager* weakSelf=self;
    return [APP runInfoRequest:request forBank:bankIndex completionHandler:^(Answer* answer, NSError *error)
        {
            if (answer)
            {
                MetadataAnswer* ans=(MetadataAnswer*)answer;
                if (ans.isUnchanged)
                    completionHandler(structure.structure,nil);
                else
                {
                    MetaStructure* newStructure=[[structureClass alloc] init];
                    error=[newStructure parseFromData:ans.data];
                    if(error)
                    {
                        completionHandler(nil,error);
                        return;
                    }
                    [weakSelf updateStructure:newStructure data:ans.data resourceId:resourceId];
                    completionHandler(newStructure,nil);
                }
            } else
                completionHandler(nil,error);
        }
    ];
}

-(id<ITaskHandler>) runMetadataRequestForClass:(Class) structureClass bankIndex:(NSInteger)bankIndex moduleType:(NSString*) moduleType moduleName:(NSString*) moduleName structureName:(NSString*) structureName completionHandler:(void (^)(MetaStructure* structure, NSError *error))completionHandler
{
    return [self runMetadataRequestForClass:structureClass bankIndex:bankIndex moduleType:moduleType moduleName:moduleName structureName:structureName langId:@"" completionHandler:completionHandler];
}

-(MetaStructure*) getLocalMetadataForClass:(Class) structureClass bankIndex:(NSInteger)bankIndex moduleType:(NSString*) moduleType moduleName:(NSString*) moduleName structureName:(NSString*) structureName langId:(NSString*) langId
{
    NSString* resourceId = [[NSString stringWithFormat:@"%d.%@.%@.%@.%@", bankIndex, moduleType, moduleName, structureName, langId] uppercaseString];
    
    MetadataItem* structure=nil;
    @synchronized(self) {
        structure=[cache objectForKey:resourceId];
    }
    if (structure)
        return structure.structure;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString* fileName=[self getMetadataFilePath:resourceId];
    if ([fileManager fileExistsAtPath:fileName])
    {
        NSData* data=[NSData dataWithContentsOfFile:fileName];
        MetaStructure* newStructure=[[structureClass alloc] init];
        NSError* error=[newStructure parseFromData:data];
        if (!error)
        {
            [self updateCacheWithStructure:newStructure data:data resourceId:resourceId];
            return newStructure;
        }
    }
    return nil;
}

-(MetaStructure*) getLocalMetadataForClass:(Class) structureClass bankIndex:(NSInteger)bankIndex moduleType:(NSString*) moduleType moduleName:(NSString*) moduleName structureName:(NSString*) structureName
{
    return [self getLocalMetadataForClass:structureClass bankIndex:bankIndex moduleType:moduleType moduleName:moduleName structureName:structureName langId:@""];
}

@end
