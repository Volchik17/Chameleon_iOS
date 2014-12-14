//
//  NoBanksLoginForm.h
//  Chameleon
//
//  Created by Volchik on 30.11.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GradientBackground;

@interface NoBanksLoginForm : UIViewController

@property (weak, nonatomic) IBOutlet GradientBackground *backgroundView;
@property (weak, nonatomic) IBOutlet UIButton *addBankButton;
@property (weak, nonatomic) IBOutlet UIButton *demoButton;

@end
