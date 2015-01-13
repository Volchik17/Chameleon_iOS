//
//  DocumentFormWidgets.m
//  mBSClient
//
//  Created by Maksim Voronin on 15.08.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "WidgetDescriptionList.h"
#import "BaseGroupWidgetDescription.h"
#import "GroupWidgetDescription.h"
#import "VGroupWidgetDescription.h"
#import "BaseWidgetDescription.h"
#import "SimpleFieldWidgetDescription.h"
#import "LabelWidgetDescription.h"
#import "ButtonWidgetDescription.h"
#import "EditFieldWidgetDescription.h"
#import "DateSelectWidgetDescription.h"
#import "ListSelectWidgetDescription.h"
#import "HierarchicalXMLParser.h"
#import "DictionarySelectWidgetDescription.h"
#import "WidgetDescriptionFactory.h"

@implementation WidgetDescriptionList

- (id)init
{
    if(self = [super init])
    {
        self.widgets  = [[NSMutableArray alloc] init];
    }
    return self;
}

@end

