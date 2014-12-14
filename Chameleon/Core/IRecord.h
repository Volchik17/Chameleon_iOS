//
//  IRecord.h
//  mBSClient
//
//  Created by Maksim Voronin on 03.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Field.h"

@protocol IRecord <NSObject>
- (Field*)getFieldWithName:(NSString*)name;
- (NSArray*)getFieldNames;
- (int)size;
@end
