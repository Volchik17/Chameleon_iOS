//
//  MetadataAnswer.h
//  Chameleon
//
//  Created by Volchik on 17.12.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import "Answer.h"

@interface MetadataAnswer : Answer

@property (nonatomic,strong) NSData* data;
@property (nonatomic,assign) BOOL isUnchanged;

@end
