//
//  BankImageFromCatalogRequest.h
//  Chameleon
//
//  Created by Volchik on 10.12.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import "Request.h"

@interface BankImageFromCatalogRequest : Request<IRequest>

@property (nonatomic,strong) NSString* catalogBankId;

-(instancetype) initWithId:(NSString*) catalogBankId;

@end
