//
//  AmountWidgetTextFormatter.m
//  mBSClient
//
//  Created by Maksim Voronin on 11.11.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "AmountWidgetTextFormatter.h"
#import "Value.h"
//#import "BssUtils.h"
#import "FormatterUtils.h"

@implementation AmountWidgetTextFormatter

-(NSString*) convertValueToString:(Value*)value
{
    if (value.isUnknown)
        return @"";
    
    NSNumberFormatter *formatter = [FormatterUtils amountFromatter];
    return [formatter stringFromNumber:[NSNumber numberWithDouble:[value convertToDouble]]];
}

-(Value*) convertStringToValue:(NSString*) string ofType:(DataType) dataType
{
    NSNumberFormatter *formatter = [FormatterUtils amountFromatter];
    NSNumber* ammount = [formatter numberFromString:string];
    return [[Value alloc] initWithDouble:[ammount doubleValue]];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *trimmingTextFieldText = nil;
    NSString *currentText      = textField.text;
    NSString *newTextFieldText = nil;
    NSInteger locationInput    = range.location;
    
    if (string.length > 0 )
    {
        locationInput = locationInput + 1;
    }
    else if ([[currentText substringWithRange:range] isEqual:@" "])
    {
        range.location -= 1;
    }
    
    newTextFieldText = [currentText stringByReplacingCharactersInRange:range withString:string];
    trimmingTextFieldText = [newTextFieldText stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSNumberFormatter *formatter = [FormatterUtils amountFromatter];
    NSMutableString   *formattedString = nil;
    
    if (trimmingTextFieldText.length > 0 == FALSE)
    {
        textField.text = [formatter stringFromNumber:[NSNumber numberWithDouble:0.00]];
        return NO;
    }
    else if (trimmingTextFieldText.length < 3)
    {
        trimmingTextFieldText = [formatter stringFromNumber:[NSNumber numberWithDouble:[trimmingTextFieldText doubleValue]]];
    }
    
    formattedString = [NSMutableString stringWithString:[trimmingTextFieldText stringByReplacingOccurrencesOfString:formatter.decimalSeparator withString:@""]];
    [formattedString insertString:@"." atIndex:formattedString.length-2];
    
    if ([FormatterUtils checkTextWithRegularPattern:@"[0-9]{0,12}[.,]?[0-9]*" string:formattedString] != YES)
    {
        return NO;
    }
    textField.text = [formatter stringFromNumber:[NSNumber numberWithDouble:[formattedString doubleValue]]];
    
    if (textField.text.length > newTextFieldText.length)
    {
        locationInput = locationInput + 1;
    }
    if (textField.text.length < newTextFieldText.length)
    {
        locationInput = locationInput - 1;
    }
    
    UITextPosition* beginning = textField.beginningOfDocument;
    UITextPosition* start = [textField positionFromPosition:beginning offset:locationInput];
    UITextRange* textRange = [textField textRangeFromPosition:start toPosition:start];
    [textField setSelectedTextRange:textRange];
    
    return YES;
}

@end
