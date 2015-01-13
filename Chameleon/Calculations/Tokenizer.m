//
//  Tokenizer.m
//  mBSClient
//
//  Created by Maksim Voronin on 13.10.14.
//  Copyright (c) 2014 BSS. All rights reserved.
//

#import "Tokenizer.h"
#import "Token.h"
#import "ExpressionParserError.h"

@implementation Tokenizer

@synthesize source,position;

- (id)initWithString:(NSString*)string
{
    self = [super init];
    if (self)
    {
        source = string;
        sourceChars = (const unichar*)[source cStringUsingEncoding:NSUnicodeStringEncoding];
        position = 0;
        sourceLength = source.length;
        savedPosition = -1;
    }
    return self;
}

-(BOOL) isIdentifierStart:(unichar)symbol
{
    NSString* string = [NSString stringWithFormat:@"%C" , symbol];
    NSCharacterSet *s = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"];
    s = [s invertedSet];
    NSRange r = [string rangeOfCharacterFromSet:s];
    if (r.location != NSNotFound)
    {
        return NO;
    }
    return YES;
}

-(BOOL) isIdentifierPart:(unichar)symbol
{
    NSString* string = [NSString stringWithFormat:@"%C" , symbol];
    NSCharacterSet *s = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_"];
    s = [s invertedSet];
    NSRange r = [string rangeOfCharacterFromSet:s];
    if (r.location != NSNotFound)
    {
        return NO;
    }
    return YES;
}

-(BOOL) getNextToken:(Token*)token
{
    unichar c;
    c = [self checkChar];
    // eof
    if (c == 0x0)
        return NO;
    // skip whitespaces
    if (c == ' ' || c == '\n' || c == '\t')
    {
        while (c == ' ' || c == '\n' || c == '\t')
            if ((c = [self readChar]) == 0x0)
                return NO;
    } else
        c = [self readChar];
    switch (c) {
        case '+':
        {
            token.type = ttPlus;
            break;
        }
        case '-':
        {
            token.type = ttMinus;
            break;
        }
        case '*':
        {
            token.type = ttMult;
            break;
        }
        case '/':
        {
            token.type = ttDivide;
            break;
        }
        case '(':
        {
            token.type = ttLeftBracket;
            break;
        }
        case ')':
        {
            token.type = ttRightBracket;
            break;
        }
        case ',':
        {
            token.type = ttComma;
            break;
        }
        case '.':
            token.type = ttDot;
            break;
        case '=':
        {
            if ([self readChar] == '=')
                token.type = ttEqual;
            else
                @throw [ExpressionParserError expressionParserError:source position:position errorMessage:@"\"=\" expected."];
            break;
        }
        case '|':
        {
            if ([self readChar] == '|')
                token.type = ttOR;
            else
                @throw [ExpressionParserError expressionParserError:source position:position errorMessage:@"\"|\" expected."];
            break;
        }
        case '&':
        {
            if ([self readChar] == '&')
                token.type = ttAND;
            else
                @throw [ExpressionParserError expressionParserError:source position:position errorMessage:@"\"&\" expected."];
            break;
        }
        case '>':
        {
            if ([self checkChar] == '=')
            {
                token.type = ttGreaterEqual;
                [self readChar];
            }
            else
            {
                token.type = ttGreater;
            }
            break;
        }
        case '<':
        {
            if ([self checkChar] == '=')
            {
                token.type = ttLesserEqual;
                [self readChar];
            }
            else
            {
                token.type = ttLesser;
            }
            break;
        }
        case '!':
        {
            if ([self checkChar] == '=')
            {
                token.type = ttNotEqual;
                [self readChar];
            }
            else
            {
                token.type = ttNot;
            }
            break;
        }
        case '\'':
        {
            token.type = ttString;
            [self readStringConstant:c token:token];
            break;
        }
        case '%':
        {
            token.type = ttLocalRes;
            [self readLocalRes:c token:token];
            break;
        }
        default:
        {
            if (c >= '0' && c <= '9')
                [self readDigitToken:c token:token];
            else if ([self isIdentifierStart:c])
                [self readLetterToken:c token:token];
            else
                @throw [ExpressionParserError expressionParserError:source position:position errorMessage:[NSString stringWithFormat:@"Invalid symbol \"\"%c\"\"",c]];
        }
    }
    return YES;
}

