//
//  BankConnection.h
//  Chameleon
//
//  Created by Volchik on 28.11.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Request;
@class Answer;
@class Bank;
@class BSConnection;

@interface BankConnection : NSObject

-(instancetype) initWithBank:(Bank*) bank;
-(BSConnection*) getInfoConnection;
-(Answer*) runRequest:(Request*) request error:(NSError**) error;
@property (nonatomic,readonly) Bank* bank;
@end
