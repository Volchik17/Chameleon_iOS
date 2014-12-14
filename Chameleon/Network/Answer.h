//
//  Answer.h
//  Chameleon
//
//  Created by Volchik on 28.11.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Answer : NSObject

-(NSError*) parseResponse:(NSURLResponse*) response withData:(NSData*) data;

@end
