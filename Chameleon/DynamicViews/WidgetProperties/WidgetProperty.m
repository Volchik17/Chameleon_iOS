//
//  WidgetProperty.m
//  mBSClient
//
//  Created by Maksim Voronin on 21.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "WidgetProperty.h"
#import "Expression.h"
#import "ExpressionParser.h"
#import "ExpressionEvaluator.h"
#import "Value.h"

@implementation WidgetProperty

- (id)init
{
    return [self initWithDefaultValue:nil xmlTagName:nil loadingValue:nil];
}

- (id)initWithDefaultValue:(NSString*) defaultValue
{
    return [self initWithDefaultValue:defaultValue xmlTagName:nil loadingValue:defaultValue];
}

- (id)initWithDefaultValue:(NSString*) defaultValue xmlTagName:(NSString*) xmlTagName
{
    return [self initWithDefaultValue:defaultValue xmlTagName:xmlTagName loadingValue:defaultValue];
}

- (id)initWithDefaultValue:(NSString*) defaultValue xmlTagName:(NSString*) xmlTagName loadingValue:(NSString*) loadingValue
{
    self = [super init];
    if (self)
    {
        _xmlTagName = xmlTagName;
        _defaultValue = defaultValue;
        _loadingValue = loadingValue;
    }
    return self;
}

-(void) setXMLValue:(NSString*) value
{
    unchanged=false;
    if(value.length>0)
    {
        if([[value substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"#"])
        {
            calculatable = true;
            updatable = false;
            expressionString = [value substringFromIndex:1];
            _expression = [self compileExpression];
        }
        else if ([[value substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"$"])
        {
            calculatable = true;
            updatable = true;
            expressionString = [value substringFromIndex:1];
            _expression = [self compileExpression];
        }
        else
        {
            calculatable = false;
            updatable = false;
            expressionString = value;
            _expression = nil;
        }
    }
    else
    {
        calculatable = false;
        updatable = false;
        expressionString = @"";
        _expression = nil;
    }
}

-(void) setUnchanged
{
    unchanged = true;
    calculatable = false;
    updatable = false;
}

-(BOOL) isUnchanged
{
    return unchanged;
}

-(BOOL) isCalculatable
{
    return calculatable;
}

-(BOOL) isLongRunning
{
    if (!calculatable)
        return false;
    return [_expression isLongRunning];
}

-(Expression*) compileExpression
{
    //ToDo: Пока каждый раз компилим. В будущем нужен кэш
    ExpressionParser* parser = [[ExpressionParser alloc] init];
    return [parser parse:expressionString];
}

-(BOOL) isUpdatable
{
    return updatable;
}

-(Value*) calculate:(ExpressionEvaluator*)evaluator
{
    assert(_expression!=nil);
    return [evaluator evaluateExpression:_expression];
}

-(Value*) getStaticValue
{
    return [self convertFromString:expressionString];
}

-(Value*) getCalculatedValue:(Value*)value
{
    return [self convertFromValue:value];
}

-(int) describeContents
{
    return 0;
}

-(Value*) convertFromString:(NSString*)value
{
    return nil;
}

-(Value*) convertFromValue:(Value*)value
{
    return nil;
}

-(NSArray*) getTrackingFields
{
    if (calculatable && updatable)
        return [_expression getFieldDependencies];
    else
        return [NSArray new];
}

-(void) setPropertyForWidget:(id)widget value:(Value*)value setterName:(NSString*) setterName
{
    NSAssert(false,@"Abstract error");
}

@end
