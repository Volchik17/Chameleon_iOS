//
//  ExtendedHitAreaViewContainer.m
//  Chameleon
//
//  Created by Volchik on 26.11.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import "ExtendedHitAreaViewContainer.h"

@implementation ExtendedHitAreaViewContainer

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if ([self pointInside:point withEvent:event]) {
        if ([[self subviews] count] > 0) {
            //force return of first child, if exists
            return [[self subviews] objectAtIndex:0];
        } else {
            return self;
        }
    }
    return nil;
}

@end
