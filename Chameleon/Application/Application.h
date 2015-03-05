//
//  Application.h
//  Chameleon
//
//  Created by Volchik on 28.11.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITaskHandler.h"
#import "RootChameleonViewController.h"
#import "Request.h"

#define APP [Application getApplication]

@class BankList;
@class Answer;
@class BankConnection;
@class BSConnection;
@class LocalBankInfoList;
@class MetadataManager;
@class ResourceManager;

@interface Application : NSObject
{
    @private
    NSMutableDictionary* _banks;
    BSConnection* _bankCatalogConnection;
}

+(instancetype) getApplication;

@property (atomic,assign) NSInteger currentBankIndex;
@property (nonatomic,readonly) NSString* bankCatalogURL;
@property (nonatomic,readonly) RootChameleonViewController* rootController;
@property (nonatomic,readonly) MetadataManager* metadataManager;
@property (nonatomic,readonly) ResourceManager* resourceManager;

-(NSArray*) getLocalBanks;
-(LocalBankInfo*) getLocalBankByIndex:(NSUInteger) bankIndex;

-(void) deleteLocalBank:(NSUInteger) bankIndex;
-(NSUInteger) addLocalBankWithUrl:(NSString*)url bankId:(NSString*) bankId bankCard:(BankCard*) bankCard;
-(void) updateLocalBankUrl:(NSUInteger) bankIndex url:(NSString*) url;

-(BSConnection*) bankCatalogConnection;
-(BSConnection*) getConnectionForBank:(NSInteger) bankIndex;
-(BSConnection*) getInfoConnectionForBank:(NSInteger) bankIndex;

-(id<ITaskHandler>) runRequest:(id<IRequest>) request forBank:(NSInteger)bankIndex completionHandler:(void (^)(Answer* answer, NSError *error))completionHandler;

-(id<ITaskHandler>) runInfoRequest:(id<IRequest>) request forBank:(NSInteger)bankIndex completionHandler:(void (^)(Answer* answer, NSError *error))completionHandler;

-(NSString*) currentLanguageId;



+(instancetype) new __attribute__((unavailable("new not available, call getApplication instead")));
+(instancetype) alloc __attribute__((unavailable("alloc not available, call getApplication instead")));
+(instancetype) init __attribute__((unavailable("init not available, call getApplication instead")));

@end
