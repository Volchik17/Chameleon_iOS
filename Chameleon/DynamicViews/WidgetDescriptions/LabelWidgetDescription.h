//
//  BssLabelWidget.h
//  mBSClient
//
//  Created by Maksim Voronin on 31.07.14.
//  Copyright (c) 2014 Самсонов Николай. All rights reserved.
//

#import "BaseWidgetDescription.h"

@interface LabelWidgetDescription : BaseWidgetDescription
@property(nonatomic,strong) NSString* fieldName;
@property(nonatomic,strong) NSString* format;
-(void) parseAttributeWithName:(NSString*)attributeName attributeValue:(NSString*)attributeValue;
@end

