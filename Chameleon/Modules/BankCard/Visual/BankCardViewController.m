//
//  BankCardViewController.m
//  Chameleon
//
//  Created by Volchik on 26.11.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import "BankCardViewController.h"
#import "Application.h"
#import "LocalBankInfo.h"
#import "MetadataManager.h"
#import "ResourceManager.h"
#import "BankCardDescription.h"

@interface BankCardViewController ()

@end

@implementation BankCardViewController

-(instancetype) initWithBankIndex:(NSUInteger) bankIndex
{
    self=[super init];
    if (self)
    {
        _bankIndex=bankIndex;
        
    }
    return self;
}

-(void) renderTitle:(BankCardDescription*) bankCardDescription
{
    _titleView.backgroundColor=bankCardDescription.titleColor;
    if (_titleImageData)
        [_titleImageView setImage:[UIImage imageWithData:_titleImageData]];
    else
        [_titleImageView setImage:nil];
    if (bankCardDescription.defaultTitleText)
    {
        if (_bankInfo)
            [_titleLabel setText:_bankInfo.bankCard.bankName];
    }
    else if (bankCardDescription.titleText)
        [_titleLabel setText:bankCardDescription.titleText];
    else
        [_titleLabel setText:@""];
    _titleImageView.contentMode=UIViewContentModeScaleAspectFit;
    //UIViewContentModeScaleAspectFill
    if (!_titleImageData && bankCardDescription.titleImage && bankCardDescription.titleImage.length>0)
    {
        BankCardViewController* weakself=self;
        [APP.resourceManager runResourceRequestForBankIndex:_bankIndex moduleType:@"BankCard" moduleName:@"" resourceName:bankCardDescription.titleImage completionHandler:^(NSData* data, NSError *error)
        {
            if (!error)
            {
                if (data)
                    [weakself.titleImageView setImage:[UIImage imageWithData:data]];
            }
            else
                NSLog(@"Error loading title image for bank card %@ with error : %@",bankCardDescription.titleImage,error);
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _bankInfo=[APP getLocalBankByIndex:_bankIndex];
    BankCardDescription* bankCardDescription=(BankCardDescription*)[APP.metadataManager getLocalMetadataForClass:BankCardDescription.class bankIndex:_bankIndex moduleType:@"BankCard" moduleName:@"" structureName:@"BankCard" langId:APP.currentLanguageId];
    if (!bankCardDescription)
        bankCardDescription=[[BankCardDescription alloc] initAsDefault];
    if (bankCardDescription.titleImage && bankCardDescription.titleImage.length>0)
    {
        _titleImageData=[APP.resourceManager getLocalResourceForBankIndex:_bankIndex moduleType:@"BankCard" moduleName:@"" resourceName:bankCardDescription.titleImage];
    }
    [self renderTitle:bankCardDescription];
    __weak BankCardViewController* weakself=self;
    [APP.metadataManager runMetadataRequestForClass: BankCardDescription.class bankIndex:_bankIndex moduleType:@"BankCard" moduleName:@"" structureName:@"BankCard" langId:APP.currentLanguageId completionHandler:^(MetaStructure* structure, NSError *error)
        {
            if (!error)
            {
                _titleImageData=nil;
                [weakself renderTitle:(BankCardDescription*)structure];
            }
        }];
    //self.view.backgroundColor = [UIColor lightGrayColor];
    
    //create a label and add to the sub view
    /*CGRect myFrame = CGRectMake(10.0f, 10.0f, 300.0f, 25.0f);
    UILabel *myLabel = [[UILabel alloc] initWithFrame:myFrame];
    LocalBankInfo* bank=[APP getLocalBankByIndex:_bankIndex];
    myLabel.text = [NSString stringWithFormat:@"This is page number %d: %@", _bankIndex,bank.bankCard.bankName];
    myLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    myLabel.textAlignment =  NSTextAlignmentLeft;
    [self.view addSubview:myLabel];
    
    //create a text field and add to the sub view
    myFrame.origin.y += myFrame.size.height + 10.0f;
    UITextField *myTextField = [[UITextField alloc] initWithFrame:myFrame];
    myTextField.borderStyle = UITextBorderStyleRoundedRect;
    myTextField.placeholder = [NSString stringWithFormat:@"Enter data in field %i", _bankIndex];
    [self.view addSubview:myTextField];*/
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
