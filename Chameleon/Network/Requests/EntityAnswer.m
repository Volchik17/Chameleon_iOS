//
//  EntityAnswer.m
//  Chameleon
//
//  Created by Volchik on 19.01.15.
//  Copyright (c) 2015 Volchik. All rights reserved.
//

#import "EntityAnswer.h"
#import "CustomizableEntity.h"

@implementation EntityAnswer

-(instancetype) init
{
    self=[super init];
    if (self)
    {
        _entity=[self createEntity];
    }
    return self;
}

//abstract method for override in descendents
-(CustomizableEntity*) createEntity
{
    return nil;
}

- (id<HierarchicalXMLParserDelegate>) didStartSubElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qualifiedName attributes:(NSDictionary*)attributeDict
{
    if ([elementName isEqualToString:@"fields"])
        return [[CustomizableEntityFullXMLParser alloc] initWithEntity:_entity];
    else
        return nil;
}
@end
