//
//  SelectAddBankForm.m
//  Chameleon
//
//  Created by Volchik on 03.12.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import "SelectAddBankForm.h"
#import "GradientBackground.h"
#import "BSConnection.h"
#import "BankListFromCatalogRequest.h"
#import "BankListFromCatalogAnswer.h"
#import "CatalogBankInfo.h"
#import "BankImageFromCatalogRequest.h"
#import "BankImageFromCatalogAnswer.h"
#import "Application.h"
#import "AddBankByURLForm.h"
#import "BankList.h"
#import "MainLoginForm.h"

@interface SelectBankInfo:NSObject

@property (nonatomic,strong) CatalogBankInfo* bank;
@property (nonatomic,strong) UIImage* image;
@property (nonatomic,assign) BOOL isImageLoading;

@end

@implementation SelectBankInfo

@end

@implementation BanksDataSource

-(instancetype)initForTableView:(UITableView *)tableView
{
    self=[super init];
    if (self)
    {
        _tableView=tableView;
        _filteredBanks=[[NSMutableArray alloc] init];
    }
    return self;
}

-(void) recalcFilter
{
    [_filteredBanks removeAllObjects];
    if (!_banks)
        return;
    for(SelectBankInfo* bank in _banks)
    {
        if (_filterString==nil || [_filterString isEqualToString:@""] || [[bank.bank.name uppercaseString] containsString:[_filterString uppercaseString]])
            [_filteredBanks addObject:bank];
    }
}

