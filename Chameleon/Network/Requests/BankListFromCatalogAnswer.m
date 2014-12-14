//
//  BankListFromCatalogAnswer.m
//  Chameleon
//
//  Created by Volchik on 09.12.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import "BankListFromCatalogAnswer.h"
#import "CatalogBankInfo.h"

@implementation BankListFromCatalogAnswer

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
    if( [elementName isEqualToString:@"bank"])
    {
        CatalogBankInfo* bank=[[CatalogBankInfo alloc] init];
        [_banks addObject:bank];
        return bank;
    }
    else return nil;
}

@end
