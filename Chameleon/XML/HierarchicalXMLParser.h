//
//  HierarchicalXMLParser.h
//  Chameleon
//
//  Created by Volchik on 09.12.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HierarchicalXMLParser;

@protocol HierarchicalXMLParserDelegate <NSObject>

@optional
- (void) didStartElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI
                qualifiedName:(NSString*)qualifiedName attributes:(NSDictionary*)attributeDict;
- (void) didEndElement:(NSString*)elementName
   namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName inlineCharacters:(NSString*) chars;
- (id<HierarchicalXMLParserDelegate>) didStartSubElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qualifiedName attributes:(NSDictionary*)attributeDict;
- (void) didEndSubElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName inlineCharacters:(NSString*) chars;
@end;

@protocol HierarchicalXMLParserErrorHandler <NSObject>

@required
- (void) parser:(HierarchicalXMLParser *)parser parseErrorOccurred:(NSError *)parseError;

@end;

@interface HierarchicalXMLParser : NSObject<NSXMLParserDelegate>
{
    NSMutableArray* parserStack;
    NSXMLParser* parser;
    int level;
}

@property (nonatomic,weak) id<HierarchicalXMLParserErrorHandler> errorHandler;
- (BOOL) parseWithData:(NSData*)data rootParser:(id<HierarchicalXMLParserDelegate>)rootParser;
- (void) abortParser;
@end
