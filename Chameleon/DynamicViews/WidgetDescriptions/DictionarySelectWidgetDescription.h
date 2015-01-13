//
//  DictionarySelectWidgetDescription.h
//  mBSClient
//
//  Created by Maksim Voronin on 20.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "BaseSelectWidgetDescription.h"

@interface DictionarySelectWidgetDescription : BaseSelectWidgetDescription
@property(nonatomic,strong) NSString* dictionary;
@property(nonatomic,strong) NSString* lookupFieldName;
@property(nonatomic,strong) NSMutableDictionary* fills;
@end