-(void) mark
{
    assert(savedPosition==-1);
    savedPosition=position;
}

-(void) back
{
    assert(savedPosition!=-1);
    position=savedPosition;
    savedPosition=-1;
}

-(void) delMark
{
    assert(savedPosition!=-1);
    savedPosition=-1;
}

-(BOOL) eof
{
    return position>=sourceLength;
}

-(unichar) readChar
{
    if (position < sourceLength)
    {
        return sourceChars[position++];
    } else
        return 0x0;
}

-(unichar) checkChar
{
    if (position < sourceLength)
    {
        return sourceChars[position];
    } else
        return 0x0;
}

-(void) readStringConstant:(char)firstSymbol token:(Token*)token
{
    NSMutableString* s = [NSMutableString new];
    unichar c;
    while(true) {
        c = [self readChar];
        switch (c) {
            case 0x0:
                @throw [ExpressionParserError expressionParserError:source position:position errorMessage:@"Unterminated string literal."];
            case '\'':
            {
                token.stringValue = [NSString stringWithString:s];
                token.type= ttString;
                return;
            }
            case '\n':
                @throw [ExpressionParserError expressionParserError:source position:position errorMessage:@"Unterminated string literal."];
            case '\\':
            {
                c= [self readChar];
                switch (c)
                {
                    case 0x0:
                    {
                        @throw [ExpressionParserError expressionParserError:source position:position errorMessage:@"Unterminated string literal."];
                        break;
                    }
                    case '\\':
                        {[s appendString:[NSString stringWithFormat:@"%C",c]];break;}
                    case 'b':
                        {[s appendString:[NSString stringWithFormat:@"%c",'\b']];break;}
                    case 'f':
                        {[s appendString:[NSString stringWithFormat:@"%c",'\f']];break;}
                    case 'n':
                        {[s appendString:[NSString stringWithFormat:@"%c",'\n']];break;}
                    case 'r':
                        {[s appendString:[NSString stringWithFormat:@"%c",'\r']];break;}
                    case 't':
                        {[s appendString:[NSString stringWithFormat:@"%c",'\t']];break;}
                    case '\'':
                        {[s appendString:[NSString stringWithFormat:@"%c",'\'']];break;}
                    case '\"':
                        {[s appendString:[NSString stringWithFormat:@"%c",'\"']];break;}
                    case 'x':
                    {
                        unichar c1 = [self readChar];
                        if (c1 == 0x0)
                            @throw [ExpressionParserError expressionParserError:source position:position errorMessage:@"Unterminated string literal."];
                        if (c1<'0' || c1>'9')
                            @throw [ExpressionParserError expressionParserError:source position:position errorMessage:@"Invalid hexadecimal sequence in string literal."];
                        unichar c2=[self readChar];
                        if (c2==0x0)
                            @throw [ExpressionParserError expressionParserError:source position:position errorMessage:@"Unterminated string literal."];
                        if (c2<'0' || c2>'9')
                            @throw [ExpressionParserError expressionParserError:source position:position errorMessage:@"Invalid hexadecimal sequence in string literal."];
                        
                        NSMutableString* str = [NSMutableString stringWithString:@"0x"];
                        [s appendString:[NSString stringWithFormat:@"%C",c1]];
                        [s appendString:[NSString stringWithFormat:@"%C",c2]];
                        NSUInteger codeValue;
                        [[NSScanner scannerWithString:str] scanHexInt:&codeValue];
                        [s appendString:[NSString stringWithFormat:@"%C",(unichar)codeValue]];
                        
                        break;
                    }
                    case 'u':
                    {
                        unichar u1 = [self readChar];
                        if (u1==0x0)
                            @throw [ExpressionParserError expressionParserError:source position:position errorMessage:@"Unterminated string literal."];
                        if (u1<'0' || u1>'9')
                            @throw [ExpressionParserError expressionParserError:source position:position errorMessage:@"Invalid hexadecimal sequence in string literal."];
                       unichar u2=[self readChar];
                        if (u2==0x0)
                            @throw [ExpressionParserError expressionParserError:source position:position errorMessage:@"Unterminated string literal."];
                        if (u2<'0' || u2>'9')
                            @throw [ExpressionParserError expressionParserError:source position:position errorMessage:@"Invalid hexadecimal sequence in string literal."];
                       unichar u3=[self readChar];
                        if (u3==0x0)
                            @throw [ExpressionParserError expressionParserError:source position:position errorMessage:@"Unterminated string literal."];
                        if (u3<'0' || u3>'9')
                            @throw [ExpressionParserError expressionParserError:source position:position errorMessage:@"Invalid hexadecimal sequence in string literal."];
                       unichar u4=[self readChar];
                        if (u4==0x0)
                            @throw [ExpressionParserError expressionParserError:source position:position errorMessage:@"Unterminated string literal."];
                        if (u4<'0' || u4>'9')
                            @throw [ExpressionParserError expressionParserError:source position:position errorMessage:@"Invalid hexadecimal sequence in string literal."];
                        
                        NSMutableString* str = [NSMutableString stringWithString:@"0x"];
                        [s appendString:[NSString stringWithFormat:@"%C",u1]];
                        [s appendString:[NSString stringWithFormat:@"%C",u2]];
                        [s appendString:[NSString stringWithFormat:@"%C",u3]];
                        [s appendString:[NSString stringWithFormat:@"%C",u4]];
                        NSUInteger codeValue;
                        [[NSScanner scannerWithString:str] scanHexInt:&codeValue];
                        [s appendString:[NSString stringWithFormat:@"%C",(unichar)codeValue]];;
                        break;
                    }
                    default:
                    {
                        if (c>='0' && c<='7')
                        {
                           unichar e1=[self readChar];
                            if (e1==0x0)
                                @throw [ExpressionParserError expressionParserError:source position:position errorMessage:@"Unterminated string literal."];
                            if (e1<'0' || e1>'7')
                                @throw [ExpressionParserError expressionParserError:source position:position errorMessage:@"Invalid hexadecimal sequence in string literal."];
                           unichar e2=[self readChar];
                            if (e2==0x0)
                                @throw [ExpressionParserError expressionParserError:source position:position errorMessage:@"Unterminated string literal."];
                            if (e2<'0' || e2>'7')
                                @throw [ExpressionParserError expressionParserError:source position:position errorMessage:@"Invalid hexadecimal sequence in string literal."];
                            
                            NSMutableString* str = [NSMutableString stringWithString:@"0x"];
                            [s appendString:[NSString stringWithFormat:@"%C",c]];
                            [s appendString:[NSString stringWithFormat:@"%C",e1]];
                            [s appendString:[NSString stringWithFormat:@"%C",e2]];
                            NSUInteger codeValue;
                            [[NSScanner scannerWithString:str] scanHexInt:&codeValue];
                            [s appendString:[NSString stringWithFormat:@"%C",(unichar)codeValue]];
                        }
                        else
                        {
                            @throw [ExpressionParserError expressionParserError:source position:position errorMessage:@"Invalid escape character in string."];
                        }
                    }
                }
                break;
            }
            default:
                [s appendString:[NSString stringWithFormat:@"%C",c]];
        }
    }
}

