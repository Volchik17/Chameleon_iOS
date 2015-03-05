//
//  RootChameleonViewController.m
//  Chameleon
//
//  Created by Volchik on 12.01.15.
//  Copyright (c) 2015 Volchik. All rights reserved.
//

#import "RootChameleonViewController.h"
#import "Application.h"
#import "LocalBankInfoList.h"

@interface RootChameleonViewController ()

@end

@implementation RootChameleonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(NoBanksLoginForm*) getNoBanksLoginForm
{
    if (noBanksLoginForm==nil)
        noBanksLoginForm = [[NoBanksLoginForm alloc] initWithNibName:@"NoBanksLoginForm" bundle:nil];
    return noBanksLoginForm;
}

-(MainLoginForm*) getMainLoginForm
{
    if (mainLoginForm==nil)
        mainLoginForm=[[MainLoginForm alloc] initWithNibName:@"MainLoginForm" bundle:nil];
    return mainLoginForm;
}

-(void) showDefaultLoginForm
{
    if (APP.getLocalBanks.count<=0)
        [self showViewController:[self getNoBanksLoginForm]];
    else
    {
        MainLoginForm* form=[self getMainLoginForm];
        if (currentController==form)
            [form refreshPages];
        else
            [self showViewController:form];
    }
}

/*- (IBAction)switchViews:(id)sender
{
    
    if (self.yellowViewController == nil)
    {
        YellowViewController *yellowController = [[YellowViewController alloc]
                                                  initWithNibName:@"YellowView" bundle:nil];
        self.yellowViewController = yellowController;
    }
    
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:1.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    UIViewController *coming = nil;
    UIViewController *going = nil;
    UIViewAnimationTransition transition;
    
    if (self.blueViewController.view.superview == nil)
    {
        coming = blueViewController;
        going = yellowViewController;
        transition = UIViewAnimationTransitionFlipFromLeft;
    }
    else
    {
        coming = yellowViewController;
        going = blueViewController;
        transition = UIViewAnimationTransitionFlipFromRight;
    }
    
    [UIView setAnimationTransition: transition forView:self.view cache:YES];
    [coming viewWillAppear:YES];
    [going viewWillDisappear:YES];
    [going.view removeFromSuperview];
    [self.view insertSubview: coming.view atIndex:0];
    [going viewDidDisappear:YES];
    [coming viewDidAppear:YES];
    
    [UIView commitAnimations];
    
}*/

- (void)showViewController:(UIViewController *)newViewController {
    if (currentController!=nil)
    {
        [currentController removeFromParentViewController];
        [currentController.view removeFromSuperview];
        if (currentController==noBanksLoginForm)
            // Никогда не храним эту форму, так как вероятность ее повторного использования близка к нулю
            noBanksLoginForm=nil;
    }
    
    newViewController.view.frame = CGRectMake(
                                              0, 0, self.view.frame.size.width, self.view.frame.size.height
                                              );
    [self addChildViewController: newViewController];
    [self.view addSubview: newViewController.view];
    currentController=newViewController;
}

-(void) showLoginFormForBank:(NSInteger)bankIndex
{
    MainLoginForm* form=[self getMainLoginForm];
    if (currentController!=form)
       [self showViewController:form];
    [form refreshPages];
    [form showPageForBank:bankIndex];
}

-(void) showBankContentForm:(NSInteger)bankIndex
{
    
}

-(void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if (mainLoginForm!=nil && currentController!=mainLoginForm)
        mainLoginForm=nil;
}

@end
