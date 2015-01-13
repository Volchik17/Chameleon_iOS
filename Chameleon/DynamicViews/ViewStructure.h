//
//  BssDocumentFormStructure.h
//  mBSClient
//
//  Created by Maksim Voronin on 30.07.14.
//  Copyright (c) 2014 Самсонов Николай. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HierarchicalXMLParser.h"
#import "WidgetDescriptionList.h"
#import "BaseWidgetDescription.h"

@interface ViewStructure : NSObject<HierarchicalXMLParserDelegate>
@property(nonatomic,strong) WidgetDescriptionList * structureWidgets;
-(BaseWidgetDescription *) getWidgetById:(NSString*) widgetId;
@end

