//
//  BankListFromCatalogAnswer.h
//  Chameleon
//
//  Created by Volchik on 09.12.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import "XMLAnswer.h"

@interface BankListFromCatalogAnswer : XMLAnswer

@property (nonatomic,strong) NSMutableArray* banks;

-(instancetype) init;

@end
