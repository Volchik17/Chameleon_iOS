//
//  DictionarySelectWidgetView.m
//  mBSClient
//
//  Created by Maksim Voronin on 23.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "DictionarySelectWidgetView.h"
#import "DictionarySelectWidgetDescription.h"
//#import "DictionaryManager.h"
#import "WidgetController.h"
#import "ExpressionParser.h"
#import "Expression.h"

@implementation DictionarySelectWidgetView

-(void) registerStaticAttributes:(BaseWidgetDescription *)structureWidget
{
    [super registerStaticAttributes:structureWidget];
    _dictionary = ((DictionarySelectWidgetDescription *)structureWidget).dictionary;
    _fills = ((DictionarySelectWidgetDescription *)structureWidget).fills;
    _lookupFieldName = ((DictionarySelectWidgetDescription *)structureWidget).lookupFieldName;
}

-(NSString*) getWidgetType
{
    return @"DictionarySelect";
}

#pragma mark actions

- (void) onBtnAction:(UIButton*)sender
{
    /* ToDo:
     DictionaryListFormViewController* dictionaryListForm = (DictionaryListFormViewController*)[[DictionaryManager sharedInstance] getListDictionaryFormWithSystemBankId:1 bankId:@"standart" moduleName:_dictionary];
    dictionaryListForm.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:dictionaryListForm];
    self.popover = [[UIPopoverController alloc] initWithContentViewController:navigationController];
    self.popover.delegate = self;
    [self.popover presentPopoverFromRect:sender.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];*/
}

- (void) didSelectRecord:(id<IRecord>)record
{
    Field* field = (self.fieldName != nil ? [self.controller getFieldByName:self.fieldName] : nil);
    if (field != nil && _lookupFieldName != nil && _lookupFieldName.length > 0)
    {
        [field setValue:[[record getFieldWithName:_lookupFieldName] getValue]];
    }
    
    if ([_fills count] > 0)
    {
        ExpressionEvaluator* evaluator = [self.controller cloneEvaluator];
        [[evaluator getInfoRecords] setObject:record forKey:@"dictionary"];
        
        for (NSString* targetFieldName in [_fills allKeys])
        {
            NSString* expressionString = [_fills objectForKey:targetFieldName];
            if (expressionString.length > 0 && [[expressionString substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"#"])
            {
                ExpressionParser* parser = [[ExpressionParser alloc] init];
                Expression* expression = [parser parse:[expressionString substringFromIndex:1]];
                if ([expression isLongRunning])
                    [self.controller runEvaluateFieldValueRequestForFieldName:targetFieldName expression:expression evaluator:evaluator];
                else
                {
                    Value* value = [evaluator evaluateExpression:expression];
                    Field* targetField = [self.controller getFieldByName:targetFieldName];
                    if (targetField != nil && ![value isUnknown])
                        [targetField setValue:value];
                }
            } else
            {
                Field* targetField = [self.controller getFieldByName:targetFieldName];
                if (targetField != nil)
                    [targetField setStringValue:expressionString];
            }
        }
    }
    [self.popover dismissPopoverAnimated:YES];
    self.popover = nil;
}

@end
