//
//  DynamicGroupView.h
//  mBSClient
//
//  Created by Maksim Voronin on 27.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIView.h>

@class WidgetController;
@interface DynamicGroupView : UIView
@property(nonatomic,weak) WidgetController* controller;
@property(nonatomic,strong) NSMutableArray* widgets; // BaseWidgetView
@property(nonatomic,strong) NSMutableArray* widgetsView;
- (id)initWithViewController:(WidgetController*)controller;
- (void)startView;
@end
