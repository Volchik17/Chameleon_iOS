//
//  Request.m
//  Chameleon
//
//  Created by Volchik on 28.11.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import "Request.h"

@implementation Request

-(NSString*) concatURL:(NSString*)baseURL withTail:(NSString*)tailURL
{
    if ([baseURL hasSuffix:@"/"] || [baseURL hasSuffix:@"\\"])
        return [NSString stringWithFormat:@"%@%@",baseURL,tailURL];
    else
        return  [NSString stringWithFormat:@"%@/%@",baseURL,tailURL];
}

@end
