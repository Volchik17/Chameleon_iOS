//
//  AddBankByURLForm.m
//  Chameleon
//
//  Created by Volchik on 12.12.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import "AddBankByURLForm.h"

@interface AddBankByURLForm ()

@end

@implementation AddBankByURLForm

-(void) onAddButtonClick
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    // Это чтобы компоненты не прятались под NavigationBar
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
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
