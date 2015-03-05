//
//  StringArrayParser.h
//  Chameleon
//
//  Created by Volchik on 21.01.15.
//  Copyright (c) 2015 Volchik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HierarchicalXMLParser.h"

@interface StringArrayParser : NSObject<HierarchicalXMLParserDelegate>

@property (nonatomic,readonly) NSString* tagName;
@property (nonatomic,readonly) NSString* attributeName;
@property (nonatomic,readonly) NSMutableArray* data;

-(instancetype) initWithArray:(NSMutableArray*) data tagName:(NSString*) tagName attributeName:(NSString*) attributeName;

@end
