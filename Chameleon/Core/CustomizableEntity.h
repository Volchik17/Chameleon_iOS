//
//  CustomizableEntity.h
//  mBSClient
//
//  Created by Maksim Voronin on 03.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRecord.h"
#import "Field.h"

@class CustomRecord;
@interface CustomizableEntity : NSObject <IRecord>
{
    CustomRecord* customFields;
    @protected
    NSMutableDictionary* systemFields;
}
- (id)init NS_REQUIRES_SUPER;
- (CustomRecord*) getCustomFields;
- (void) registerSystemField:(NSString*)fieldName;
- (void) registerSystemField:(NSString*)fieldName ForPropertyName:(NSString*)propertyName;
- (void) registerFields NS_REQUIRES_SUPER;
@end