-(void) readDigitToken:(unichar)firstSymbol token:(Token*)token
{
    BOOL wasDot= NO;
    BOOL wasE  = NO;
    BOOL wasX  = NO;
    
    NSMutableString* s = [NSMutableString new];
    [s appendString:[NSString stringWithFormat:@"%C",firstSymbol]];

    BOOL breakCycle = NO;
    
    while (true)
    {
       unichar c = [self checkChar];
        switch (c)
        {
            case 0x0:
            {
                breakCycle = YES;
                break;
            }
            case 'x':
            case 'X':
            {
                if (s.length==1 && [[s substringWithRange:NSMakeRange(0,1)] isEqualToString:@"0"])
                {
                    wasX=YES;
                    [s appendString:[NSString stringWithFormat:@"%C",c]];
                    [self readChar];
                } else
                {
                    breakCycle = YES;
                }
                break;
            }
            case '.':
            {
                if (!(wasX || wasDot || wasE))
                {
                    wasDot=YES;
                    [s appendString:[NSString stringWithFormat:@"%C",c]];
                    wasDot=YES;
                    [self readChar];
                }
                else
                {
                    breakCycle = YES;
                }
                break;
            }
            case 'e':
            case 'E':
            {
                if (!(wasX || wasE))
                {
                    wasE=YES;
                    [s appendString:[NSString stringWithFormat:@"%C",c]];
                    [self readChar];
                    c = [self checkChar];
                    if (c=='-' || c=='+')
                    {
                        [s appendString:[NSString stringWithFormat:@"%C",c]];
                        [self readChar];
                    }
                }
                else
                {
                    breakCycle = YES;
                }
                break;
            }
            default:
            {
                if (c>='0' && c<='9')
                {
                    [s appendString:[NSString stringWithFormat:@"%C",c]];
                    [self readChar];
                }
                else if (wasX && (((c>='A') && (c<='F')) || ((c>='a') && (c<='f'))))
                {
                    [s appendString:[NSString stringWithFormat:@"%C",c]];
                    [self readChar];
                }
                else
                {
                    breakCycle = YES;
                }
                break;
            }
        }
        if(breakCycle==YES) break;
    }
        
    if (wasDot || wasE)
    {
        token.type= ttFloat;
        @try
        {
            token.floatValue = [s doubleValue];
        }
        @catch (NSException *exception)
        {
            @throw [ExpressionParserError expressionParserError:source position:position
                                                   errorMessage:[NSString stringWithFormat:@"Invalid numeric literal: %@",s]];
        }
    }
    else
    {
        token.type= ttInteger;
        @try
        {
            token.intValue = [s integerValue];
        }
        @catch (NSException *exception)
        {
            @throw [ExpressionParserError expressionParserError:source position:position
                                                   errorMessage:[NSString stringWithFormat:@"Invalid numeric literal: %@",s]];
        }
    }
}

