//
//  SimpleRequest.h
//  Chameleon
//
//  Created by Volchik on 06.01.15.
//  Copyright (c) 2015 Volchik. All rights reserved.
//

#import "Request.h"

@interface SimpleRequest : Request
@property (nonatomic,strong) NSString* bankId;
@property (nonatomic,strong) NSString* moduleType;
@property (nonatomic,strong) NSString* moduleName;
@property (nonatomic,strong) NSString* requestName;
@property (nonatomic,readonly) Class answerClass;
-(instancetype) initWithWithBankId:(NSString*) bankId answerClass:(Class) answerClass moduleType:(NSString*) moduleType moduleName:(NSString*) moduleName requestName:(NSString*) requestName;
@end
