//
//  SelectBankFromURLForm.h
//  Chameleon
//
//  Created by Volchik on 16.12.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectBankFromURLForm : UIViewController<UITableViewDelegate>

@property (nonatomic,readonly) BOOL visible;

@property (nonatomic,strong) NSString* url;
@property (nonatomic,strong) NSMutableArray* bankIds;
@property (weak, nonatomic) IBOutlet UITableView *banksTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
