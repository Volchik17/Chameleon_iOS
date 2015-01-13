//
//  WidgetDescriptionFactory.m
//  mBSClient
//
//  Created by Volchik on 26.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "WidgetDescriptionFactory.h"
#import "SimpleFieldWidgetDescription.h"
#import "EditFieldWidgetDescription.h"
#import "ButtonWidgetDescription.h"
#import "LabelWidgetDescription.h"
#import "DictionarySelectWidgetDescription.h"
#import "ListSelectWidgetDescription.h"
#import "DateSelectWidgetDescription.h"
#import "GroupWidgetDescription.h"
#import "VGroupWidgetDescription.h"

@implementation WidgetDescriptionFactory

+(BaseWidgetDescription *) structureWidgetWithType:(NSString*) typeWidget
{
    NSString* upperTypeWidget = [typeWidget uppercaseString];
    
    if (upperTypeWidget == nil ||  [typeWidget isEqualToString:[@"string" uppercaseString]])
    {
        return [[SimpleFieldWidgetDescription alloc] init];
    }
    else if ([upperTypeWidget isEqualToString:[@"editText" uppercaseString]])
    {
        return [[EditFieldWidgetDescription alloc] init];
    }
    else if ([upperTypeWidget isEqualToString:[@"button" uppercaseString]])
    {
        return [[ButtonWidgetDescription alloc] init];
    }
    else if ([upperTypeWidget isEqualToString:[@"label" uppercaseString]])
    {
        return [[LabelWidgetDescription alloc] init];
    }
    else if ([upperTypeWidget isEqualToString:[@"DictionarySelect" uppercaseString]])
    {
        return [[DictionarySelectWidgetDescription alloc] init];
    }
    else if ([upperTypeWidget isEqualToString:[@"listSelect" uppercaseString]])
    {
        return [[ListSelectWidgetDescription alloc] init];
    }
    else if ([upperTypeWidget isEqualToString:[@"dateSelect" uppercaseString]])
    {
        return [[DateSelectWidgetDescription alloc] init];
    }
    else if ([upperTypeWidget isEqualToString:[@"group" uppercaseString]])
    {
        return [[GroupWidgetDescription alloc] init];
    }
    else if ([upperTypeWidget isEqualToString:[@"vgroup" uppercaseString]])
    {
        return [[VGroupWidgetDescription alloc] init];
    }
    else
    {
        return nil;
    }
}

@end
