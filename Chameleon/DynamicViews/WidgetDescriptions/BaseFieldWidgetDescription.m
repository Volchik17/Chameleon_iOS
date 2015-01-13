//
//  BaseFieldWidget.m
//  mBSClient
//
//  Created by Maksim Voronin on 31.07.14.
//  Copyright (c) 2014 Самсонов Николай. All rights reserved.
//

#import "BaseFieldWidgetDescription.h"
#import "BaseWidgetDescription.h"
#import "WidgetStringProperty.h"
#import "WidgetBooleanProperty.h"
#import "WidgetIntProperty.h"

@implementation BaseFieldWidgetDescription

- (id)init
{
    if(self = [super init])
    {
        _fieldName = @"";
        _format    = @"";
        _value     = [[WidgetStringProperty alloc] initWithDefaultValue:nil xmlTagName:nil loadingValue:@"loading..."];
        _hint      = [[WidgetStringProperty alloc] init];
        _editable  = [[WidgetBooleanProperty alloc] initWithDefaultValue:@"true"];
        _lines     = [[WidgetIntProperty alloc] initWithDefaultValue:@"1"];
        _size      = [[WidgetIntProperty alloc] initWithDefaultValue:@"0"];
        _labelVisible = [[WidgetBooleanProperty alloc] initWithDefaultValue:@"true"];
    }
    return self;
}

-(void) parseAttributeWithName:(NSString*)attributeName attributeValue:(NSString*)attributeValue
{
    [super parseAttributeWithName:attributeName attributeValue:attributeValue];
    
    if ([[attributeName lowercaseString] isEqualToString:[@"fieldName" lowercaseString]])
    {
        self.fieldName = attributeValue;
    }
    else if ([[attributeName lowercaseString] isEqualToString:[@"format" lowercaseString]])
    {
        self.format = attributeValue;
    }
}

@end

