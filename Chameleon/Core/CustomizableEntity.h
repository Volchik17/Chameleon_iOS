//
//  CustomizableEntity.h
//  mBSClient
//

#import <Foundation/Foundation.h>
#import "IRecord.h"
#import "Field.h"
#import "HierarchicalXMLParser.h"

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

@interface CustomizableEntityFullXMLParser : NSObject<HierarchicalXMLParserDelegate>
{
    __weak CustomizableEntity* _entity;
}
-(instancetype) initWithEntity:(CustomizableEntity*) entity;
@end


