//
//  WidgetController.m
//  mBSClient
//
//  Created by Maksim Voronin on 24.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "WidgetController.h"
#import "IRecord.h"
#import "ExpressionEvaluator.h"
#import "BaseWidgetView.h"
#import "BaseWidgetDescription.h"
#import "RunTimeUtil.h"
#import "WidgetProperty.h"
#import "Value.h"
#import "CustomRecord.h"
#import "objc/runtime.h"
#import <objc/message.h>

@interface FieldNotificationItem : NSObject
@property (nonatomic,weak,readonly) BaseWidgetView* widget;
@property (nonatomic,weak,readonly) WidgetProperty* property;
@property (nonatomic,readonly) NSString* setterName;
-(id) initWithWidget:(BaseWidgetView*) widget property:(WidgetProperty*) property setterName:(NSString*) setterName;
@end

@implementation FieldNotificationItem

-(id) initWithWidget:(BaseWidgetView*) widget property:(WidgetProperty*) property setterName:(NSString*) setterName
{
    self = [super init];
    if (self)
    {
        _widget=widget;
        _property=property;
        _setterName=setterName;
    }
    return self;
}
@end

@interface ExternalRecordChangeNotifier:NSObject<FieldValueChangeDelegate>
{
    NSString* recordName;
}
-(id) initWithRecordName:(NSString*)mRecordName controller:(WidgetController*) controller;
-(void)onChangeValueOfField:(Field *)field;
@property (nonatomic,weak,readonly) WidgetController* controller;
@end

@implementation ExternalRecordChangeNotifier;

-(id) initWithRecordName:(NSString*)mRecordName controller:(WidgetController*) controller
{
    self=[super init];
    if (self)
    {
        recordName=mRecordName;
    }
    return self;
}

-(void)onChangeValueOfField:(Field *)field
{
    [_controller onChangedField:[field getFieldName] recordName:recordName];
}

@end


@interface WidgetController ()
@property(nonatomic,strong) NSMutableDictionary* widgetsVisibility;
@property(nonatomic,strong) NSMutableDictionary* widgetNotifiers;
@property(nonatomic,strong) NSMutableDictionary* externalRecordsNotifiers;
@property(nonatomic,strong) NSMutableDictionary* fieldVisibilityNotifiers;
@property(nonatomic,strong) NSMutableDictionary* fieldPropertyNotifiers;
@property(nonatomic,strong) NSMutableDictionary* fieldWidgetNotifiers;
@end

@implementation WidgetController

- (id)init
{
    @throw [NSException
            exceptionWithName:NSInternalInconsistencyException
            reason:@"initWithBankId:record:extraFields:viewStructure:"
            userInfo:nil];
}

- (id)initWithBankId:(NSString*)bankId record:(id<IRecord>)record extraFields:(NSMutableDictionary*)extraFields viewStructure:(ViewStructure *)viewStructure
{
    self = [super init];
    if (self)
    {
        _started=NO;
        _widgetsVisibility = [[NSMutableDictionary alloc] init];
        _externalRecordsNotifiers = [[NSMutableDictionary alloc] init];
        _fieldVisibilityNotifiers = [[NSMutableDictionary alloc] init];
        _fieldPropertyNotifiers = [[NSMutableDictionary alloc] init];
        _fieldWidgetNotifiers = [[NSMutableDictionary alloc] init];
        _record = record;
        _extraFields = extraFields;
        _viewStructure = viewStructure;
        _evaluator = [[ExpressionEvaluator alloc] initWithBankId:bankId];
        [_evaluator setRecord:record];
        
        if (extraFields != nil)
            [_evaluator setInfoRecords:extraFields];
        
        if (record != nil)
        {
            NSArray* fieldNames = [record getFieldNames];
            for (NSString* fieldName in fieldNames)
            {
                [_fieldVisibilityNotifiers setValue:[[NSMutableArray alloc] init] forKey:[fieldName uppercaseString]];
                [_fieldPropertyNotifiers setValue:[[NSMutableArray alloc] init] forKey:[fieldName uppercaseString]];
                [_fieldWidgetNotifiers setValue:[[NSMutableSet alloc] init] forKey:[fieldName uppercaseString]];
                [record getFieldWithName:fieldName].fieldValueChangeDelegate=self;
            }
        }
        
        if (extraFields != nil)
        {
            for (NSString* name in [extraFields allKeys])
            {
                id<IRecord> rec = [extraFields objectForKey:name];
                [_externalRecordsNotifiers setValue:[[ExternalRecordChangeNotifier alloc] initWithRecordName:name controller:self] forKey:name];
                NSArray* fieldNames = [rec getFieldNames];
                for (NSString* fieldName in fieldNames)
                {
                    [_fieldVisibilityNotifiers setValue:[[NSMutableArray alloc] init] forKey:[[NSString stringWithFormat:@"%@.%@",name,fieldName] uppercaseString]];
                    [_fieldPropertyNotifiers setValue:[[NSMutableArray alloc] init] forKey:[[NSString stringWithFormat:@"%@.%@",name,fieldName] uppercaseString]];
                    [_fieldWidgetNotifiers setValue:[[NSMutableSet alloc] init] forKey:[[NSString stringWithFormat:@"%@.%@",name,fieldName] uppercaseString]];
                    //ToDo:  Тут нужно переделать чтобы отслеживать и имя рекорда
                    [rec getFieldWithName:fieldName].fieldValueChangeDelegate=self;
                }
            }
        }
        
    }
    return self;
}

