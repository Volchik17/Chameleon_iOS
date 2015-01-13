//
//  DictionarySelectWidgetView.h
//  mBSClient
//
//  Created by Maksim Voronin on 23.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "BaseSelectWidgetView.h"

//ToDo: @interface DictionarySelectWidgetView : BaseSelectWidgetView <DictionaryListFormViewControllerDelegate>
@interface DictionarySelectWidgetView : BaseSelectWidgetView
@property(nonatomic,strong) NSString* dictionary;
@property(nonatomic,strong) NSDictionary* fills;
@property(nonatomic,strong) NSString* lookupFieldName;
@end
