//
//  AddBankByURLForm.m
//  Chameleon
//
//  Created by Volchik on 12.12.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import "AddBankByURLForm.h"
#import "BSConnection.h"
#import "PingAnswer.h"
#import "PingRequest.h"
#import "SelectBankFromURLForm.h"
#import "Application.h"
#import "LocalBankInfoList.h"
#import "Bank.h"
#import "SimpleRequest.h"
#import "BankCardAnswer.h"

@implementation AddBankByURLForm

-(void) onAddButtonClick
{
    NSString* url=_urlEdit.text;
    if ([url length]==0)
        return;
    [self.view setUserInteractionEnabled:NO];
    [self.activityIndicator startAnimating];
    PingRequest* request=[[PingRequest alloc] init];
    __weak typeof(self) weakSelf=self;
    currentTask=[[BSConnection plainConnectionToURL:url] runRequest:request completionHandler:^(Answer* answer, NSError *error)
     {
         PingAnswer* ans=(PingAnswer*) answer;
         [self.view setUserInteractionEnabled:YES];
         [self.activityIndicator stopAnimating];
         typeof(self) form=weakSelf;
         if (!form)
             return;
         form->currentTask=nil;
         if (answer)
         {
             if (form.bankIdEdit.text.length>0)
             {
                 for (NSString* bankId in ans.banks)
                     if ([bankId caseInsensitiveCompare:form.bankIdEdit.text]==NSOrderedSame)
                     {
                         [form addBank:bankId url:form.urlEdit.text];
                         return;
                     }
                 NSString* title=NSLocalizedStringFromTable(@"BankNotFoundTitle", @"AddBankByURLFormStrings", @"");
                 NSString* message=NSLocalizedStringFromTable(@"BankWithIDNotFound", @"AddBankByURLFormStrings", @"");
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                 [alert show];
             } else
             {
                 if (ans.banks.count<=0)
                 {
                     //Банков вообще нету
                     NSString* title=NSLocalizedStringFromTable(@"BankNotFoundTitle", @"AddBankByURLFormStrings", @"");
                     NSString* message=NSLocalizedStringFromTable(@"NoBanksOnServer", @"AddBankByURLFormStrings", @"");
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                     [alert show];
                 } else if (ans.banks.count==1)
                 {
                     [form addBank:ans.banks[0] url:form.urlEdit.text];
                     return;
                 } else
                 {
                     SelectBankFromURLForm * selectForm=[[SelectBankFromURLForm alloc] initWithNibName:@"SelectBankFromURLForm" bundle:nil];
                     selectForm.modalPresentationStyle=UIModalPresentationCurrentContext;
                     selectForm.url=form.urlEdit.text;
                     selectForm.bankIds=ans.banks;
                     [self.navigationController pushViewController:selectForm animated:YES];
                 }
             }
         }
         else
         {
             // Ошибка обращения по url
             NSString* title=NSLocalizedStringFromTable(@"BankNotFoundTitle", @"AddBankByURLFormStrings", @"");
             NSString* message=NSLocalizedStringFromTable(@"UrlRequestError", @"AddBankByURLFormStrings", @"");
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
             [alert show];
         }
     }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _visible=NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _visible=YES;
    // Прячем индикацию запроса
    currentTask=nil;
    self.activityIndicator.hidesWhenStopped=YES;
    [self.activityIndicator stopAnimating];
    // Настраиваем кнопки в панели навигации
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        self.navigationItem.title=NSLocalizedStringFromTable(@"NavigationBarTitle_iPhone", @"AddBankByURLFormStrings", @"");
    }
    else
    {
        self.navigationItem.title=NSLocalizedStringFromTable(@"NavigationBarTitle", @"AddBankByURLFormStrings", @"");
    }
    NSString* addButtonTitle=NSLocalizedStringFromTable(@"AddButtonTitle", @"AddBankByURLFormStrings", @"");
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:addButtonTitle style:UIBarButtonItemStyleDone target:self action:@selector(onAddButtonClick)];
    self.navigationItem.rightBarButtonItem=addButton;
    NSString* backButtonTitle=NSLocalizedStringFromTable(@"BackButtonTitle", @"AddBankByURLFormStrings", @"");
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:backButtonTitle style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem=backButton;
    // Это чтобы компоненты не прятались под NavigationBar
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) disableForm
{
    _urlEdit.userInteractionEnabled=NO;
    _bankIdEdit.userInteractionEnabled=NO;
    self.navigationItem.rightBarButtonItem.enabled=NO;
}

-(void) enableForm
{
    _urlEdit.userInteractionEnabled=YES;
    _bankIdEdit.userInteractionEnabled=YES;
    self.navigationItem.rightBarButtonItem.enabled=YES;
}

-(void) addBank:(NSString*) bankId url:(NSString*) url
{
    if ([APP.getLocalBanks indexOfUrl:url bankId:bankId]!=NSNotFound)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"DuplicateBankAlert_Caption", @"AddBankByURLFormStrings", @"")
                                                        message:NSLocalizedStringFromTable(@"DuplicateBankAlert_Message", @"AddBankByURLFormStrings", @"")
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedStringFromTable(@"DuplicateBankAlert_CancelButton", @"AddBankByURLFormStrings", @"")
                                              otherButtonTitles: nil];
        [alert show];
        return;
    }
    id<IRequest> request=[[SimpleRequest alloc] initWithWithBankId:bankId answerClass:BankCardAnswer.class moduleType:@"BankCard" moduleName:@"" requestName:@"BankCard"];
    BSConnection* connection=[BSConnection plainConnectionToURL:url];
    __weak AddBankByURLForm* weakself=self;
    [_activityIndicator startAnimating];
    [self disableForm];
    [connection runRequest:request completionHandler:^(Answer* answer, NSError *error)
     {
         if (!weakself || !weakself.visible)
             return;
         if (answer)
         {
             BankCardAnswer* ans=(BankCardAnswer*)answer;
             [weakself.activityIndicator stopAnimating];
             NSUInteger bankIndex=[APP addLocalBankWithUrl:url bankId:bankId bankCard:(BankCard*)ans.entity];
             [self dismissViewControllerAnimated:YES completion:nil];
             [APP.rootController showLoginFormForBank:bankIndex];
         }
         else
         {
             [weakself.activityIndicator stopAnimating];
             [self enableForm];
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"NoServerResponseAlert_Caption", @"AddBankByURLFormStrings", @"")
                                                             message:NSLocalizedStringFromTable(@"NoServerResponseAlert_Message", @"AddBankByURLFormStrings", @"")
                                                            delegate:nil
                                                   cancelButtonTitle:NSLocalizedStringFromTable(@"NoServerResponseAlert_CancelButton", @"AddBankByURLFormStrings", @"")
                                                   otherButtonTitles: nil];
             [alert show];
             return;
         }
     }];
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