-(void) onChangedField:(NSString*)fieldName recordName:(NSString*) recordName
{
    NSString* fullName=[recordName.length==0?fieldName:[NSString stringWithFormat:@"%@.%@",recordName,fieldName] uppercaseString];
    for (BaseWidgetView* widget in (NSMutableSet*)[_fieldWidgetNotifiers objectForKey:fullName])
    {
        [widget onFieldChanged:fullName];
    }
    
    for (FieldNotificationItem* item in [_fieldPropertyNotifiers objectForKey:fullName])
    {
        if (!item.property.isUpdatable)
            continue;
        if (item.property.isLongRunning)
            [self runEvaluateRequestForProperty:item.property widget:item.widget setterName:item.setterName];
        else
        {
            Value* value=[item.property calculate:_evaluator];
            if (!value.isUnknown)
                [item.property setPropertyForWidget:item.widget value:value setterName:item.setterName];
        }
    }
    for (NSString* widgetId in [_fieldVisibilityNotifiers objectForKey:fullName]) {
        //ToDo:Доделать
        BaseWidgetDescription * widgetDescription=[_viewStructure getWidgetById:widgetId];
        if (widgetDescription==nil)
            continue;
        if (!widgetDescription.visible.isUpdatable)
            continue;
        if (widgetDescription.visible.isLongRunning)
            [self runEvaluateVisibilityRequestForWidget:widgetId expression:widgetDescription.visible.expression];
        else
        {
            Value* value=[widgetDescription.visible calculate:_evaluator];
            if (value.isUnknown)
                continue;
            [self setVisibilityForWidget:widgetId visible:value.convertToBool];
        }
    }
}

-(void)onChangeValueOfField:(Field *)field
{
    [self onChangedField:[field getFieldName] recordName:@""];
}

-(ExpressionEvaluator*) cloneEvaluator
{
    return [_evaluator copy];
}

-(void) setVisibilityForWidget:(NSString*) widgetId visible:(BOOL) visible
{
    id oldValueObj=[_widgetsVisibility objectForKey:widgetId];
    BOOL oldValue=oldValueObj!=nil && [(NSNumber*)oldValueObj boolValue];
    if (visible!=oldValue)
    {
        [_widgetsVisibility setValue:[NSNumber numberWithBool:visible] forKey:widgetId];
        if (_widgetVisibilityDelegate != nil)
            [_widgetVisibilityDelegate onChangedVisibilityOfWidget:widgetId];
    }
}

