//
//  CustomField.h
//  mBSClient
//
//  Created by Maksim Voronin on 02.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "Field.h"

@class Value;
@class TableFieldDescription;
@interface CustomField : Field
{
    Value* value;
    DataType dataType;
}
- (id)initWithFieldName:(NSString*)aFieldName dataType:(DataType)aDataType;
- (id)initWithFieldMetaStructure:(TableFieldDescription *)fieldTable;
- (id)initWithField:(Field*)field;

- (Value*)getValue;
- (DataType)getDataType;

@end
