//
//  NoBanksLoginForm.m
//  Chameleon
//
//  Created by Volchik on 30.11.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import "NoBanksLoginForm.h"
#import "GradientBackground.h"
#import "SelectAddBankForm.h"

@implementation NoBanksLoginForm

- (IBAction)demoButtonClick:(id)sender
{
}

- (IBAction)addBankButtonClick:(id)sender
{
    SelectAddBankForm* form=[[SelectAddBankForm alloc] initWithNibName:@"SelectAddBankForm" bundle:nil];
    UINavigationController* navigationController=[[UINavigationController alloc] initWithRootViewController:form];
    navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    navigationController.modalPresentationStyle=UIModalPresentationFormSheet;
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _backgroundView.startColor=[UIColor colorWithRed:125.0/255.0 green:165.0/255.0 blue:207.0/255.0 alpha:1.0];
    _backgroundView.endColor = [UIColor colorWithRed:96.0/255.0 green:96.0/255.0 blue:122.0/255.0 alpha:1.0];
    _backgroundView.directionX=1;
    _backgroundView.directionY=1;
    
    _demoButton.layer.cornerRadius = 4;
    _addBankButton.layer.cornerRadius = 4;
    _demoButton.layer.borderWidth = 1;
    _demoButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [self autoAlignButtons];
}

-(void) autoAlignButtons {
    // Центрируем две кнопки внизу с учетом их размеров
    // Расстояние между кнопками
    float buttonSpace=70;
    // Размеры кнопок
    float w1=[_addBankButton intrinsicContentSize].width;
    float w2=[_demoButton intrinsicContentSize].width;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_addBankButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_addBankButton.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:-(w2+buttonSpace)/2]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_demoButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_demoButton.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:(w1+buttonSpace)/2]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
