//
//  ExpressionEvaluator.h
//  mBSClient
//
//  Created by Maksim Voronin on 14.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRecord.h"

@class Value;
@protocol IExpressionEvaluatorCallback <NSObject>
- (Value*) getFieldValue:(NSString*)fieldName;
- (Value*) getFieldValue:(NSString*)fieldName recordName:(NSString*)recordName;
- (NSString*) getLocalResValue:(NSString*)resId;
- (Value*) getFunctionValue:(NSString*)functionName arguments:(NSArray*)arguments;
@end

@class Expression;
@interface ExpressionEvaluator : NSObject<NSCopying>
@property(nonatomic,strong) id <IRecord> record;
@property(nonatomic,strong) NSMutableDictionary* infoRecords;
@property(nonatomic,strong) id <IExpressionEvaluatorCallback> callback;
@property(nonatomic,strong) NSString* bankId;
- (id)initWithBankId:(NSString*)newBankId;
-(id<IExpressionEvaluatorCallback>) getCallback;
-(void) setCallback:(id <IExpressionEvaluatorCallback>) newCallback;
-(void) setRecord:(id <IRecord>) newRecord;
-(id <IRecord>)getRecord;
-(void) setInfoRecords:(NSMutableDictionary*) newInfoRecords;
-(NSMutableDictionary*) getInfoRecords;
-(Value*) evaluateExpression:(Expression*) expression;
-(id) copyWithZone:(NSZone*) zone;
@end
