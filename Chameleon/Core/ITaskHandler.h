//
//  ITaskHandler.h
//  Chameleon
//
//  Created by Volchik on 17.12.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ITaskHandler <NSObject>

-(void) cancel;
-(void) suspend;
-(void) resume;

@end
