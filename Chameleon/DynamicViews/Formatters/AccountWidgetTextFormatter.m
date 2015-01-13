//
//  AccountWidgetTextFormatter.m
//  mBSClient
//
//  Created by Maksim Voronin on 11.11.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "AccountWidgetTextFormatter.h"
#import "Value.h"
//#import "BssUtils.h"
#import "FormatterUtils.h"

@implementation AccountWidgetTextFormatter

- (void)setMaskAccount:(NSMutableString*)account
{
    if (account != nil && account.length > 0)
    {
        if (account.length > 5)
        {
            [account insertString:@"." atIndex:5];
        }
        if (account.length > 9)
        {
            [account insertString:@"." atIndex:9];
        }
        if (account.length > 11)
        {
            [account insertString:@"." atIndex:11];
        }
    }
}

-(NSString*) convertValueToString:(Value*) value
{
    if (value.isUnknown)
        return @"";
    NSMutableString* account = [NSMutableString stringWithString:[value convertToString]];
    [self setMaskAccount:account];
    return account;
}

-(Value*) convertStringToValue:(NSString*) string ofType:(DataType) dataType
{
    if (string.length == 0)
        return [Value unknown];
    NSString* account = [string stringByReplacingOccurrencesOfString:@"." withString:@""];
    return [[Value alloc] initWithString:account];
}

#pragma mark optional

-(NSString*) getMask
{
    return @"_____.___._.___________";
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *trimmingTextFieldText = nil;
    NSString *currentText = textField.text;
    NSString *newTextFieldText = nil;
    NSRange   curretnRange = range;
    
    NSInteger locationInput = range.location;
    if (string.length > 0 )
        locationInput = locationInput + 1;
    
    newTextFieldText = [currentText stringByReplacingCharactersInRange:curretnRange withString:string];
    trimmingTextFieldText = [newTextFieldText stringByReplacingOccurrencesOfString:@"." withString:@""];
    if (string.length != 0)
    {
        if ([FormatterUtils checkTextWithRegularPattern:@"[0-9]{0,20}" string:trimmingTextFieldText] != YES)
        {
            return NO;
        }
        NSMutableString* account = [NSMutableString stringWithString:trimmingTextFieldText];
        [self setMaskAccount:account];
        textField.text = account;
        if (textField.text.length > newTextFieldText.length)
        {
            locationInput = locationInput + 1;
        }
    }
    else
    {
        NSMutableString* account = [NSMutableString stringWithString:trimmingTextFieldText];
        [self setMaskAccount:account];
        textField.text = account;
        if (textField.text.length < newTextFieldText.length)
        {
            locationInput = locationInput - 1;
        }
        return NO;
    }
    UITextPosition *beginning = textField.beginningOfDocument;
    UITextPosition *start = [textField positionFromPosition:beginning offset:locationInput];
    UITextRange *textRange = [textField textRangeFromPosition:start toPosition:start];
    [textField setSelectedTextRange:textRange];
    
    return YES;
}

@end