-(void) runEvaluateVisibilityRequestForWidget: (NSString*) widgetId expression: (Expression*) expression
{
    WidgetController *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ExpressionEvaluator* evaluatorCopy=[weakSelf cloneEvaluator];
        Value* value=[evaluatorCopy evaluateExpression:expression];
        if (value.isUnknown)
            return;
        BOOL visible=value.convertToBool;
        dispatch_async(dispatch_get_main_queue(), ^(){
            [weakSelf setVisibilityForWidget:widgetId visible:visible];
        });
    });
}

-(void) runEvaluateRequestForProperty:(WidgetProperty*) property widget:(BaseWidgetView*) widget setterName:(NSString*) setterName
{
    __weak WidgetController *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ExpressionEvaluator* evaluatorCopy=[weakSelf cloneEvaluator];
        Value* value=[evaluatorCopy evaluateExpression:property.expression];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (value.isUnknown)
                return;
            [property setPropertyForWidget:widget value:value setterName:setterName];
        });
        
    });
}

-(void) runEvaluateFieldValueRequestForFieldName:(NSString*)fieldName expression:(Expression*)expression evaluator:(ExpressionEvaluator*)evaluator
{
    Field* field = [_record getFieldWithName:fieldName];
    if (field == nil)
        return;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        Value* value = [evaluator evaluateExpression:expression];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (value.isUnknown)
                return;
            [field setValue:value];
        });
        
    });
}

-(void) registerTrackingVisibilityForWidget:(NSString*) widgetId fieldName:(NSString*) fieldName
{
    NSMutableArray* list=[_fieldVisibilityNotifiers objectForKey:[fieldName uppercaseString]];
    if (list!=nil)
        [list addObject:widgetId];
}

-(void) registerTrackingPropertyForWidget:(BaseWidgetView*) widget property:(WidgetProperty*) widgetProperty setterName:(NSString*)setterName fieldName:(NSString*)fieldName
{
    NSMutableArray* list=[_fieldPropertyNotifiers valueForKey:[fieldName uppercaseString]];
    if (list!=nil)
        [list addObject:[[FieldNotificationItem alloc] initWithWidget:widget property:widgetProperty setterName:setterName]];
}

-(void) calculateVisibility
{
    for (BaseWidgetDescription * widgetDescription in [[[self viewStructure] structureWidgets] widgets])
    {
        BOOL visible;
        if (widgetDescription.visible.isLongRunning)
            visible = true;
        else
            if (widgetDescription.visible.isCalculatable) {
                Value* value=[widgetDescription.visible calculate:_evaluator];
                visible=value.isUnknown || value.convertToBool;
            }
            else
                visible=widgetDescription.visible.getStaticValue.convertToBool;
        [_widgetsVisibility setValue:[NSNumber numberWithBool:visible] forKey:widgetDescription.widgetId];
        if (widgetDescription.visible.isLongRunning)
            [self runEvaluateVisibilityRequestForWidget:widgetDescription.widgetId expression:widgetDescription.visible.expression];
        if (widgetDescription.visible.isUpdatable) {
            NSArray* fields=widgetDescription.visible.getTrackingFields;
            for (NSString* fieldName in fields)
                [self registerTrackingVisibilityForWidget: widgetDescription.widgetId fieldName:[fieldName uppercaseString]];
        }
    }
}

-(void) startController
{
    if (!_started)
    {
        [self calculateVisibility];
        _started=YES;
    }
}

-(void) registerWidget:(BaseWidgetView*)widgetView structureWidget:(BaseWidgetDescription *)structureWidget
{
    id visibilityObj=[_widgetsVisibility objectForKey:structureWidget.widgetId];
    widgetView.visible = visibilityObj?[(NSNumber*)visibilityObj boolValue]:YES;
    [widgetView registerStaticAttributes:structureWidget];
    [self registerDynamicAttributes:widgetView structureWidget:structureWidget widgetClass:[structureWidget class]];
}

-(void)unregisterWidget:(BaseWidgetView*)widgetView
{
    for(NSMutableSet* list in _fieldWidgetNotifiers.allValues)
    {
        [list removeObject:widgetView];
    }
    for(NSMutableArray* list in _fieldPropertyNotifiers.allValues)
    {
        NSIndexSet *indexesToBeRemoved = [list indexesOfObjectsPassingTest:
                                          ^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                                              return ((FieldNotificationItem*)obj).widget==widgetView;
                                          }];
        [list removeObjectsAtIndexes:indexesToBeRemoved];
    }
}

