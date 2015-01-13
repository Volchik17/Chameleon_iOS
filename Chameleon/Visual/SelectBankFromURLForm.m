//
//  SelectBankFromURLForm.m
//  Chameleon
//
//  Created by Volchik on 16.12.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import "SelectBankFromURLForm.h"
#import "BankCard.h"
#import "BankSelectCellDescription.h"
#import "ResourceRequest.h"
#import "ResourceAnswer.h"
#import "MetadataRequest.h"
#import "MetadataAnswer.h"
#import "Application.h"
#import "DynamicGroupView.h"
#import "WidgetController.h"
#import "CustomRecord.h"
#import "SimpleRequest.h"
#import "FullRecordAnswer.h"
#import "BankList.h"

@interface SubBankItem:NSObject
@property (nonatomic,strong) NSString* bankId;
@property (nonatomic,assign) BOOL isStructureLoading;
@property (nonatomic,strong) CustomRecord* bankCard;
@property (nonatomic,assign) BOOL isBankCardLoading;
@property (nonatomic,strong) BankSelectCellDescription* cellDescription;
@property (nonatomic,assign) BOOL isImageLoading;
@property (nonatomic,strong) UIImage* image;
@end

@implementation SubBankItem

@end

@interface SubBanksDataSource : NSObject<UITableViewDataSource>
-(instancetype) initForTableView:(UITableView*) tableView banks:(NSMutableArray*) banks url:(NSString*)url;
@property (nonatomic,weak) UITableView* tableView;
@property (nonatomic,strong) NSMutableArray* banks;
@property (nonatomic,strong) NSString* url;
@end

@implementation SubBanksDataSource

