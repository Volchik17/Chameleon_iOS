//
//  Request.h
//  Chameleon
//
//  Created by Volchik on 28.11.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSConnection.h"

@interface Request : NSObject

-(NSURLRequest*) urlRequestForConnection:(BSConnection*) connection;
-(Class) getAnswerClass;
-(NSString*) concatURL:(NSString*)baseURL withTail:(NSString*)tailURL;

@end
