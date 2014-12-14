//
//  GradientBackground.h
//  Chameleon
//
//  Created by Volchik on 30.11.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GradientBackground : UIView

@property (nonatomic,strong) UIColor* startColor;
@property (nonatomic,strong) UIColor* endColor;
@property (nonatomic,assign) int directionX;
@property (nonatomic,assign) int directionY;

@end
