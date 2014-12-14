//
//  XMLAnswer.h
//  Chameleon
//
//  Created by Volchik on 09.12.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import "Answer.h"
#import "HierarchicalXMLParser.h"
@interface XMLAnswer : Answer<HierarchicalXMLParserDelegate,HierarchicalXMLParserErrorHandler>
{
    NSError* lastError;
}

@end
