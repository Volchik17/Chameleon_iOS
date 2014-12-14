//
//  SelectAddBankForm.h
//  Chameleon
//
//  Created by Volchik on 03.12.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GradientBackground.h"

@interface BanksDataSource : NSObject<UITableViewDataSource>
{
    NSMutableArray* filteredBanks;
}
-(instancetype) initForTableView:(UITableView*) tableView;
@property (nonatomic,weak) UITableView* tableView;
@property (nonatomic,strong) NSMutableArray* banks;
@property (nonatomic, strong) NSString* filterString;
@end

@interface SelectAddBankForm : UIViewController<UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic,strong) BanksDataSource* banksDataSource;

@property (weak, nonatomic) IBOutlet UITableView *banksTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
