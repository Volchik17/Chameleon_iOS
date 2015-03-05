//
//  BankCardDescription.m
//  Chameleon
//
//  Created by Volchik on 21.01.15.
//  Copyright (c) 2015 Volchik. All rights reserved.
//

#import "BankCardDescription.h"
#import "StringArrayParser.h"
#import "HierarchicalXMLParser.h"

@interface BankCardTitleParser:NSObject<HierarchicalXMLParserDelegate>
{
    BankCardDescription* _bankCard;
}
-(instancetype) initWithBankCard:(BankCardDescription*) bankCard;

@end

@implementation BankCardTitleParser

-(instancetype) initWithBankCard:(BankCardDescription*) bankCard
{
    self=[super init];
    if (self)
    {
        _bankCard=bankCard;
    }
    return self;
}

- (id<HierarchicalXMLParserDelegate>) didStartSubElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qualifiedName attributes:(NSDictionary*)attributeDict
{
    if ([elementName isEqualToString:@"caption"])
    {
        _bankCard.defaultTitleText=boolAttribute(attributeDict, @"default", false);
        _bankCard.titleText=[attributeDict objectForKey:@"text"];
    } else if ([elementName isEqualToString:@"color"])
    {
        _bankCard.titleColor=colorAttribute(attributeDict, @"value", _bankCard.titleColor);
    } else if ([elementName isEqualToString:@"image"])
    {
        _bankCard.titleImage=[attributeDict objectForKey:@"name"];
    }
    return nil;
}

@end

@implementation BankCardDescription

-(instancetype) init
{
    self=[super init];
    if (self)
    {
        _defaultTitleText=false;
        _titleColor=[UIColor colorWithRed:0x80/255. green:0x80/255. blue:0x80/255. alpha:1.];
        _authMethodNames=[[NSMutableArray alloc] init];
        _infoPanelNames=[[NSMutableArray alloc] init];
    }
    return self;
}

-(instancetype) initAsDefault
{
    self=[super init];
    if (self)
    {
        _defaultTitleText=true;
        _titleColor=[UIColor colorWithRed:0x80/255. green:0x80/255. blue:0x80/255. alpha:1.];
        _authMethodNames=[[NSMutableArray alloc] init];
        _infoPanelNames=[[NSMutableArray alloc] init];
    }
    return self;
}

- (id<HierarchicalXMLParserDelegate>) didStartSubElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qualifiedName attributes:(NSDictionary*)attributeDict
{
    if ([elementName isEqualToString:@"title"])
    {
        return [[BankCardTitleParser alloc] initWithBankCard:self];
    } else if ([elementName isEqualToString:@"authentication"])
    {
        return [[StringArrayParser alloc] initWithArray:_authMethodNames tagName:@"method" attributeName:@"id"];
    } else if ([elementName isEqualToString:@"infoPanels"])
    {
        return [[StringArrayParser alloc] initWithArray:_infoPanelNames tagName:@"panel" attributeName:@"id"];
    } else
        return nil;
}

@end