-(instancetype)initForTableView:(UITableView *)tableView banks:(NSMutableArray*) banks url:(NSString*)url;
{
    self=[super init];
    if (self)
    {
        _tableView = tableView;
        _banks = banks;
        _url=url;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _banks.count;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(SubBankItem*) findBank:(NSString*) bankId
{
    for(SubBankItem* bank in _banks)
        if ([bank.bankId isEqualToString:bankId])
            return bank;
    return nil;
}

-(void)loadBankImage:(SubBankItem*) bank
{
    bank.isImageLoading=true;
    ResourceRequest* request=[[ResourceRequest alloc] initWithBankId:bank.bankId moduleType:@"bankCard" moduleName:@"" resourceName:bank.cellDescription.image savedHash:@""];
    __weak SubBanksDataSource* weakSelf=self;
    __weak NSString* bankId=bank.bankId;
    BSConnection* connection=[BSConnection plainConnectionToURL:_url];
    [connection runRequest:request completionHandler:^(Answer* answer, NSError *error)
    {
        if (answer)
        {
            ResourceAnswer* ans=(ResourceAnswer*)answer;
            SubBankItem* bank=[weakSelf findBank:bankId];
            if (!bank)
                return;
            bank.image=[[UIImage alloc] initWithData:ans.data];
            NSUInteger index=[weakSelf.banks indexOfObject:bank];
            if (index!=NSNotFound)
                [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}

-(void) loadCellDescription:(SubBankItem*)bank
{
    // Запрашиваем метаданные напрямую, а не через MetadataManager, так как банк еще не находится в списке банков
    bank.isStructureLoading=true;
    MetadataRequest* request=[[MetadataRequest alloc] initWithBankId:bank.bankId moduleType:@"BankCard" moduleName:@"" structureName:@"selectCell" savedHash:@"" localeName:APP.currentLocaleId];
    __weak SubBanksDataSource* weakSelf=self;
    __weak NSString* bankId=bank.bankId;
    BSConnection* connection=[BSConnection plainConnectionToURL:_url];
    [connection runRequest:request completionHandler:^(Answer* answer, NSError *error)
     {
         if (answer)
         {
             MetadataAnswer* ans=(MetadataAnswer*)answer;
             SubBankItem* bank=[weakSelf findBank:bankId];
             if (!bank)
                 return;
             bank.cellDescription=[[BankSelectCellDescription alloc] init];
             NSError* error=[bank.cellDescription parseFromData:ans.data];
             if (error==nil)
             {
                 NSUInteger index=[weakSelf.banks indexOfObject:bank];
                 if (index!=NSNotFound)
                     [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
             }
         }
     }];
}

-(void) loadBankCard:(SubBankItem*)bank
{
    bank.isBankCardLoading=true;
    SimpleRequest* request=[[SimpleRequest alloc] initWithWithBankId:bank.bankId answerClass:FullRecordAnswer.class moduleType:@"BankCard" moduleName:@"" requestName:@"BankCard"];
    __weak SubBanksDataSource* weakSelf=self;
    __weak NSString* bankId=bank.bankId;
    BSConnection* connection=[BSConnection plainConnectionToURL:_url];
    [connection runRequest:request completionHandler:^(Answer* answer, NSError *error)
     {
         if (answer)
         {
             FullRecordAnswer* ans=(FullRecordAnswer*)answer;
             SubBankItem* bank=[weakSelf findBank:bankId];
             if (!bank)
                 return;
             bank.bankCard=ans.record;
             NSUInteger index=[weakSelf.banks indexOfObject:bank];
             if (index!=NSNotFound)
                 [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
         }
     }];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<0 || indexPath.row>=_banks.count)
        return nil;
    SubBankItem* bank=[_banks objectAtIndex:indexPath.row];
    
    NSString* CellIdentifier = bank.bankId;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell.
    for (UIView* subview in cell.contentView.subviews)
        [subview removeFromSuperview];
    
    if (bank.cellDescription==nil && !bank.isStructureLoading)
    {
        [self loadCellDescription:bank];
    }
    if (bank.bankCard==nil && !bank.isBankCardLoading)
    {
        [self loadBankCard:bank];
    }
    if (bank.image==nil && bank.cellDescription!=nil &&
        bank.cellDescription.image!=nil && bank.cellDescription.image.length>0 &&
        !bank.isImageLoading)
    {
        [self loadBankImage:bank];
    }
    UIImageView* imageView;
    if (bank.image)
    {
        imageView=[[UIImageView alloc] initWithImage:bank.image];
        [cell.contentView addSubview:imageView];
        imageView.frame=CGRectMake(5,5,90,40);
        imageView.bounds=CGRectMake(5,5,90,40);
        imageView.contentMode=UIViewContentModeScaleAspectFit;
    }
    if (bank.cellDescription!=nil && bank.bankCard!=nil)
    {
        WidgetController* controller=[[WidgetController alloc] initWithBankId:bank.bankId record:bank.bankCard extraFields:nil viewStructure:bank.cellDescription.view];
        DynamicGroupView* panel=[[DynamicGroupView alloc] initWithViewController:controller];
        [cell.contentView addSubview:panel];
        [panel startView];
        if (imageView!=nil)
        {
            [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:panel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:10]];
        }
    }
    return cell;
}

@end

@implementation SelectBankFromURLForm

SubBanksDataSource* _banksDataSource;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Прячем индикацию запроса
    //currentTask=nil;
    //self.activityIndicator.hidesWhenStopped=YES;
    //[self.activityIndicator stopAnimating];
    /*// Настраиваем кнопки в панели навигации
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        self.navigationItem.title=NSLocalizedStringFromTable(@"NavigationBarTitle_iPhone", @"SelectBankFromURLFormStrings", @"");
    }
    else
    {
        self.navigationItem.title=NSLocalizedStringFromTable(@"NavigationBarTitle", @"SelectBankFromURLFormStrings", @"");
    }*/
    // Это чтобы компоненты не прятались под NavigationBar
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    // Конфигурим список банков
    NSMutableArray* banks=[[NSMutableArray alloc] initWithCapacity:_bankIds.count];
    for (NSString* bankId in _bankIds)
    {
        SubBankItem* item=[[SubBankItem alloc] init];
        item.bankId=bankId;
        item.isStructureLoading=NO;
        item.bankCard=nil;
        item.isBankCardLoading=NO;
        item.cellDescription=nil;
        item.image=nil;
        item.isImageLoading=NO;
        [banks addObject:item];
    }
    _banksDataSource=[[SubBanksDataSource alloc] initForTableView:_banksTableView banks:banks url:_url];
    _banksTableView.dataSource=_banksDataSource;
    _banksTableView.delegate=self;
    _banksTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SubBankItem* bank=[_banksDataSource.banks objectAtIndex:indexPath.row];
    Bank* newBank=[APP.banks addBankWithUrl:_url bankId:bank.bankId];
    [self dismissViewControllerAnimated:YES completion:nil];
    [APP.rootController showLoginFormForBank:newBank];
}

@end
