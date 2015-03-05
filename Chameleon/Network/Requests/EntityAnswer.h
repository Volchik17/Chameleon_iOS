//
//  EntityAnswer.h
//  Chameleon
//
//  Created by Volchik on 19.01.15.
//  Copyright (c) 2015 Volchik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLAnswer.h"
#import "CustomizableEntity.h"

@interface EntityAnswer : XMLAnswer

@property (readonly, nonatomic) CustomizableEntity* entity;

-(instancetype) init;

//abstract method for override in descendents
-(CustomizableEntity*) createEntity;

@end
