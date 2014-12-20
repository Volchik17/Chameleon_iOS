//
//  BSConnection.h
//  Chameleon
//
//  Created by Volchik on 07.12.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITaskHandler.h"
@class Request;
@class Answer;

@interface BSConnection : NSObject

@property (nonatomic) NSString* url;
@property (nonatomic,assign) NSTimeInterval defaultTimeout;
@property (readonly,nonatomic) NSURLSession* urlSession;

+(instancetype) plainConnectionToURL:(NSString*) url;

-(id<ITaskHandler>) runRequest:(Request*) request completionHandler:(void (^)(Answer* answer, NSError *error))completionHandler;

@end
