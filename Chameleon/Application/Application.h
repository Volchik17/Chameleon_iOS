//
//  Application.h
//  Chameleon
//
//  Created by Volchik on 28.11.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITaskHandler.h"

#define APP [Application getApplication]

@class BankList;
@class Request;
@class Answer;
@class BankConnection;
@class BSConnection;

@interface Application : NSObject
{
    @private
    NSMutableDictionary* connections;
    BSConnection* _bankCatalogConnection;
}

+(instancetype) getApplication;

@property (nonatomic,strong) BankList* banks;
@property (atomic,strong) NSString* currentBankId;
@property (nonatomic,readonly) NSString* bankCatalogURL;

-(BSConnection*) bankCatalogConnection;
-(BankConnection*) getConnectionForBankId:(NSString*) bankId;

-(id<ITaskHandler>) runRequest:(Request*) request forBank:(NSString*)bankId completionHandler:(void (^)(Answer* answer, NSError *error))completionHandler;

+(instancetype) new __attribute__((unavailable("new not available, call getApplication instead")));
+(instancetype) alloc __attribute__((unavailable("alloc not available, call getApplication instead")));
+(instancetype) init __attribute__((unavailable("init not available, call getApplication instead")));

@end
