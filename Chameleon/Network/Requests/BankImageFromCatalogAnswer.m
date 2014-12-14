//
//  BankImageFromCatalogAnswer.m
//  Chameleon
//
//  Created by Volchik on 10.12.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import "BankImageFromCatalogAnswer.h"
#import <UIKit/UIKit.h>

@implementation BankImageFromCatalogAnswer

-(NSError*) parseResponse:(NSURLResponse*) response withData:(NSData*) data
{
    NSHTTPURLResponse* r=(NSHTTPURLResponse*)response;
    if (r.statusCode==404)
        return [NSError errorWithDomain:@"BankCatalogRequest" code:404 userInfo:nil];
    _imageData=data;
    return nil;
}

@end
