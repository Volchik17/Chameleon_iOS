//
//  ResourceManager.m
//  Chameleon
//
//  Created by Volchik on 22.01.15.
//  Copyright (c) 2015 Volchik. All rights reserved.
//

#include <CommonCrypto/CommonDigest.h>

#import "ResourceManager.h"
#import "ResourceRequest.h"
#import "ResourceAnswer.h"
#import "Application.h"

@implementation ResourceManager

-(instancetype) init
{
    self=[super init];
    if (self)
    {
        NSString *storeURL = [[[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"resources"] path];
        NSError* error;
        [[NSFileManager defaultManager] createDirectoryAtPath:storeURL withIntermediateDirectories:YES attributes:nil error:&error];
        if (error)
            NSLog(@"Error creating resource cache directory \"%@\" with error: %@",storeURL,error);
    }
    return self;
}

#pragma mark - Application's Documents directory
// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(NSString*) getResourceFilePath:(NSString*) resourceId
{
    NSURL *storeURL = [[[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"resources"] URLByAppendingPathComponent:resourceId];
    return [storeURL path];
}

-(void) updateResource:(NSData*) data resourceId:(NSString*) resourceId
{
    NSString* fileName=[self getResourceFilePath:resourceId];
    NSError* error;
    [data writeToFile:fileName options:0 error:&error];
    if (error)
        NSLog(@"Error creating resource cache file \"%@\" with error : %@",fileName,error);
}

-(NSString*) calcHash:(NSData*) data
{
    unsigned char digest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(data.bytes, data.length, digest);
    NSData* hashData=[NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    return [hashData base64EncodedStringWithOptions:0];
}

-(id<ITaskHandler>) runResourceRequestForBankIndex:(NSUInteger) bankIndex moduleType:(NSString*) moduleType moduleName:(NSString*) moduleName resourceName:(NSString*) resourceName completionHandler:(void (^)(NSData* data, NSError *error))completionHandler
{
    NSString* resourceId = [[NSString stringWithFormat:@"%d.%@.%@.%@", bankIndex, moduleType, moduleName, resourceName] uppercaseString];
    NSData* data=nil;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString* fileName=[self getResourceFilePath:resourceId];
    if ([fileManager fileExistsAtPath:fileName])
        data=[NSData dataWithContentsOfFile:fileName];
    ResourceRequest* request;
    LocalBankInfo* bank=[APP getLocalBankByIndex:bankIndex];
    if (data)
        request=[[ResourceRequest alloc] initWithBankId:bank.bankId moduleType:moduleType moduleName:moduleName resourceName:resourceName savedHash:[self calcHash:data ]];
    else
        request=[[ResourceRequest alloc] initWithBankId:bank.bankId moduleType:moduleType moduleName:moduleName resourceName:resourceName savedHash:@""];
    __weak ResourceManager* weakSelf=self;
    return [APP runInfoRequest:request forBank:bankIndex completionHandler:^(Answer* answer, NSError *error)
            {
                if (answer)
                {
                    ResourceAnswer* ans=(ResourceAnswer*)answer;
                    if (ans.isUnchanged)
                        completionHandler(data,nil);
                    else
                    {
                        [weakSelf updateResource:data resourceId:resourceId];
                        completionHandler(ans.data,nil);
                    }
                } else
                    completionHandler(nil,error);
            }
            ];
    
}

-(NSData*) getLocalResourceForBankIndex:(NSUInteger) bankIndex moduleType:(NSString*) moduleType moduleName:(NSString*) moduleName resourceName:(NSString*) resourceName
{
    NSString* resourceId = [[NSString stringWithFormat:@"%d.%@.%@.%@", bankIndex, moduleType, moduleName, resourceName] uppercaseString];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString* fileName=[self getResourceFilePath:resourceId];
    if ([fileManager fileExistsAtPath:fileName])
        return [NSData dataWithContentsOfFile:fileName];
    else
        return nil;
}

@end
