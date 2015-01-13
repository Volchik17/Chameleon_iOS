//
//  BaseWidgetView.h
//  mBSClient
//
//  Created by Maksim Voronin on 23.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import <UIKit/UIKit.h>

extern double const kTextCommonFontSize;
extern double const kTextCommonBoldFontSize;
extern double const kTextAttentionFontSize;
extern double const kDefaultFontSize;

@class BaseWidgetDescription;
@class WidgetController;

@interface BaseWidgetView : UIView
@property(nonatomic,strong) UILabel* textLabel;
@property(nonatomic,strong) NSString* widgetId;
@property(nonatomic,strong) NSString* label;
@property(nonatomic,assign) BOOL enable;
@property(nonatomic,assign) BOOL visible;
@property(nonatomic,strong) NSString* widgetStyle;
@property(nonatomic,strong) NSString* widgetBackground;
@property(nonatomic,assign) double weight;
@property(nonatomic,assign) BOOL labelVisible;
@property(nonatomic,weak) WidgetController* controller;
-(id) initWithController:(WidgetController*)controller;
-(void) registerStaticAttributes:(BaseWidgetDescription *)structureWidget;
-(NSString*) getWidgetType;
-(void) onFieldChanged:(NSString*) fieldName;
-(void) setLabelVisible:(BOOL)labelVisible;
-(void) setLabel:(NSString*)label;
-(void) constructContent;
-(BOOL) isStableContent;
-(void) addTopBottomConstraintWithItem:(id)item toItem:(id)toItem;
-(void) setNewConstraints;
@end
