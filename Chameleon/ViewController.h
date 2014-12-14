//
//  ViewController.h
//  Chameleon
//
//  Created by Volchik on 22.11.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ExtendedHitAreaViewContainer;

@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) UIScrollView* bankScrollView;
@property (strong, nonatomic) UIPageControl* pageControl;
@property (strong, nonatomic) ExtendedHitAreaViewContainer* bankScrollViewContainer;
@end

