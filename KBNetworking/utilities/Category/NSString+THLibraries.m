//
//  NSString+THLibraries.m
//  rainbowcn
//
//  Created by Lee on 14-8-18.
//  Copyright (c) 2014年 com.cn.szrainbow. All rights reserved.
//

#import "NSString+THLibraries.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (THLibraries)

#pragma mark - 公有方法

- (NSString *)stringURIEncoding
{
	return ((NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
																 (CFStringRef)self,
																 NULL,
																 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																 kCFStringEncodingUTF8)));
}

- (NSString *)stringURIDecoding
{
    return ((NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                 (CFStringRef)self,
                                                                                 CFSTR(""),
                                                                                 kCFStringEncodingUTF8)));
}

- (NSString *)utf8StringEncoding
{
    return ((NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                 (CFStringRef)self,
                                                                 NULL,
                                                                 (CFStringRef)@"!*'();@=+$,%#[]",
                                                                 kCFStringEncodingUTF8)));
}

- (NSString *)MD5String
{
	const char *cStr = [self UTF8String];
	unsigned char digest[CC_MD5_DIGEST_LENGTH];
	CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
	char md5string[CC_MD5_DIGEST_LENGTH * 2];
	int i;
	for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
		sprintf(md5string + i * 2, "%02X", digest[i]);
	}
	NSString *originalString = [[NSString stringWithCString:md5string encoding:NSUTF8StringEncoding] lowercaseString];
    
//    NSString *upperString = [originalString uppercaseString];
//    return upperString;
    return originalString;
}

- (BOOL)isValidEmail
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isValidMobileNumber
{
    NSString *regex = @"^1[3|5|7|8][0-9]{9}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

- (BOOL)allCharacterIsNumber
{
    for (int i = 0; i < self.length; i++) {
        char character = [self characterAtIndex:i];
        if (character < '0' || character > '9') {
            return NO;
        }
    }
    return YES;
}

-(BOOL)isAllNumber
{
    NSString  * numberRegex = @"^[0-9]*$";
    NSPredicate *VerifyNumber = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",numberRegex];
    return [VerifyNumber evaluateWithObject:self];
}

- (NSString *)stringWithMoneyFormat {
    if (self.length == 0) {
        return @"0";
    }
    
    // 小数
    NSString *decimal = @"";
    if ([self rangeOfString:@"."].location != NSNotFound) {
        decimal = [self substringFromIndex:[self rangeOfString:@"."].location];
    }
    
    // 获取整数
    int moneyNumber = [self intValue];
    
    // 获取绝对值
    int integerNumber = ABS(moneyNumber);
    // 将字符串转成数组
    NSString *integerString = [NSString stringWithFormat:@"%d", integerNumber];
    NSMutableArray *wordArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < integerString.length; i++) {
        NSString *wordString = [integerString substringWithRange:NSMakeRange(i, 1)];
        [wordArray addObject:wordString];
    }
    
    // 插入逗号
    for (int j = (int)[wordArray count]; j > 3; j-= 3) {
        int index = j - 3;
        if (index > 0) {
            [wordArray insertObject:@"," atIndex:index];
        }
    }
    
    // 追加小数
    if (decimal.length > 0) {
        [wordArray addObject:decimal];
    }
    
    // 追加符号（正负）
    if ([self rangeOfString:@"-"].location != NSNotFound) {
        [wordArray insertObject:@"-" atIndex:0];
    }
    
    // 还原成字符串
    return [wordArray componentsJoinedByString:@""];
}

- (NSString *)trim
{
    NSCharacterSet *characterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:characterSet];
}

- (id)jsonObject
{
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding]
                                                    options:NSJSONReadingMutableContainers
                                                      error:&error];
    if (error != nil) {
        return nil;
    }
    
    return jsonObject;
}