-(void) registerDynamicAttributes:(BaseWidgetView*)widgetView structureWidget:(BaseWidgetDescription *)structureWidget widgetClass:(Class)widgetClass
{
    Class c = [widgetClass superclass];
    
    if (c != [NSObject class])
    {
        [self registerDynamicAttributes:widgetView structureWidget:structureWidget widgetClass:c];
    }
    
    NSArray* fields = [RunTimeUtil propertyNamesWithClass:widgetClass];
    for (NSString* field in fields)
    {
        Class fieldClass = [RunTimeUtil propertyClassWithName:field class:widgetClass];
        // проверяем тип свойства
        if (![RunTimeUtil currentClass:fieldClass isKindOfClass:[WidgetProperty class]])
            continue;
        // находим getter
        // получаем само свойство
        WidgetProperty* widgetProperty = ((WidgetProperty*(*)(id, SEL))objc_msgSend)(structureWidget, sel_registerName([field UTF8String]));
        // Свойство visible обрабатывается особым образом
        if (widgetProperty==structureWidget.visible)
            continue;
        NSMutableString * setterName = [field mutableCopy];
        [setterName replaceCharactersInRange:NSMakeRange(0,1) withString:[[field substringToIndex:1] uppercaseString]];
        [setterName insertString:@"set" atIndex:0];
        [setterName appendString:@":"];
        
        if ([widgetProperty isUpdatable])
        {
            NSArray* trackingFields = [widgetProperty getTrackingFields];
            for (NSString* trackingFieldName in trackingFields)
            {
                [self registerTrackingPropertyForWidget:widgetView property:widgetProperty setterName:setterName fieldName:trackingFieldName];
            }
        }
        // evaluating value
        if (widgetProperty.isLongRunning)
        {
            NSString *loadingValue=widgetProperty.loadingValue!=nil && widgetProperty.loadingValue.length>0?widgetProperty.loadingValue:widgetProperty.defaultValue;
            [widgetProperty setPropertyForWidget:widgetView value:[widgetProperty convertFromString:loadingValue] setterName:setterName];
            [self runEvaluateRequestForProperty:widgetProperty widget: widgetView setterName: setterName];
        }
        else
        {
            if (widgetProperty.isCalculatable)
            {
                Value* value=[widgetProperty calculate:_evaluator];
                if (!value.isUnknown)
                    [widgetProperty setPropertyForWidget:widgetView value:value setterName:setterName];
            }
            else
                if (!widgetProperty.isUnchanged)
                    [widgetProperty setPropertyForWidget:widgetView value:widgetProperty.getStaticValue setterName:setterName];
        }
    }
}

-(void)registerTrackingForWidget:(BaseWidgetView*) widget forField:(NSString*) fieldName;
{
    NSMutableSet* list=[_fieldWidgetNotifiers valueForKey:[fieldName uppercaseString]];
    if (list!=nil)
        [list addObject:widget];
}

-(BOOL) isWidgetVisible:(NSString*) widgetId
{
    NSNumber* visible = [_widgetsVisibility valueForKey:widgetId];
    return [visible boolValue];
}

-(Field*) getFieldByName:(NSString*)fieldName
{
    if (fieldName == nil)
    {
        return nil;
    }
    
    NSRange pos = [fieldName rangeOfString:@"."];
    
    if (pos.location == NSNotFound)
    {
        if (_record == nil)
        {
            return nil;
        }
        else
        {
            return [_record getFieldWithName:fieldName];
        }
    }
    else
    {
        NSString* recName = [fieldName substringWithRange:NSMakeRange(0, pos.location)];
        NSString* fldName = [fieldName substringFromIndex:pos.location + 1];
        if (_extraFields == nil)
        {
            return nil;
        }
        id<IRecord> extraRecord = [_extraFields objectForKey:recName];
        if (extraRecord != nil)
        {
            return [extraRecord getFieldWithName:fldName];
        }
        else
        {
            return nil;
        }
    }
}

@end