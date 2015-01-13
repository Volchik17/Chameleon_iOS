//
//  EditableTextWidgetView.m
//  mBSClient
//
//  Created by Maksim Voronin on 23.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "EditableTextWidgetView.h"

@implementation EditableTextWidgetView

#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL bResult = NO;
    if (_size > 0 && textField.text.length >= _size && string.length > 0)
        return bResult;    
    bResult = [super textField:textField shouldChangeCharactersInRange:range replacementString:string];
    return bResult;
}

@end
