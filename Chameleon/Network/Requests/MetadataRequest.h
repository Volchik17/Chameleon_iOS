//
//  MetadataRequest.h
//  Chameleon
//
//  Created by Volchik on 17.12.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import "Request.h"

@interface MetadataRequest : Request

@property (nonatomic,strong) NSString* bankId;
@property (nonatomic,strong) NSString* moduleType;
@property (nonatomic,strong) NSString* moduleName;
@property (nonatomic,strong) NSString* structureName;
@property (nonatomic,strong) NSString* savedHash;
@property (nonatomic,strong) NSString* localeName;

-(instancetype) initWithBankId:(NSString*) bankId moduleType:(NSString*) moduleType moduleName:(NSString*) moduleName structureName:(NSString*) structureName savedHash:(NSString*) savedHash localeName:(NSString*) localeName;

-(instancetype) initWithBankId:(NSString*) bankId moduleType:(NSString*) moduleType moduleName:(NSString*) moduleName structureName:(NSString*) structureName savedHash:(NSString*) savedHash;

@end
