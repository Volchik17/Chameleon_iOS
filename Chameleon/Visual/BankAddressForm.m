//
//  BankAddressForm.m
//  Chameleon
//
//  Created by Volchik on 24.01.15.
//  Copyright (c) 2015 Volchik. All rights reserved.
//

#import "BankAddressForm.h"
#import "LocalBankInfo.h"
#import "Application.h"
#import "SimpleRequest.h"
#import "BankCardAnswer.h"
#import "BSConnection.h"

@implementation BankAddressForm

- (void)viewDidLoad {
    [super viewDidLoad];
    _visible=YES;
    _bank=[APP getLocalBankByIndex:_bankIndex];
    _bankNameLabel.text=_bank.bankCard.bankName;
    _urlEdit.text=_bank.url;
    // Прячем индикацию запроса
    currentTask=nil;
    self.activityIndicator.hidesWhenStopped=YES;
    [self.activityIndicator stopAnimating];
    // Настраиваем кнопки в панели навигации
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        self.navigationItem.title=NSLocalizedStringFromTable(@"NavigationBarTitle_iPhone", @"BankAddressFormStrings", @"");
    }
    else
    {
        self.navigationItem.title=NSLocalizedStringFromTable(@"NavigationBarTitle", @"BankAddressFormStrings", @"");
    }
    NSString* saveButtonTitle=NSLocalizedStringFromTable(@"SaveButtonTitle", @"BankAddressFormStrings", @"");
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:saveButtonTitle style:UIBarButtonItemStyleDone target:self action:@selector(onSaveButtonClick)];
    self.navigationItem.rightBarButtonItem=saveButton;
    NSString* cancelButtonTitle=NSLocalizedStringFromTable(@"CancelButtonTitle", @"BankAddressFormStrings", @"");
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:cancelButtonTitle style:UIBarButtonItemStyleDone target:self action:@selector(onCancelButtonClick)];
    self.navigationItem.leftBarButtonItem=cancelButton;
    // Это чтобы компоненты не прятались под NavigationBar
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
}

-(void) disableForm
{
    _urlEdit.userInteractionEnabled=NO;
    self.navigationItem.rightBarButtonItem.enabled=NO;
}

-(void) enableForm
{
    _urlEdit.userInteractionEnabled=YES;
    self.navigationItem.rightBarButtonItem.enabled=YES;
}

-(void) onSaveButtonClick
{
    NSString* url=_urlEdit.text;
    for (LocalBankInfo* bank in APP.getLocalBanks)
        if (bank.bankIndex!=_bankIndex && [bank.bankId isEqualToString:_bank.bankId] && [[bank.url uppercaseString] isEqualToString:[url uppercaseString]])
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"DuplicateBankAlert_Caption", @"BankAddressFormStrings", @"")
                                                            message:NSLocalizedStringFromTable(@"DuplicateBankAlert_Message", @"BankAddressFormStrings", @"")
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedStringFromTable(@"DuplicateBankAlert_CancelButton", @"BankAddressFormStrings", @"")
                                                  otherButtonTitles: nil];
            [alert show];
            return;
        }
    id<IRequest> request=[[SimpleRequest alloc] initWithWithBankId:_bank.bankId answerClass:BankCardAnswer.class moduleType:@"BankCard" moduleName:@"" requestName:@"BankCard"];
    BSConnection* connection=[BSConnection plainConnectionToURL:url];
    __weak BankAddressForm* weakself=self;
    [_activityIndicator startAnimating];
    [self disableForm];
    [connection runRequest:request completionHandler:^(Answer* answer, NSError *error)
     {
         if (!weakself || !weakself.visible)
             return;
         if (answer)
         {
             [weakself.activityIndicator stopAnimating];
             [APP updateLocalBankUrl:weakself.bankIndex url:url];
             [self dismissViewControllerAnimated:YES completion:nil];
             [APP.rootController showLoginFormForBank:weakself.bankIndex];
         }
         else
         {
             [weakself.activityIndicator stopAnimating];
             [self enableForm];
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"NoServerResponseAlert_Caption", @"BankAddressFormStrings", @"")
                                                             message:NSLocalizedStringFromTable(@"NoServerResponseAlert_Message", @"BankAddressFormStrings", @"")
                                                            delegate:nil
                                                   cancelButtonTitle:NSLocalizedStringFromTable(@"NoServerResponseAlert_CancelButton", @"BankAddressFormStrings", @"")
                                                   otherButtonTitles: nil];
             [alert show];
             return;
         }
     }];
    
}

-(void) onCancelButtonClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
