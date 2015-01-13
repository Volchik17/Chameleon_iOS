//
//  WidgetTextFormatterFactory.h
//  mBSClient
//
//  Created by Volchik on 09.11.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WidgetTextFormatter.h"

@interface WidgetTextFormatterFactory : NSObject

+(id<WidgetTextFormatter>) getFormatter:(NSString*) format forDataType:(DataType) dataType;

@end
