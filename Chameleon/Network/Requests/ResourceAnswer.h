//
//  ResourceAnswer.h
//  Chameleon
//
//  Created by Volchik on 06.01.15.
//  Copyright (c) 2015 Volchik. All rights reserved.
//

#import "Answer.h"

@interface ResourceAnswer : Answer

@property (nonatomic,strong) NSData* data;
@property (nonatomic,assign) BOOL isUnchanged;

@end
