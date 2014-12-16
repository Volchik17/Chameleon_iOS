//
//  BSConnection.m
//  Chameleon
//
//  Created by Volchik on 07.12.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import "BSConnection.h"
#import "Request.h"
#import "Answer.h"
#import <objc/message.h>

@implementation BSConnection

-(instancetype) initWithURL:(NSString*) url
{
    self=[super init];
    if (self)
    {
        self.url=url;
        NSURLSessionConfiguration* sessionConfig=[NSURLSessionConfiguration defaultSessionConfiguration];
        _urlSession=[NSURLSession sessionWithConfiguration:sessionConfig];
        _defaultTimeout=30;
    }
    return self;
}

+(instancetype) plainConnectionToURL:(NSString*) url
{
    BSConnection* connection=[[BSConnection alloc] initWithURL:url];
    return connection;
}

-(NSURLSessionTask*) runRequest:(Request*) request completionHandler:(void (^)(Answer* answer, NSError *error))completionHandler
{
    NSURLRequest* urlRequest=[request urlRequestForConnection:self];
    NSURLSessionDataTask *dataTask = [self.urlSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        if(error)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(nil,error);
            });

        }
        else
        {
            Class answerClass=[request getAnswerClass];
            Answer* answer=[[answerClass alloc] init];
            error=[answer parseResponse:response withData:data];
            if (error)
                answer=nil;
            dispatch_async(dispatch_get_main_queue(), ^{
                    completionHandler(answer,error);
                });
        }
    } ];
    [dataTask resume];
    return dataTask;
}

@end
