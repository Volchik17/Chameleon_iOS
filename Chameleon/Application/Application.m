//
//  Application.m
//  Chameleon
//
//  Created by Volchik on 28.11.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import "Application.h"
#import "Bank.h"
#import "BankConnection.h"
#import "BSConnection.h"
#import "Request.h"
#import "LocalBankInfoList.h"
#import "MetadataManager.h"
#import "ResourceManager.h"


@implementation Application

-(NSMutableArray*) loadLocalBanks
{
    @try {
        NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
        NSData *dataRepresentingSavedArray = [currentDefaults objectForKey:@"banks"];
        if (dataRepresentingSavedArray != nil)
        {
            NSArray *oldSavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
            if (oldSavedArray != nil)
                return [[NSMutableArray alloc] initWithArray:oldSavedArray];
        }
    } @catch (NSException* exception) {
        NSLog(@"Error loading local bank list : %@",exception);
    }
    return [[NSMutableArray alloc] init];
}

-(void) saveLocalBanks
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:[self getLocalBanks] ] forKey:@"banks"];
    [defaults synchronize];
}

-(instancetype) initUniqueInstance {
    self=[super init];
    if (self)
    {
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSString *configPlistPath = [path stringByAppendingPathComponent:@"config.plist"];
        NSDictionary *config = [NSDictionary dictionaryWithContentsOfFile:configPlistPath];
        _metadataManager=[[MetadataManager alloc] init];
        _resourceManager=[[ResourceManager alloc] init];
        _rootController=[[RootChameleonViewController alloc] init];
        _bankCatalogURL=[config objectForKey:@"BankCatalogURL"];
        NSMutableArray* bankList=[self loadLocalBanks];
        _banks = [[NSMutableDictionary alloc] initWithCapacity:bankList.count];
        for (LocalBankInfo* localBank in bankList)
        {
            Bank* bank=[[Bank alloc] initWithLocalBankInfo:localBank];
            [_banks setObject:bank forKey:@(localBank.bankIndex)];
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

-(Bank*) getBankByIndex:(NSUInteger) bankIndex
{
    @synchronized(self) {
        return [_banks objectForKey:@(bankIndex)];
    }
}

-(NSArray*) getLocalBanks
{
    NSMutableArray* list=[[NSMutableArray alloc] init];
    @synchronized(self)
    {
        for (Bank* bank in _banks.allValues)
        {
            LocalBankInfo* localBank=[[LocalBankInfo alloc] init];
            [bank fillLocalBankInfo:localBank];
            [list addObject:localBank];
        }
    }
    return list;
}

-(LocalBankInfo*) getLocalBankByIndex:(NSUInteger) bankIndex
{
    Bank* bank=[self getBankByIndex:bankIndex];
    if (!bank)
        return nil;
    LocalBankInfo* localBankInfo=[[LocalBankInfo alloc]init];
    [bank fillLocalBankInfo:localBankInfo];
    return localBankInfo;
}

-(NSInteger) generateLocalBankIndex
{
    NSInteger i=1;
    @synchronized(self)
    {
        for (Bank* bank in _banks.allValues)
            if (bank.bankIndex>=i)
                i=bank.bankIndex+1;
    }
    return i;
}

-(void) deleteLocalBank:(NSUInteger) bankIndex
{
    @synchronized(self)
    {
        [_banks removeObjectForKey:@(bankIndex)];
        [self saveLocalBanks];
    }
}

-(NSUInteger) addLocalBankWithUrl:(NSString*)url bankId:(NSString*) bankId bankCard:(BankCard*) bankCard
{
    NSUInteger bankIndex;
    @synchronized(self)
    {
        for (Bank* bank in _banks.allValues)
        {
            if ([bank.bankId isEqualToString:bankId] && [[bank.url uppercaseString] isEqualToString:[url uppercaseString]])
                return bank.bankIndex;
        }
        bankIndex=self.generateLocalBankIndex;
        Bank* bank=[[Bank alloc] initWithBankIndex:bankIndex bankId:bankId url:url bankCard:bankCard];
        [_banks setObject:bank forKey:@(bankIndex)];
    }
    [self saveLocalBanks];
    return bankIndex;
}

-(void) updateLocalBankUrl:(NSUInteger) bankIndex url:(NSString*) url
{
    @synchronized(self)
    {
        Bank* bank=[self getBankByIndex:bankIndex];
        if (!bank)
            return;
        bank.url=url;
    }
    [self saveLocalBanks];
}

-(BSConnection*) getConnectionForBank:(NSInteger) bankIndex
{
    Bank* bank=[self getBankByIndex:bankIndex];
    return [bank getConnection];
}

-(BSConnection*) getInfoConnectionForBank:(NSInteger) bankIndex
{
    Bank* bank=[self getBankByIndex:bankIndex];
    return [bank getInfoConnection];
}

-(id<ITaskHandler>) runRequest:(id<IRequest>) request forBank:(NSInteger)bankIndex completionHandler:(void (^)(Answer* answer, NSError *error))completionHandler
{
    Bank* bank=[self getBankByIndex:bankIndex];
    if ([request respondsToSelector:@selector(setBankId:)])
        [request setBankId:bank.bankId];
    BSConnection* connection=[bank getConnection];
    return [connection runRequest:request completionHandler:completionHandler];
}

-(id<ITaskHandler>) runInfoRequest:(id<IRequest>) request forBank:(NSInteger)bankIndex completionHandler:(void (^)(Answer* answer, NSError *error))completionHandler
{
    Bank* bank=[self getBankByIndex:bankIndex];
    if ([request respondsToSelector:@selector(setBankId:)])
        [request setBankId:bank.bankId];
    BSConnection* connection=[bank getInfoConnection];
    return [connection runRequest:request completionHandler:completionHandler];
}

-(NSString*) currentLanguageId
{
    NSString* locale=[[NSLocale currentLocale] localeIdentifier];
    return [[NSLocale componentsFromLocaleIdentifier:locale] objectForKey:NSLocaleLanguageCode];
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
