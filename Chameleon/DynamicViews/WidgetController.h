//
//  WidgetController.h
//  mBSClient
//
//  Created by Maksim Voronin on 24.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRecord.h"
#import "ViewStructure.h"
#import "ExpressionEvaluator.h"
#import "BaseWidgetView.h"

@protocol WidgetVisibilityDelegate<NSObject>

-(void) onChangedVisibilityOfWidget: (NSString*) widgetId;

@end

@interface WidgetController : NSObject<FieldValueChangeDelegate>
@property(nonatomic,strong) id<IRecord> record;
@property(nonatomic,strong) NSMutableDictionary* extraFields; //<String,Record>
@property(nonatomic,strong) ViewStructure * viewStructure;
@property(nonatomic,strong) ExpressionEvaluator* evaluator;
@property(nonatomic,weak) id<WidgetVisibilityDelegate> widgetVisibilityDelegate;
@property(nonatomic,readonly) BOOL started;

- (id)initWithBankId:(NSString*)bankId record:(id<IRecord>)record
         extraFields:(NSMutableDictionary*)extraFields viewStructure:(ViewStructure *)viewStructure;
-(void) registerWidget:(BaseWidgetView*)widgetView structureWidget:(BaseWidgetDescription *)structureWidget;
-(void) unregisterWidget:(BaseWidgetView*)widgetView;
-(void) runEvaluateFieldValueRequestForFieldName:(NSString*)fieldName expression:(Expression*)expression evaluator:(ExpressionEvaluator*)evaluator;
-(void) registerTrackingForWidget:(BaseWidgetView*) widget forField:(NSString*) fieldName;
-(void) onChangedField:(NSString*)fieldName recordName:(NSString*) recordName;
-(void) startController;
-(BOOL) isWidgetVisible:(NSString*) widgetId;
-(Field*) getFieldByName:(NSString*)fieldName;
-(ExpressionEvaluator*) cloneEvaluator;
@end

