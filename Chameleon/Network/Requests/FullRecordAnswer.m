//
//  FullRecordAnswer.m
//  Chameleon
//
//  Created by Volchik on 07.01.15.
//  Copyright (c) 2015 Volchik. All rights reserved.
//

#import "FullRecordAnswer.h"
#import "CustomRecord.h"
#import "CustomField.h"

@implementation FullRecordAnswer

-(instancetype) init
{
    self=[super init];
    if (self)
    {
        _record=[[CustomRecord alloc] init];
    }
    return self;
}


- (id<HierarchicalXMLParserDelegate>) didStartSubElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qualifiedName attributes:(NSDictionary*)attributeDict
{
    if ([elementName isEqualToString:@"fields"])
        return [[CustomRecordFullXMLParser alloc] initWithRecord:_record];
    else
        return nil;
}
@end
