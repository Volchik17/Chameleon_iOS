//
// Created by volchik on 09.11.14.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "DataType.h"

@class Value;

@protocol WidgetTextFormatter <NSObject>

-(NSString*) convertValueToString:(Value*) value;
-(Value*) convertStringToValue:(NSString*) string ofType:(DataType) dataType;

@optional

-(NSString*) getMask;
- (BOOL)textField:(UITextField *)currentTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
@end