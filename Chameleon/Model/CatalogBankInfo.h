//
//  CatalogBankInfo.h
//  Chameleon
//
//  Created by Volchik on 09.12.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HierarchicalXMLParser.h"

@interface CatalogBankInfo : NSObject<HierarchicalXMLParserDelegate>

@property (nonatomic,strong) NSString* catalogBankId;
@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* bankId;
@property (nonatomic,strong) NSString* url;

@end
