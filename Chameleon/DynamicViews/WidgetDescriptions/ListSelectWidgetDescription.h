//
//  BssDataSelectWidget.h
//  mBSClient
//
//  Created by Maksim Voronin on 31.07.14.
//  Copyright (c) 2014 Самсонов Николай. All rights reserved.
//

#import "BaseSelectWidgetDescription.h"

@interface ListSelectWidgetDescription : BaseSelectWidgetDescription
@property(nonatomic,strong) NSMutableArray* values;
@end

@interface StructureListValue : NSObject<HierarchicalXMLParserDelegate>
@property(nonatomic,strong) NSString* identifier;
@property(nonatomic,strong) NSString* value;
@property(nonatomic,strong) NSMutableDictionary* fills;
@end

