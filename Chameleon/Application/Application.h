//
//  Application.h
//  Chameleon
//
//  Created by Volchik on 28.11.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import <Foundation/Foundation.h>

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

-(void) runRequest:request forBank:(NSString*)bankId onComplete:(void(*)(Answer*,NSError*))onComplete;
-(void) runRequest:request onComplete:(void(*)(Answer*,NSError*))onComplete;
-(Answer*) runImmediateRequest:(Request*)request error:(NSError**) error;
-(Answer*) runImmediateRequest:(Request*)request forBank:(NSString*)bankId error:(NSError**) error;

+(instancetype) new __attribute__((unavailable("new not available, call getApplication instead")));
+(instancetype) alloc __attribute__((unavailable("alloc not available, call getApplication instead")));
+(instancetype) init __attribute__((unavailable("init not available, call getApplication instead")));

@end
