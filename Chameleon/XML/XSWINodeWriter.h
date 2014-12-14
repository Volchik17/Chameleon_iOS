//
//  XSWINodeWriter.h
//  Chameleon
//
//  Created by Volchik on 08.12.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLNodeWriter.h"
#import "XMLWriter.h"

@interface XSWINodeWriter : NSObject <XMLNodeWriter>

@property (nonatomic,readonly) XMLWriter* writer;

-(instancetype) initWithXMLWriter:(XMLWriter*) writer;

@end