-(void) readLetterToken:(unichar)firstSymbol token:(Token*)token
{
    NSMutableString* s = [NSMutableString new];
    [s appendString:[NSString stringWithFormat:@"%C",firstSymbol]];
    while (true) {
       unichar c=[self checkChar];
        if (c==0x0)
            break;
        else if ([self isIdentifierPart:c])
        {
            [self readChar];
            [s appendString:[NSString stringWithFormat:@"%C",c]];
        } else
            break;
    }
    token.stringValue = [NSString stringWithString:s];
    if ([[token.stringValue lowercaseString] isEqualToString:@"true"])
        token.type=ttTRUE;
    else if ([[token.stringValue lowercaseString] isEqualToString:@"false"])
        token.type=ttFALSE;
    else if ([[token.stringValue lowercaseString] isEqualToString:@"null"])
        token.type=ttNULL;
    else if ([[token.stringValue lowercaseString] isEqualToString:@"unchanged"])
        token.type=ttUNCHANGED;
    else
        token.type=ttID;
}

-(void) readLocalRes:(unichar)firstSymbol  token:(Token*)token
{
    NSMutableString* s = [NSMutableString new];
    while (true) {
       unichar c=[self readChar];
        switch (c) {
            case 0x0:
                @throw [ExpressionParserError expressionParserError:source position:position errorMessage:@"Unterminated local resource literal"];
            case '%':
            {
                token.type=ttLocalRes;
                token.stringValue = [NSString stringWithString:s];
                return;
            }
            default:
                [s appendString:[NSString stringWithFormat:@"%C",firstSymbol]];
        }
    }
}

@end
