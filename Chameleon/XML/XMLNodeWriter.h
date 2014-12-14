//
//  XMLNodeWriter.h
//  Chameleon
//
//  Created by Volchik on 08.12.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//

@protocol XMLNodeWriter <NSObject>

@required

-(void) startNode:(NSString*) nodeName;
-(void) endNode;
-(void) addAttribute:(NSString*) attributeName stringValue:(NSString*) value;
-(void) addAttribute:(NSString*) attributeName intValue:(int) value;
-(void) addAttribute:(NSString*) attributeName longValue:(long long) value;
-(void) addAttribute:(NSString*) attributeName doubleValue:(double) value;
-(void) addAttribute:(NSString*) attributeName boolValue:(BOOL) value;
-(void) addAttribute:(NSString*) attributeName dateValue:(NSDate*) value;
-(void) writeCharacters:(NSString*)text;
-(void) writeCData:(NSString*)cdata;

@end
