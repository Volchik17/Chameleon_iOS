//
//  BankAddressForm.h
//  Chameleon
//
//  Created by Volchik on 24.01.15.
//  Copyright (c) 2015 Volchik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITaskHandler.h"
#import "LocalBankInfo.h"

@interface BankAddressForm : UIViewController
{
    id<ITaskHandler> currentTask;
    LocalBankInfo* _bank;
}

@property (nonatomic,assign) NSUInteger bankIndex;
@property (nonatomic,readonly) BOOL visible;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *urlEdit;

@end
