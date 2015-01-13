//
//  WidgetProperty.h
//  mBSClient
//
//  Created by Maksim Voronin on 21.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Expression;
@class Value;
@class ExpressionEvaluator;
@interface WidgetProperty : NSObject
{
    BOOL unchanged;
    BOOL calculatable;
    BOOL updatable;
    NSString* expressionString;
}

@property(nonatomic,strong,readonly) NSString* xmlTagName;
@property(nonatomic,strong,readonly) NSString* defaultValue;
@property(nonatomic,strong,readonly) NSString* loadingValue;
@property(nonatomic,strong,readonly) Expression* expression;

- (id)init;
- (id)initWithDefaultValue:(NSString*) defaultValue;
- (id)initWithDefaultValue:(NSString*) defaultValue xmlTagName:(NSString*) xmlTagName;
- (id)initWithDefaultValue:(NSString*) defaultValue xmlTagName:(NSString*) xmlTagName loadingValue:(NSString*) loadingValue;

-(void) setXMLValue:(NSString*) value;
-(void) setUnchanged;
-(BOOL) isUnchanged;
-(BOOL) isCalculatable;
-(BOOL) isLongRunning;
-(BOOL) isUpdatable;
-(Value*) calculate:(ExpressionEvaluator*)evaluator;
-(Value*) getStaticValue;
-(int) describeContents;
-(Value*) convertFromString:(NSString*)value;
-(Value*) convertFromValue:(Value*)value;
-(NSArray*) getTrackingFields;
-(void) setPropertyForWidget:(id)widget value:(Value*)value setterName:(NSString*) setterName;

@end
