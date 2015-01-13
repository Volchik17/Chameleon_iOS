//
//  MainLoginForm.h
//  Chameleon
//
//  Created by Volchik on 10.01.15.
//  Copyright (c) 2015 Volchik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GradientBackground.h"
#import "ExtendedHitAreaViewContainer.h"
#import "ResizeAwareView.h"
#import "Bank.h"

@interface MainLoginForm : UIViewController<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet GradientBackground *gradientBackground;
@property (weak, nonatomic) IBOutlet ResizeAwareView *mainView;

@property (strong, nonatomic) UIScrollView* bankScrollView;
@property (strong, nonatomic) UIPageControl* pageControl;
@property (strong, nonatomic) ExtendedHitAreaViewContainer* bankScrollViewContainer;
- (IBAction)onAddUrlClick:(id)sender;
- (IBAction)onDeleteUrlClick:(id)sender;

-(void) refreshPages;
-(void) showPageForBank:(Bank*) bank;

@end
