//
//  AddBankByURLForm.h
//  Chameleon
//
//  Created by Volchik on 12.12.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddBankByURLForm : UIViewController
{
    NSURLSessionTask* currentTask;
}
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITextField *urlEdit;
@property (weak, nonatomic) IBOutlet UITextField *bankIdEdit;
@end
