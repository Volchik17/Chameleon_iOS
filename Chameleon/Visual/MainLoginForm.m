//
//  MainLoginForm.m
//  Chameleon
//
//  Created by Volchik on 10.01.15.
//  Copyright (c) 2015 Volchik. All rights reserved.
//

#import "MainLoginForm.h"
#import "Application.h"
#import "LocalBankInfoList.h"
#import "ExtendedHitAreaViewContainer.h"
#import "ResizeAwareView.h"
#import "SelectAddBankForm.h"
#import "BankCardViewController.h"
#import "BankAddressForm.h"

#define PAGE_CONTROL_HEIGHT 24.0
#define MAX_BANK_CARD_WIDTH 550.0
#define MAX_BANK_CARD_HEIGHT 800.0
#define PAGE_DISTANCE 50.0
#define PAGE_OVERLAP 50.0

@interface BankLoginPageItem:NSObject
@property (nonatomic,assign) NSInteger bankIndex;
@property (nonatomic,strong) BankCardViewController* controller;
@end

@implementation BankLoginPageItem

@end

@implementation MainLoginForm
{
    NSMutableArray* pages;
    CGFloat pageWidth;
    CGFloat pageHeight;
    CGFloat pageDistance;
    CGFloat pageOverlap;
    CGFloat pageControlHeight;
}

