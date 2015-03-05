//
//  Request.h
//  Chameleon
//
//  Created by Volchik on 28.11.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BSConnection;

@protocol IRequest <NSObject>

@required

-(NSURLRequest*) urlRequestForConnection:(BSConnection*) connection;
-(Class) getAnswerClass;

@optional

@property (nonatomic,strong) NSString* bankId;

@end

@interface Request : NSObject

-(NSString*) concatURL:(NSString*)baseURL withTail:(NSString*)tailURL;

@end
