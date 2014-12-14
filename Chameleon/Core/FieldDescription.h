//
//  FieldDescription.h
//  Chameleon
//
//  Created by Volchik on 26.11.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataType.h"

@interface FieldDescription : NSObject

@property (nonatomic, strong) NSString* fieldName;
@property (nonatomic, assign) DataType dataType;

@end
