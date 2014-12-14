//
//  GradientBackground.m
//  Chameleon
//
//  Created by Volchik on 30.11.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import "GradientBackground.h"

@implementation GradientBackground

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.startColor=[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        self.endColor = [UIColor colorWithRed:20.0/255.0 green:20.0/255.0 blue:230.0/255.0 alpha:1.0];
        self.directionX = 0;
        self.directionY = -1;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.startColor=[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        self.endColor = [UIColor colorWithRed:20.0/255.0 green:20.0/255.0 blue:230.0/255.0 alpha:1.0];
        self.directionX = 0;
        self.directionY = -1;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) self.startColor.CGColor, (__bridge id) self.endColor.CGColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    CGFloat startX,startY,endX,endY;
    if (_directionX<0)
    {
        startX=CGRectGetMaxX(rect);
        endX=CGRectGetMinX(rect);
    }
    else if (_directionX>0)
    {
        startX=CGRectGetMinX(rect);
        endX=CGRectGetMaxX(rect);
    }
    else
    {
        startX=CGRectGetMidX(rect);
        endX=CGRectGetMidX(rect);
    }
    if (_directionY<0)
    {
        startY=CGRectGetMaxY(rect);
        endY=CGRectGetMinY(rect);
    }
    else if (_directionY>0)
    {
        startY=CGRectGetMinY(rect);
        endY=CGRectGetMaxY(rect);
    }
    else
    {
        startY=CGRectGetMidY(rect);
        endY=CGRectGetMidY(rect);
    }
    CGPoint startPoint = CGPointMake(startX,startY);
    CGPoint endPoint = CGPointMake(endX,endY);
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);}


@end
