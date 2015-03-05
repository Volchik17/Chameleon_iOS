//
//  HierarchicalXMLParser.m
//  Chameleon
//
//  Created by Volchik on 09.12.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import "HierarchicalXMLParser.h"

@interface ParserStackItem:NSObject
@property (nonatomic, strong) id<HierarchicalXMLParserDelegate> parserDelegate;
@property (nonatomic,strong) NSMutableString* currentChars;
-(instancetype) initWithDelegate:(id<HierarchicalXMLParserDelegate>) delegate;
@end

@implementation ParserStackItem

-(instancetype) initWithDelegate:(id<HierarchicalXMLParserDelegate>) delegate
{
    self=[super init];
    if (self)
    {
        _currentChars=[[NSMutableString alloc] init];
        _parserDelegate=delegate;
    }
    return self;
}

@end

@implementation HierarchicalXMLParser

- (id)init
{
    self = [super init];
    if (self)
    {
        parserStack = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) abortParser
{
    [parser abortParsing];
    [parserStack removeAllObjects];
}

- (BOOL) parseWithData:(NSData*)data rootParser:(id<HierarchicalXMLParserDelegate>)rootParser;
{
    [parserStack removeAllObjects];
    [parserStack addObject:[[ParserStackItem alloc] initWithDelegate:rootParser]];
    parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    BOOL result=[parser parse];
    [parserStack removeAllObjects];
    parser=nil;
    return result;
}

#pragma mark NSXMLParser Parsing Callbacks

- (void) parser:(NSXMLParser*)parser didStartElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI
  qualifiedName:(NSString*)qualifiedName attributes:(NSDictionary*)attributeDict
{
    if (level == 0)
    {
        ParserStackItem* item=[parserStack lastObject];
        if ([item.parserDelegate respondsToSelector:@selector(didStartElement:namespaceURI:qualifiedName:attributes:)])
            [item.parserDelegate didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qualifiedName attributes:attributeDict];
    }
    else
    {
        id<HierarchicalXMLParserDelegate> newParser=nil;
        ParserStackItem* item=[parserStack lastObject];
        if (item.parserDelegate)
        {
            if ([item.parserDelegate respondsToSelector:@selector(didStartSubElement:namespaceURI:qualifiedName:attributes:)])
                newParser = [item.parserDelegate didStartSubElement:elementName namespaceURI:namespaceURI qualifiedName:qualifiedName attributes:attributeDict];
            else
                newParser = nil;
            if (newParser && [newParser respondsToSelector:@selector(didStartElement:namespaceURI:qualifiedName:attributes:)])
            {
                [newParser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qualifiedName attributes:attributeDict];
            }
        }
        [parserStack addObject:[[ParserStackItem alloc] initWithDelegate:newParser]];
    }
    ++level;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    ParserStackItem* item=[parserStack lastObject];
    NSString* chars=item.currentChars;
    if(item.parserDelegate && [item.parserDelegate respondsToSelector:@selector(didEndElement:namespaceURI:qualifiedName:inlineCharacters:)])
        [item.parserDelegate didEndElement:elementName namespaceURI:namespaceURI qualifiedName:qName inlineCharacters:chars];
    [parserStack removeLastObject];
    if (level>0)
    {
        --level;
        item=[parserStack lastObject];
        if (item.parserDelegate && [item.parserDelegate respondsToSelector:@selector(didEndSubElement:namespaceURI:qualifiedName:inlineCharacters:)])
            [item.parserDelegate didEndSubElement:elementName namespaceURI:namespaceURI qualifiedName:qName inlineCharacters:chars];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    ParserStackItem* item=[parserStack lastObject];
    [item.currentChars appendString:string];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    if (self.errorHandler)
        [self.errorHandler parser:self parseErrorOccurred:parseError];
}

@end

BOOL boolAttribute(NSDictionary* attributes, NSString* attributeName, BOOL defaultValue)
{
    NSString* value=[attributes objectForKey:attributeName];
    if (!value)
        return defaultValue;
    return [[value uppercaseString] isEqualToString:@"TRUE"] || [value isEqualToString:@"1"];
}

UIColor* colorAttribute(NSDictionary* attributes, NSString* attributeName, UIColor* defaultValue)
{
    NSString* value=[attributes objectForKey:attributeName];
    if (!value)
        return defaultValue;
    NSScanner* scanner = [NSScanner scannerWithString:value];
    unsigned outVal;
    if (![scanner scanHexInt:&outVal])
        return defaultValue;
    Byte alpha=outVal>>24;
    Byte red=(outVal & 0xFF0000)>>16;
    Byte green=(outVal & 0x00FF00)>>8;
    Byte blue=(outVal & 0x0000FF);
    CGFloat a=1-(CGFloat)alpha / 255.;
    CGFloat r=(CGFloat)red / 255.;
    CGFloat g=(CGFloat)green / 255.;
    CGFloat b=(CGFloat)blue / 255.;
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}
