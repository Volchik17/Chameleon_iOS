//
//  XSWINodeWriter.m
//  Chameleon
//
//  Created by Volchik on 08.12.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

#import "XSWINodeWriter.h"
#import "XMLNodeWriter.h"

@implementation XSWINodeWriter

-(instancetype) initWithXMLWriter:(XMLWriter*) writer
{
    self=[super init];
    if (self)
    {
        _writer=writer;
    }
    return self;
}

-(void) startNode:(NSString*) nodeName
{
    [self.writer writeStartElement:nodeName];
}

-(void) endNode
{
    [self.writer writeEndElement];
}

-(void) addAttribute:(NSString*) attributeName stringValue:(NSString*) value
{
    [self.writer writeAttribute:attributeName value:value];
}

-(void) addAttribute:(NSString*) attributeName intValue:(int) value
{
    [self.writer writeAttribute:attributeName value:[NSString stringWithFormat:@"%i",value]];
}

-(void) addAttribute:(NSString*) attributeName longValue:(long long) value
{
    [self.writer writeAttribute:attributeName value:[NSString stringWithFormat:@"%lli",value]];
}

-(void) addAttribute:(NSString*) attributeName doubleValue:(double) value
{
    [self.writer writeAttribute:attributeName value:[NSString stringWithFormat:@"%f",value]];
}

-(void) addAttribute:(NSString*) attributeName boolValue:(BOOL) value
{
    [self.writer writeAttribute:attributeName value:value?@"1":@"0"];
}

-(void) addAttribute:(NSString*) attributeName dateValue:(NSDate*) value
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy HH:mm:ss"];
    [self.writer writeAttribute:attributeName value:[dateFormatter stringFromDate:value]];
}

-(void) writeCharacters:(NSString*)text
{
    [self.writer writeCharacters:text];
}

-(void) writeCData:(NSString*)cdata
{
    [self.writer writeCData:cdata];
}

@end
