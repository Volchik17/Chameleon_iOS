//
//  AddBankByURLForm.h
//  Chameleon
//
//  Created by Volchik on 12.12.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITaskHandler.h"

@interface AddBankByURLForm : UIViewController
{
    id<ITaskHandler> currentTask;
}
@property (nonatomic,readonly) BOOL visible;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITextField *urlEdit;
@property (weak, nonatomic) IBOutlet UITextField *bankIdEdit;
@end
