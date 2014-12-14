//
//  Application.m
//  Chameleon
//
//  Created by Volchik on 28.11.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import "Application.h"
#import "BankList.h"
#import "Bank.h"
#import "BankConnection.h"
#import "BSConnection.h"

@implementation Application

-(instancetype) initUniqueInstance {
    self=[super init];
    if (self)
    {
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSString *configPlistPath = [path stringByAppendingPathComponent:@"config.plist"];
        NSDictionary *config = [NSDictionary dictionaryWithContentsOfFile:configPlistPath];
        _bankCatalogURL=[config objectForKey:@"BankCatalogURL"];
        self.banks = [[BankList alloc] init];
        connections=[[NSMutableDictionary alloc] initWithCapacity:self.banks.count];
        for (Bank* bank in self.banks)
        {
            BankConnection* connection=[[BankConnection alloc] initWithBank:bank];
            @synchronized(self)
            {
                [connections setObject:connection forKey:bank.bankId];
            }
        }
    }
    return self;
}

-(BSConnection*) bankCatalogConnection
{
    @synchronized(self) {
        if (!_bankCatalogConnection)
            _bankCatalogConnection=[BSConnection plainConnectionToURL:_bankCatalogURL];
    }
    return _bankCatalogConnection;
}

-(BankConnection*)getConnectionForBankId:(NSString*) bankId
{
    @synchronized(self) {
        return [connections objectForKey:bankId];
    }
}

-(Answer*) runImmediateRequest:(Request*)request error:(NSError**) error
{
    return [self runImmediateRequest:request forBank:self.currentBankId error:error];
}

-(Answer*) runImmediateRequest:(Request*)request forBank:(NSString*)bankId error:(NSError**) error
{
    BankConnection* connection=[self getConnectionForBankId:bankId];
    return [connection runRequest:request error:error];
}

-(void)runRequest:request forBank:(NSString*)bankId onComplete:(void(*)(Answer*,NSError*))onComplete
{
    Application *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError* error;
        Answer* answer=[weakSelf runImmediateRequest:request forBank:bankId error:&error];
        dispatch_async(dispatch_get_main_queue(), ^(){
            onComplete(answer,error);
        });
    });
}

-(void)runRequest:request onComplete:(void(*)(Answer*,NSError*))onComplete
{
    [self runRequest:request forBank:self.currentBankId onComplete:onComplete];
}

+(instancetype) getApplication
{
        static Application *application = nil;
        @synchronized(self) {
            if (application == nil)
                application = [[super alloc] initUniqueInstance];
        }
        return application;
}

@end
