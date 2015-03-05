//
//  BankCardViewController.h
//  Chameleon
//
//  Created by Volchik on 26.11.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankCard.h"
#import "LocalBankInfo.h"

@interface BankCardViewController : UIViewController
{
    NSUInteger _bankIndex;
    LocalBankInfo* _bankInfo;
    NSData* _titleImageData;
}

-(instancetype) initWithBankIndex:(NSUInteger) bankIndex;

@property (nonatomic,strong) id currentAuthViewController;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIView *authView;
@property (weak, nonatomic) IBOutlet UIScrollView *infoPanelsScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
