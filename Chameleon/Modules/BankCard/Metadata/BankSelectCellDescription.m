//
//  BankSelectCellDescription.m
//  Chameleon
//
//  Created by Volchik on 05.01.15.
//  Copyright (c) 2015 Volchik. All rights reserved.
//

#import "BankSelectCellDescription.h"

@implementation BankSelectCellDescription

-(instancetype) init
{
    self=[super init];
    if (self)
    {
        _view=[[ViewStructure alloc] init];
    }
    return self;
}

- (id<HierarchicalXMLParserDelegate>) didStartSubElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qualifiedName attributes:(NSDictionary*)attributeDict
{
    if ([elementName isEqualToString:@"image"])
    {
        self.image=[attributeDict objectForKey:@"source"];
        return nil;
    } else if ([elementName isEqualToString:@"view"])
    {
        return self.view;
    } else
        return nil;
}

@end
