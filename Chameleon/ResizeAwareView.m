//
//  ResizeAwareView.m
//  Chameleon
//
//  Created by Volchik on 11.01.15.
//  Copyright (c) 2015 Volchik. All rights reserved.
//

#import "ResizeAwareView.h"

@implementation ResizeAwareView

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_onResize!=nil)
        _onResize(self);
}

@end
