//
//  CustomRecord.h
//  mBSClient
//
//  Created by Maksim Voronin on 03.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRecord.h"
#import "DataType.h"
#import "HierarchicalXMLParser.h"

@class CustomField;
@interface CustomRecord : NSObject <IRecord,NSCopying>
{
    NSMutableDictionary* fields;
}
- (id)initWithRecord:(id<IRecord>)record;
- (void)addFieldWithCustomField:(CustomField*)field;
- (CustomField*)addFieldWithName:(NSString*)name;
- (CustomField*)addFieldWithName:(NSString*)name dataType:(DataType)type;
- (NSEnumerator*)objectEnumerator;
- (id) copyWithZone:(NSZone*) zone;
@end

@interface CustomRecordEnumerator : NSEnumerator
{
    NSEnumerator* internalEnumerator;
    NSMutableDictionary* stack;
}
- (id)initWithFields:(NSMutableDictionary*)fields;
@end

@interface RecordXMLParser : NSObject<HierarchicalXMLParserDelegate>
{
    __weak id<IRecord> _record;
}
-(instancetype) initWithRecord:(id<IRecord>) record;
@end

@interface CustomRecordFullXMLParser : NSObject<HierarchicalXMLParserDelegate>
{
    __weak CustomRecord* _record;
}
-(instancetype) initWithRecord:(CustomRecord*) record;
@end

