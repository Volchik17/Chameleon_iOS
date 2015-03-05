//
//  ResourceRequest.h
//  Chameleon
//
//  Created by Volchik on 06.01.15.
//  Copyright (c) 2015 Volchik. All rights reserved.
//

#import "Request.h"

@interface ResourceRequest : Request<IRequest>

@property (nonatomic,strong) NSString* bankId;
@property (nonatomic,strong) NSString* moduleType;
@property (nonatomic,strong) NSString* moduleName;
@property (nonatomic,strong) NSString* resourceName;
@property (nonatomic,strong) NSString* savedHash;

-(instancetype) initWithBankId:(NSString*) bankId moduleType:(NSString*) moduleType moduleName:(NSString*) moduleName resourceName:(NSString*) resourceName savedHash:(NSString*) savedHash;

@end
