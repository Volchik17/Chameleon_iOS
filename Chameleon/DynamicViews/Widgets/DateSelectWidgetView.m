//
//  DateSelectWidgetView.m
//  mBSClient
//
//  Created by Maksim Voronin on 23.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "DateSelectWidgetView.h"
#import "Field.h"
#import "WidgetController.h"
#import "FormatterUtils.h"

@implementation DateSelectWidgetView

-(NSString*) getWidgetType
{
    return @"DateSelect";
}

#pragma mark actions

- (void) onBtnAction:(UIButton*)sender
{
    /* ToDo:
    SelectDateViewController* selectDateViewController = [[UIStoryboard  storyboardWithName:@"DialogsStoryboard_iPad" bundle:nil] instantiateViewControllerWithIdentifier:@"SelectDateViewController"];
    selectDateViewController.delegate = self;
    selectDateViewController.currentDate = [[self.controller getFieldByName:self.fieldName] getValueAsDate];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:selectDateViewController];
    self.popover = [[UIPopoverController alloc] initWithContentViewController:navigationController];
    self.popover.delegate = self;
    [self.popover presentPopoverFromRect:sender.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
     */
}

#pragma mark SelectDateViewControllerDelegate

- (void)changedDate:(NSDate*)date
{
    Field* field = [self.controller getFieldByName:self.fieldName];
    if (field && self.enable && !self.changing)
    {
        NSString* dateString = [FormatterUtils formateWithDate:date format:@"dd.MM.yyyy"];
        [field setValue:[self.formatter convertStringToValue:dateString ofType:[field getDataType]]];
    }
}

@end