-(instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        pages=[[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // background
    _gradientBackground.startColor=[UIColor colorWithRed:125.0/255.0 green:165.0/255.0 blue:207.0/255.0 alpha:1.0];
    _gradientBackground.endColor = [UIColor colorWithRed:96.0/255.0 green:96.0/255.0 blue:122.0/255.0 alpha:1.0];
    _gradientBackground.directionX=1;
    _gradientBackground.directionY=1;
    // page control
    self.pageControl=[[UIPageControl alloc] init];
    self.pageControl.hidesForSinglePage=YES;
    [_mainView addSubview:self.pageControl];
    [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    // page scroller
    self.bankScrollViewContainer=[[ExtendedHitAreaViewContainer alloc] init];
    self.bankScrollViewContainer.clipsToBounds=YES;
    self.bankScrollView = [[UIScrollView alloc] init];
    self.bankScrollView.clipsToBounds = NO;
    self.bankScrollView.pagingEnabled = YES;
    self.bankScrollView.showsHorizontalScrollIndicator = NO;
    self.bankScrollView.delegate=self;
    [_mainView addSubview:self.bankScrollViewContainer];
    [self.bankScrollViewContainer addSubview:self.bankScrollView];
    // register for resizing
     __weak MainLoginForm* weakSelf=self;
    _mainView.onResize=^(ResizeAwareView* sender){
        [weakSelf onMainViewResize:sender];
    };
    [self refreshPages];
}

- (IBAction)changePage:(id)sender
{
    CGFloat x = self.pageControl.currentPage * self.bankScrollView.frame.size.width;
    [self.bankScrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView  {
    NSInteger pageNumber = roundf(scrollView.contentOffset.x / (scrollView.frame.size.width));
    self.pageControl.currentPage = pageNumber;
}

-(void) refreshPages
{
    NSArray* banks=APP.getLocalBanks;
    // Удаляем лишние страницы
    for (int i=pages.count-1;i>=0;i--)
    {
        BankLoginPageItem* page=[pages objectAtIndex:i];
        if ([banks getByIndex:page.bankIndex]==nil)
        {
            [page.controller.view removeFromSuperview];
            [page.controller removeFromParentViewController];
            [pages removeObjectAtIndex:i];
        }
    }
    // Добавляем отсутствующие
    for (Bank* bank in banks)
    {
        NSUInteger index=NSNotFound;
        for (NSUInteger i=0;i<pages.count;i++)
        {
            BankLoginPageItem* page=[pages objectAtIndex:i];
            if (page.bankIndex==bank.bankIndex)
            {
                index=i;
                break;
            }
        }
        if (index==NSNotFound)
        {
            BankLoginPageItem* page=[[BankLoginPageItem alloc] init];
            page.controller=[[BankCardViewController alloc] initWithBankIndex:bank.bankIndex];
            [self addChildViewController:page.controller];
            page.bankIndex=bank.bankIndex;
            [pages addObject:page];
        }
    }
    self.pageControl.numberOfPages=pages.count;
    for (int i = 0; i < pages.count; i++)
    {
        BankLoginPageItem* page=[pages objectAtIndex:i];
        [self.bankScrollView addSubview:page.controller.view];
    }
    [self onMainViewResize:_mainView];
}

-(void) showPageForBank:(NSInteger)bankIndex
{
    for(BankLoginPageItem* page in pages)
        if (page.bankIndex==bankIndex)
        {
            self.pageControl.currentPage=[pages indexOfObject:page];
            CGFloat x = self.pageControl.currentPage * self.bankScrollView.frame.size.width;
            [self.bankScrollView setContentOffset:CGPointMake(x, 0) animated:YES];
        }
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self onMainViewResize:_mainView];
}

-(void) onMainViewResize:(ResizeAwareView*) sender
{
    if (self.pageControl==nil)
        return;
    pageHeight=MAX_BANK_CARD_HEIGHT;
    pageWidth=MAX_BANK_CARD_WIDTH;
    pageDistance=PAGE_DISTANCE;
    pageOverlap=PAGE_OVERLAP;
    pageControlHeight=PAGE_CONTROL_HEIGHT;
    if (self.pageControl.numberOfPages<=1)
        pageControlHeight=0;
    else
        self.pageControl.frame=CGRectMake(0,_mainView.frame.size.height-pageControlHeight,_mainView.frame.size.width,pageControlHeight);
    if (pageHeight>_mainView.frame.size.height-pageControlHeight)
        pageHeight=_mainView.frame.size.height-pageControlHeight;
    if (pageWidth+2*pageDistance+2*pageOverlap>_mainView.frame.size.width)
    {
        pageWidth=_mainView.frame.size.width;
        pageDistance=0;
        pageOverlap=0;
    }
    CGFloat scrollWidth=pageWidth+2*pageDistance+2*pageOverlap;
    self.bankScrollViewContainer.frame=
        CGRectMake((_mainView.frame.size.width-scrollWidth)/2,
                   (_mainView.frame.size.height-pageHeight-pageControlHeight)/2,
                   scrollWidth,
                   pageHeight);
    self.bankScrollView.frame = CGRectMake(pageOverlap+pageDistance,
                                           0,
                                           pageWidth+pageDistance,
                                           pageHeight);
    self.bankScrollView.contentSize = CGSizeMake(pageWidth+(pageWidth+pageDistance) * (self.pageControl.numberOfPages-1)+pageDistance,pageHeight);
    for (BankLoginPageItem* page in pages)
    {
        page.controller.view.frame=CGRectMake([pages indexOfObject:page]*(pageWidth+pageDistance), 0, pageWidth, pageHeight);
    }
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

- (IBAction)onAddUrlClick:(id)sender {
    SelectAddBankForm* form=[[SelectAddBankForm alloc] initWithNibName:@"SelectAddBankForm" bundle:nil];
    UINavigationController* navigationController=[[UINavigationController alloc] initWithRootViewController:form];
    navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    navigationController.modalPresentationStyle=UIModalPresentationFormSheet;
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (IBAction)onChangeUrlClick:(id)sender
{
    NSInteger pageNumber = roundf(self.bankScrollView.contentOffset.x / (self.bankScrollView.frame.size.width));
    if (pageNumber>=0 && pageNumber<pages.count)
    {
        BankAddressForm* form=[[BankAddressForm alloc] initWithNibName:@"BankAddressForm" bundle:nil];
        UINavigationController* navigationController=[[UINavigationController alloc] initWithRootViewController:form];
        form.bankIndex=[[pages objectAtIndex:pageNumber] bankIndex];
        navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        navigationController.modalPresentationStyle=UIModalPresentationFormSheet;
        [self presentViewController:navigationController animated:YES completion:nil];
    }
}

- (IBAction)onDeleteUrlClick:(id)sender {
    NSInteger pageNumber = roundf(self.bankScrollView.contentOffset.x / (self.bankScrollView.frame.size.width));
    if (pageNumber>=0 && pageNumber<pages.count)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"ConfirmDeleteUrl_Caption", @"MainLoginFormStrings", @"")
                                                        message:NSLocalizedStringFromTable(@"ConfirmDeleteUrl_Message", @"MainLoginFormStrings", @"")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedStringFromTable(@"ConfirmDeleteUrl_CancelButton", @"MainLoginFormStrings", @"")
                                              otherButtonTitles:NSLocalizedStringFromTable(@"ConfirmDeleteUrl_YesButton", @"MainLoginFormStrings", @""), nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger pageNumber = roundf(self.bankScrollView.contentOffset.x / (self.bankScrollView.frame.size.width));
    switch(buttonIndex)
    {
        case 0: break;
        case 1:
            if (pageNumber>=0 && pageNumber<pages.count)
            {
                BankLoginPageItem* page=[pages objectAtIndex:pageNumber];
                [APP deleteLocalBank:page.bankIndex];
                [APP.rootController showDefaultLoginForm];
            }
            break;
    }
}

@end
