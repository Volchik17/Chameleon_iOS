//
//  XMLRequest.h
//  Chameleon
//
//  Created by Volchik on 08.12.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import "Request.h"

@interface XMLRequest : Request

-(NSURLRequest*) urlRequestForConnection:(BSConnection*) connection;

@end
