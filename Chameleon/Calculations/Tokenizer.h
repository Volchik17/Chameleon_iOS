//
//  Tokenizer.h
//  mBSClient
//
//  Created by Maksim Voronin on 13.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Token;
@interface Tokenizer : NSObject
{
    const unichar* sourceChars;
    int sourceLength;
    int savedPosition;
}
@property(nonatomic,strong) NSString* source;
@property(nonatomic,assign) int position;

- (id) initWithString:(NSString*)string;
- (BOOL) getNextToken:(Token*)token;
- (void) mark;
- (void) back;
- (void) delMark;
- (BOOL) eof;
@end
