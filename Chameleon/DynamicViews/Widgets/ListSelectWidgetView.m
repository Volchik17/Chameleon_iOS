//
//  ListSelectWidgetView.m
//  mBSClient
//
//  Created by Maksim Voronin on 23.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "ListSelectWidgetView.h"
#import "ListSelectWidgetDescription.h"
#import "Field.h"
#import "WidgetController.h"

@implementation ListSelectWidgetView

-(void) registerStaticAttributes:(BaseWidgetDescription *)structureWidget
{
    [super registerStaticAttributes:structureWidget];
    _values = ((ListSelectWidgetDescription *)structureWidget).values;
}

-(NSString*) getWidgetType
{
    return @"ListSelect";
}

#pragma mark actions

- (void) onBtnAction:(UIButton*)sender
{
    /*ToDo:
     ListSelectTableViewController* listSelectTableViewController = [[UIStoryboard  storyboardWithName:@"DialogsStoryboard_iPad" bundle:nil] instantiateViewControllerWithIdentifier:@"ListSelectTableViewController"];
    listSelectTableViewController.delegate = self;
    listSelectTableViewController.values = _values;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:listSelectTableViewController];
    self.popover = [[UIPopoverController alloc] initWithContentViewController:navigationController];
    self.popover.delegate = self;
    [self.popover presentPopoverFromRect:sender.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];*/
}

#pragma List Select Table View Controller Delegate

- (void)selectValueIndex:(NSInteger)index
{
    StructureListValue* listValue = [_values objectAtIndex:index];
    Field* field = [self.controller getFieldByName:self.fieldName];
    if (field && self.enable && !self.changing)
    {
        [field setValue:[self.formatter convertStringToValue:listValue.value ofType:[field getDataType]]];
    }
    [self.popover dismissPopoverAnimated:YES];
     self.popover = nil;
}

@end
