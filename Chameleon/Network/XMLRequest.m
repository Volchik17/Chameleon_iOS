//
//  XMLRequest.m
//  Chameleon
//
//  Created by Volchik on 08.12.14.
//  Copyright (c) 2014 Volchik. All rights reserved.
//
#import <Foundation/NSXMLParser.h>
#import "XMLRequest.h"
#import "XMLWriter.h"
#import "XSWINodeWriter.h"

@implementation XMLRequest

-(void) makeXML:(id<XMLNodeWriter>) writer
{
    
}

-(NSString*) makeURLForRequest:(BSConnection*) connection
{
    return connection.url;
}

-(NSString*) makeBody
{
    XMLWriter* writer=[[XMLWriter alloc] init];
    [writer writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    XSWINodeWriter* nodeWriter=[[XSWINodeWriter alloc] initWithXMLWriter:writer];
    [self makeXML:nodeWriter];
    [writer writeEndDocument];
    return [writer toString];
}

-(NSURLRequest*) urlRequestForConnection:(BSConnection*) connection
{
    NSMutableURLRequest* request=[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[self makeURLForRequest:connection]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:connection.defaultTimeout];
    [request setHTTPMethod:@"POST"];
    [request setValue: @"text/xml; charset=utf8" forHTTPHeaderField:@"Content-Type"];
    NSString* requestBodyStr=[self makeBody];
    NSData* requestBody=[requestBodyStr dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[requestBody length]] forHTTPHeaderField:@"Content-Length"];
     [request setHTTPBody:requestBody];
    return request;
}

@end
