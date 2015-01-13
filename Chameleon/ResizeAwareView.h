//
//  ResizeAwareView.h
//  Chameleon
//
//  Created by Volchik on 11.01.15.
//  Copyright (c) 2015 Volchik. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ResizeAwareView;

typedef void(^OnResize)(ResizeAwareView* sender);

@interface ResizeAwareView : UIView

@property (nonatomic,strong) OnResize onResize;

@end
