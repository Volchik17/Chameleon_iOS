//
//  Token.h
//  mBSClient
//
//  Created by Maksim Voronin on 13.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum  {
    ttNULL,
    ttUNCHANGED,
    ttTRUE,
    ttFALSE,
    // ---------------
    ttID, // "SomeIdentifier"
    // ---------------
    ttLocalRes, // %LocalId%
    // ---------------
    ttString, // 'String constant'#13#10
    ttInteger, // 12342
    ttFloat, // 1.25E-2
    // ---------------
    ttNot, // !
    ttOR, // ||
    ttAND, // &&
    ttDot, // "."
    ttLeftBracket, // "("
    ttRightBracket, // ")"
    ttComma, // ","
    ttEqual, // "=="
    ttLesser, // "<"
    ttGreater, // ">"
    ttNotEqual, // "!="
    ttLesserEqual, // "<="
    ttGreaterEqual, // ">="
    ttPlus, // "+"
    ttMinus, // "-"
    ttMult, // "*"
    ttDivide, // "/"
} TokenType;

@interface Token : NSObject

@property(nonatomic,assign) TokenType type;
@property(nonatomic,strong) NSString* stringValue;
@property(nonatomic,assign) int intValue;
@property(nonatomic,assign) double floatValue;

@end
