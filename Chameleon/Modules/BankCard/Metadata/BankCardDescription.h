//
//  BankCardDescription.h
//  Chameleon
//
//  Created by Volchik on 21.01.15.
//  Copyright (c) 2015 Volchik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MetaStructure.h"

@interface BankCardDescription : MetaStructure

@property (nonatomic,strong) NSString* titleText;
@property (nonatomic,assign) BOOL defaultTitleText;
@property (nonatomic,strong) UIColor* titleColor;
@property (nonatomic,strong) NSString* titleImage;

@property (nonatomic,strong) NSMutableArray* authMethodNames;
@property (nonatomic,strong) NSMutableArray* infoPanelNames;

-(instancetype) initAsDefault;

@end
