//
//  BssGroupWidget.m
//  mBSClient
//
//  Created by Maksim Voronin on 31.07.14.
//  Copyright (c) 2014 Самсонов Николай. All rights reserved.
//

#import "GroupWidgetDescription.h"
#import "BaseFieldWidgetDescription.h"

@implementation GroupWidgetDescription

-(NSString*) getWidgetType
{
    return @"Group";
}

-(void) parseAttributeWithName:(NSString*)attributeName attributeValue:(NSString*)attributeValue
{
    [super parseAttributeWithName:attributeName attributeValue:attributeValue];
    
    if ([[attributeName lowercaseString] isEqualToString:[@"labelsVisible" lowercaseString]])
    {
        self.labelsVisible = [attributeValue boolValue];
    }
}

@end

