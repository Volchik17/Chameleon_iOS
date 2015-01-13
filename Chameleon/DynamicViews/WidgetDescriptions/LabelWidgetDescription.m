//
//  BssLabelWidget.m
//  mBSClient
//
//  Created by Maksim Voronin on 31.07.14.
//  Copyright (c) 2014 Самсонов Николай. All rights reserved.
//

#import "LabelWidgetDescription.h"

@implementation LabelWidgetDescription

-(NSString*) getWidgetType
{
    return @"LABEL";
}

-(void) parseAttributeWithName:(NSString*)attributeName attributeValue:(NSString*)attributeValue;
{
    [super parseAttributeWithName:attributeName attributeValue:attributeValue];
    if ([[attributeName lowercaseString] isEqualToString:@"fieldname"])
    {
        _fieldName = attributeValue;
    }
    else if ([[attributeName lowercaseString] isEqualToString:@"format"])
    {
        _format = attributeValue;
    }
}

@end

