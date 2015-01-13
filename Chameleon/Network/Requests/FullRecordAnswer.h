//
//  FullRecordAnswer.h
//  Chameleon
//
//  Created by Volchik on 07.01.15.
//  Copyright (c) 2015 Volchik. All rights reserved.
//

#import "XMLAnswer.h"
#import "IRecord.h"
#import "CustomRecord.h"

@interface FullRecordAnswer : XMLAnswer
@property (nonatomic,readonly) CustomRecord* record;
@end
