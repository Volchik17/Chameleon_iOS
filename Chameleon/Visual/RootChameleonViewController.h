//
//  RootChameleonViewController.h
//  Chameleon
//
//  Created by Volchik on 12.01.15.
//  Copyright (c) 2015 Volchik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bank.h"
#import "NoBanksLoginForm.h"
#import "MainLoginForm.h"

@interface RootChameleonViewController : UIViewController
{
    NoBanksLoginForm* noBanksLoginForm;
    MainLoginForm* mainLoginForm;
    UIViewController* currentController;
}

-(void) showDefaultLoginForm;
-(void) showLoginFormForBank:(NSInteger)bankIndex;
-(void) showBankContentForm:(NSInteger)bankIndex;

@end
