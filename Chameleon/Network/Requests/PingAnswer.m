//
//  PingAnswer.m
//  Chameleon
//
//  Created by Volchik on 15.12.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import "PingAnswer.h"

@implementation PingAnswer

-(instancetype)init
{
    self=[super init];
    if (self)
    {
        _banks=[[NSMutableArray alloc] init];
    }
    return self;
}

- (id<HierarchicalXMLParserDelegate>) didStartSubElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qualifiedName attributes:(NSDictionary*)attributeDict
{
    if( [elementName isEqualToString:@"Bank"])
    {
        NSString* bankId=[attributeDict objectForKey:@"id"];
        [_banks addObject:bankId];
        return nil;
    }
    else return nil;
}

@end