- (NSString *)escapeHTML
{
    if (self.length == 0) {
        return @"";
    }
    
    NSString *LT_ENCODE = @"&lt;";
    NSString *GT_ENCODE =  @"&gt;";
    NSString *AMP_ENCODE = @"&amp;";
    NSString *QUOTE_ENCODE = @"&quot;";
    NSString *APOS_ENCODE = @"&apos;";
    
    NSString *strReText = @"";
    const char *chText = [self UTF8String];
    int nLen = (int)[self length];
    int nLast = 0;
    int n = 0;
    for ( ; n < nLen; n++) {
        //[strText characterAtIndex:n]
        char ch = chText[n];
        if (ch > '>') {
            
        } else if (ch == '<') {
            if (n > nLast) {
                NSRange range = NSMakeRange(nLast, n-nLast);
                strReText = [strReText stringByAppendingString:[self substringWithRange:range]];
            }
            nLast = n + 1;
            [strReText stringByAppendingString:LT_ENCODE];
        } else if (ch == '>') {
            if (n > nLast) {
                NSRange range = NSMakeRange(nLast, n-nLast);
                strReText = [strReText stringByAppendingString:[self substringWithRange:range]];
            }
            nLast = n + 1;
            [strReText stringByAppendingString:GT_ENCODE];
        } else if (ch == '&') {
            if (n > nLast) {
                NSRange range = NSMakeRange(nLast, n-nLast);
                strReText = [strReText stringByAppendingString:[self substringWithRange:range]];
            }
            // Do nothing if the string is of the form &#235; (unicode value)
            
            if (!(nLen > n + 5
                  && chText[n+1] == '#'
                  && isdigit(chText[n+2])
                  && isdigit(chText[n+3])
                  && isdigit(chText[n+4])
                  && isdigit(chText[n+5]) == ';')) {
                nLast = n + 1;
                [self stringByAppendingString:AMP_ENCODE];
            }
        } else if (ch == '\"') {
            if (n > nLast) {
                NSRange range = NSMakeRange(nLast, n-nLast);
                strReText = [strReText stringByAppendingString:[self substringWithRange:range]];
            }
            nLast = n + 1;
            [strReText stringByAppendingString:QUOTE_ENCODE];
        } else if (ch == '\\') {
            if (n > nLast) {
                NSRange range = NSMakeRange(nLast, n-nLast);
                strReText = [strReText stringByAppendingString:[self substringWithRange:range]];
            }
            nLast = n + 1;
            [strReText stringByAppendingString:APOS_ENCODE];
        }
    }
    
    if (nLast == 0) {
        return self;
    }
    
    if (n > nLast) {
        NSRange range = NSMakeRange(nLast, n-nLast);
        strReText = [strReText stringByAppendingString:[self substringWithRange:range]];
    }
    return strReText;
}

- (NSString *)unEscapeHTML
{
    NSString *strReText = @"";
    strReText = [self stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    strReText = [strReText stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    strReText = [strReText stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    strReText = [strReText stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    return strReText;
}

- (NSString *)pinYinString
{
    NSMutableString *source = [self mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);
    return source;
}

- (NSString *)URLEncodedString
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)self,
                                            (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                            NULL,
                                            kCFStringEncodingUTF8));
    return encodedString;
}

- (BOOL)isIdCard
{
    //^(\\d{6})(\\d{4})(\\d{2})(\\d{2})(\\d{3})([0-9]|X)$
    NSString *value = self;
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([value length] != 18) {
        return NO;
    }
    NSString *mmdd = @"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
    NSString *leapMmdd = @"0229";
    NSString *year = @"(19|20)[0-9]{2}";
    NSString *leapYear = @"(19|20)(0[48]|[2468][048]|[13579][26])";
    NSString *yearMmdd = [NSString stringWithFormat:@"%@%@", year, mmdd];
    NSString *leapyearMmdd = [NSString stringWithFormat:@"%@%@", leapYear, leapMmdd];
    NSString *yyyyMmdd = [NSString stringWithFormat:@"((%@)|(%@)|(%@))", yearMmdd, leapyearMmdd, @"20000229"];
    NSString *area = @"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}";
    NSString *regex = [NSString stringWithFormat:@"%@%@%@", area, yyyyMmdd  , @"[0-9]{3}[0-9Xx]"];
    
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [regexTest evaluateWithObject:value];
}

@end
