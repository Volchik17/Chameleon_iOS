//
//  SelectBankFromURLForm.m
//  Chameleon
//
//  Created by Volchik on 16.12.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import "SelectBankFromURLForm.h"
#import "BankCard.h"

@interface BankInfo:NSObject

@property (nonatomic,strong) BankCard* bank;
@property (nonatomic,strong) UIImage* image;
@property (nonatomic,assign) BOOL isImageLoading;

@end

@implementation BankInfo

@end

@interface BanksDataSource : NSObject<UITableViewDataSource>
-(instancetype) initForTableView:(UITableView*) tableView;
@property (nonatomic,weak) UITableView* tableView;
@property (nonatomic,strong) NSMutableArray* banks;
@end

@implementation BanksDataSource

-(instancetype)initForTableView:(UITableView *)tableView
{
    self=[super init];
    if (self)
    {
        _tableView=tableView;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _banks.count;
}

-(int) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)loadBankImage:(BankInfo*) bank
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
             BankInfo* bank=[weakSelf findBank:bankId];
             if (!bank)
                 return;
             bank.image=[[UIImage alloc] initWithData:ans.imageData];
             int index=[filteredBanks indexOfObject:bank];
             if (index>=0)
                 [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
         }
     }];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<0 || indexPath.row>=_banks.count)
        return nil;
    BankInfo* bank=[_banks objectAtIndex:indexPath.row];
    
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

@implementation SelectBankFromURLForm

BanksDataSource* _banksDataSource;

- (void)onAddButtonClick
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Прячем индикацию запроса
    //currentTask=nil;
    //self.activityIndicator.hidesWhenStopped=YES;
    //[self.activityIndicator stopAnimating];
    // Настраиваем кнопки в панели навигации
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        self.navigationItem.title=NSLocalizedStringFromTable(@"NavigationBarTitle_iPhone", @"SelectBankFromURLFormStrings", @"");
    }
    else
    {
        self.navigationItem.title=NSLocalizedStringFromTable(@"NavigationBarTitle", @"SelectBankFromURLFormStrings", @"");
    }
    NSString* addButtonTitle=NSLocalizedStringFromTable(@"AddButtonTitle", @"SelectBankFromURLFormStrings", @"");
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:addButtonTitle style:UIBarButtonItemStyleDone target:self action:@selector(onAddButtonClick)];
    self.navigationItem.rightBarButtonItem=addButton;
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
                 BankInfo* bankInfo=[[BankInfo alloc] init];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
