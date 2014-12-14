//
//  CatalogBankInfo.m
//  Chameleon
//
//  Created by Volchik on 09.12.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import "CatalogBankInfo.h"

@implementation CatalogBankInfo

- (void) didStartElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI
           qualifiedName:(NSString*)qualifiedName attributes:(NSDictionary*)attributeDict;
{
    _catalogBankId=[attributeDict objectForKey:@"id"];
    _name=[attributeDict objectForKey:@"name"];
    _bankId=[attributeDict objectForKey:@"bankId"];
    _url=[attributeDict objectForKey:@"url"];
}

@end
