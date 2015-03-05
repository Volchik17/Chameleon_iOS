//
//  BSConnection.h
//  Chameleon
//
//  Created by Volchik on 07.12.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITaskHandler.h"
#import "Request.h"
#import "Answer.h"

@protocol IRequest;

@interface BSConnection : NSObject

@property (nonatomic) NSString* url;
@property (nonatomic,assign) NSTimeInterval defaultTimeout;
@property (readonly,nonatomic) NSURLSession* urlSession;

+(instancetype) plainConnectionToURL:(NSString*) url;

-(id<ITaskHandler>) runRequest:(id<IRequest>) request completionHandler:(void (^)(Answer* answer, NSError *error))completionHandler;

@end
