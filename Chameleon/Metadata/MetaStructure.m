//
//  MetaStructure.m
//  Chameleon
//
//  Created by Volchik on 17.12.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import "MetaStructure.h"

@implementation MetaStructure

- (void) parser:(HierarchicalXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    lastError=parseError;
}

-(NSError*) parseFromData:(NSData*) data
{
    lastError=nil;
    HierarchicalXMLParser* parser=[[HierarchicalXMLParser alloc] init];
    __weak MetaStructure* weakself=self;
    parser.errorHandler=weakself;
    [parser parseWithData:data rootParser:weakself];
    return lastError;
}

+(NSString*) getStructureType
{
    NSAssert(false,@"Abstract error");
    return @"";
}

- (void) didStartElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI
           qualifiedName:(NSString*)qualifiedName attributes:(NSDictionary*)attributeDict
{
    if ([elementName isEqualToString:@"Structure"])
    {
        if ([attributeDict valueForKey:@"moduleType"] != nil)
            self.moduleType=[attributeDict valueForKey:@"moduleType"];
        if ([attributeDict valueForKey:@"description"] != nil)
            self.structureDescription=[attributeDict valueForKey:@"description"];
        if ([attributeDict valueForKey:@"structureVersion"] != nil)
            self.structureVersion=[[attributeDict valueForKey:@"version"] intValue];
        NSString* structureType=[attributeDict valueForKey:@"type"];
        if (structureType==nil || ![structureType isEqualToString:[self.class getStructureType]])
            @throw [NSException
             exceptionWithName:@"InvalidMetastructure"
             reason:[NSString stringWithFormat:@"Incorrect metastructure type. Expected %@. Actual %@",[self.class getStructureType],structureType ]
             userInfo:nil];
    }
}

@end
