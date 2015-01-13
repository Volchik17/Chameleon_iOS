//
//  BaseSelectWidgetView.h
//  mBSClient
//
//  Created by Maksim Voronin on 23.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "EditableTextWidgetView.h"

@interface BaseSelectWidgetView : EditableTextWidgetView <UIPopoverControllerDelegate>
@property(nonatomic,strong) UIPopoverController *popover;
@property(nonatomic,strong) UIButton* button;
@end
