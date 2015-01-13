//
//  MetaStructure.h
//  Chameleon
//
//  Created by Volchik on 17.12.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HierarchicalXMLParser.h"

@interface MetaStructure : NSObject<HierarchicalXMLParserDelegate,HierarchicalXMLParserErrorHandler>
{
    NSError* lastError;
}
@property (nonatomic,strong) NSString* moduleType;
@property (nonatomic,strong) NSString* structureDescription;
@property (nonatomic,assign) int structureVersion;


-(NSError*) parseFromData:(NSData*) data;
+(NSString*) getStructureType;

- (void) didStartElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI
           qualifiedName:(NSString*)qualifiedName attributes:(NSDictionary*)attributeDict NS_REQUIRES_SUPER;
@end
