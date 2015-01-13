//
// Created by volchik on 09.11.14.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "DefaultWidgetTextFormatter.h"
#import "Value.h"


@implementation DefaultWidgetTextFormatter

-(NSString*) convertValueToString:(Value*) value
{
    return [value convertToString];
}
    
-(Value*) convertStringToValue:(NSString*) string ofType:(DataType) dataType
{
    return [[Value alloc] initWithDataType:dataType value:[NSValue value:&string withObjCType:@encode(NSString)]];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString* newTextFieldText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    textField.text = newTextFieldText;
    return YES;
}

@end