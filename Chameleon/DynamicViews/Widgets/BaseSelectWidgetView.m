//
//  BaseSelectWidgetView.m
//  mBSClient
//
//  Created by Maksim Voronin on 23.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "BaseSelectWidgetView.h"

static const double kButtonWidth = 44.0f;

@implementation BaseSelectWidgetView

-(void) constructContent
{
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.textLabel.autoresizesSubviews = NO;
    [self addSubview:self.textLabel];
    
    self.textField = [[UITextField alloc] init];
    self.textField.clearButtonMode = UITextFieldViewModeAlways;
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.translatesAutoresizingMaskIntoConstraints = NO;
    self.textField.autoresizesSubviews = NO;
    self.textField.delegate = self;
    [self addSubview:self.textField];
        
    _button = [[UIButton alloc] init];
    _button.backgroundColor = [UIColor colorWithRed:60.0/255.0 green:171.0/255.0 blue:255.0/255.0 alpha:1];
    _button.translatesAutoresizingMaskIntoConstraints = NO;
    _button.autoresizesSubviews = NO;
    [_button addTarget:self action:@selector(onBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_button];
}

#pragma mark constraints

-(void) setNewConstraints
{
    [self addTopBottomConstraintWithItem:self.textLabel toItem:self];
    [self addTopBottomConstraintWithItem:self.textField toItem:nil];
    [self addTopBottomConstraintWithItem:_button toItem:nil];
    
    if (self.labelVisible)
    {
        //ширина self.textField == textLabel
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textField attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.textLabel attribute:NSLayoutAttributeWidth multiplier:1.0f constant:-kButtonWidth]];
    }
    else
    {
        // ширина textLabel
        [self.textLabel addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0.0f]];
    }    
    // ширина _button
    [_button addConstraint:[NSLayoutConstraint constraintWithItem:_button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kButtonWidth]];
    //левая привязка textLabel
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:1.0]];
    //левая привязка textField
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.textField attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.textLabel attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:1.0]];
    //левая привязка _button
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_button attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.textField attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:1.0]];
    //правая привязка _button
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_button attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-1.0]];
}

#pragma mark actions

- (void) onBtnAction:(UIButton*)sender
{

}

#pragma mark UIPopoverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    if(_popover != nil)
    {
        [_popover dismissPopoverAnimated:YES];
        _popover = nil;
    }
}

@end
