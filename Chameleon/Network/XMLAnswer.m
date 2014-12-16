//
//  XMLAnswer.m
//  Chameleon
//
//  Created by Volchik on 09.12.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import "XMLAnswer.h"

@implementation XMLAnswer

- (void) parser:(HierarchicalXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    lastError=parseError;
}

-(NSError*) parseResponse:(NSURLResponse*) response withData:(NSData*) data
{
    lastError=nil;
    HierarchicalXMLParser* parser=[[HierarchicalXMLParser alloc] init];
    __weak XMLAnswer* weakself=self;
    parser.errorHandler=weakself;
    NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    [parser parseWithData:data rootParser:weakself];
    return lastError;
}

@end