-(void) setFilterString:(NSString *)filterString
{
    _filterString=filterString;
    [self recalcFilter];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _filteredBanks.count;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(SelectBankInfo*) findBank:(NSString*)bankId
{
    for(SelectBankInfo* bank in _banks)
        if ([bank.bank.catalogBankId isEqualToString:bankId])
            return bank;
    return nil;
}

-(void)loadBankImage:(SelectBankInfo*) bank
{
    bank.isImageLoading=true;
    BankImageFromCatalogRequest* request=[[BankImageFromCatalogRequest alloc] initWithId:bank.bank.catalogBankId];
    __weak BanksDataSource* weakSelf=self;
    __weak NSString* bankId=bank.bank.catalogBankId;
    [APP.bankCatalogConnection runRequest:request completionHandler:^(Answer* answer, NSError *error)
     {
         if (answer)
         {
             BankImageFromCatalogAnswer* ans=(BankImageFromCatalogAnswer*)answer;
             SelectBankInfo* bank=[weakSelf findBank:bankId];
             if (!bank)
                 return;
             bank.image=[[UIImage alloc] initWithData:ans.imageData];
             NSUInteger index=[_filteredBanks indexOfObject:bank];
             if (index!=NSNotFound)
                 [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
         }
     }];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<0 || indexPath.row>=_filteredBanks.count)
        return nil;
    SelectBankInfo* bank=[_filteredBanks objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell.
    for (UIView* subview in cell.contentView.subviews)
        [subview removeFromSuperview];
    
    UILabel* label=[[UILabel alloc] init];
    [cell.contentView addSubview:label];
    label.text=bank.bank.name;
    label.frame=CGRectMake(110,5,500,45);
    label.bounds=CGRectMake(110,5,500,45);
    label.font=[label.font fontWithSize:14];
    if (bank.image)
    {
        UIImageView* imageView=[[UIImageView alloc] initWithImage:bank.image];
        [cell.contentView addSubview:imageView];
        imageView.frame=CGRectMake(5,5,90,40);
        imageView.bounds=CGRectMake(5,5,90,40);
        imageView.contentMode=UIViewContentModeScaleAspectFit;
    }
    else if (!bank.isImageLoading)
    {
        [self loadBankImage:bank];
    }
    return cell;
}

@end

@implementation SelectAddBankForm

- (void)onCancelButtonClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onConnectByURLButtonClick
{
    AddBankByURLForm * form=[[AddBankByURLForm alloc] initWithNibName:@"AddBankByURLForm" bundle:nil];
    form.modalPresentationStyle=UIModalPresentationCurrentContext;
    [self.navigationController pushViewController:form animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Задаем кнопочки на панели навигации
    NSString* connectByURLButtonTitle;
    NSString* backButtonTitle;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        self.navigationItem.title=NSLocalizedStringFromTable(@"NavigationBarTitle_iPhone", @"SelectAddBankFormStrings", @"");
        connectByURLButtonTitle=NSLocalizedStringFromTable(@"ConnectByURLButtonTitle_iPhone", @"SelectAddBankFormStrings", @"");
        backButtonTitle=NSLocalizedStringFromTable(@"BackButtonTitle_iPhone", @"SelectAddBankFormStrings", @"");
    }
    else
    {
        self.navigationItem.title=NSLocalizedStringFromTable(@"NavigationBarTitle", @"SelectAddBankFormStrings", @"");
        connectByURLButtonTitle=NSLocalizedStringFromTable(@"ConnectByURLButtonTitle", @"SelectAddBankFormStrings", @"");
        backButtonTitle=NSLocalizedStringFromTable(@"BackButtonTitle", @"SelectAddBankFormStrings", @"");
    }
    NSString* cancelButtonTitle=NSLocalizedStringFromTable(@"CancelButtonTitle", @"SelectAddBankFormStrings", @"");
    UIBarButtonItem *urlButton = [[UIBarButtonItem alloc] initWithTitle:connectByURLButtonTitle style:UIBarButtonItemStyleDone target:self action:@selector(onConnectByURLButtonClick)];
    self.navigationItem.rightBarButtonItem=urlButton;
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:cancelButtonTitle style:UIBarButtonItemStyleDone target:self action:@selector(onCancelButtonClick)];
    self.navigationItem.leftBarButtonItem=cancelButton;
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:backButtonTitle style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem=backButton;
    // Это чтобы компоненты не прятались под NavigationBar
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    // Конфигурим список банков
    _banksDataSource=[[BanksDataSource alloc] initForTableView:_banksTableView];
    _banksTableView.dataSource=_banksDataSource;
    _banksTableView.delegate=self;
    _banksTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // Запускаем запрос списка банков
    _errorLabel.hidden=true;
    [_activityIndicator startAnimating];
    Request* request=[[BankListFromCatalogRequest alloc] init];
    __weak SelectAddBankForm* weakself=self;
    [APP.bankCatalogConnection runRequest:request completionHandler:^(Answer* answer, NSError *error)
     {
        if (answer)
        {
            BankListFromCatalogAnswer* ans=(BankListFromCatalogAnswer*)answer;
            NSMutableArray* banks=[[NSMutableArray alloc] initWithCapacity:ans.banks.count];
            for (CatalogBankInfo* bank in ans.banks)
            {
                SelectBankInfo* bankInfo=[[SelectBankInfo alloc] init];
                bankInfo.bank=bank;
                bankInfo.isImageLoading=false;
                [banks addObject:bankInfo];
            }
            weakself.banksDataSource.banks=banks;
            weakself.banksDataSource.filterString=_searchBar.text;
            _searchBar.delegate=weakself;
            [weakself.banksTableView reloadData];
            [weakself.activityIndicator stopAnimating];
        }
        else
        {
            _errorLabel.frame=_banksTableView.frame;
            _errorLabel.bounds=_banksTableView.bounds;
            _errorLabel.hidden=false;
            _banksTableView.hidden=true;
            [weakself.activityIndicator stopAnimating];
        }
     }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    _banksDataSource.filterString=searchBar.text;
    [_banksTableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectBankInfo* bank=[_banksDataSource.filteredBanks objectAtIndex:indexPath.row];
    Bank* newBank=[APP.banks addBankWithUrl:bank.bank.url bankId:bank.bank.bankId];
    [self dismissViewControllerAnimated:YES completion:nil];
    [APP.rootController showLoginFormForBank:newBank];
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
