//
//  BankSelectCellDescription.h
//  Chameleon
//
//  Created by Volchik on 05.01.15.
//  Copyright (c) 2015 Volchik. All rights reserved.
//

#import "MetaStructure.h"
#import "ViewStructure.h"

@interface BankSelectCellDescription : MetaStructure

@property (nonatomic,strong) NSString* image;
@property (nonatomic,strong) ViewStructure* view;

@end
