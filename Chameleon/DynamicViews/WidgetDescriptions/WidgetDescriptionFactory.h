//
//  WidgetDescriptionFactory.h
//  mBSClient
//
//  Created by Volchik on 26.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseWidgetDescription.h"

@interface WidgetDescriptionFactory : NSObject

+(BaseWidgetDescription *) structureWidgetWithType:(NSString*) typeWidget;

@end
