//
//  NSString+THLibraries.h
//  rainbowcn
//
//  Created by Lee on 14-8-18.
//  Copyright (c) 2014年 com.cn.szrainbow. All rights reserved.
//

#import <Foundation/Foundation.h>

// NSString扩展类（THLibraries）。
//
//
@interface NSString (THLibraries)

/**
 * @brief   URI格式化字符串。
 *
 * @return  格式化后的字符串。
 */
- (NSString *)stringURIEncoding;

/**
 * @brief   字符串URI格式反解析。
 *
 * @return  解析后的字符串。
 */
- (NSString *)stringURIDecoding;

/**
 * @brief   UTF8格式转换。
 *
 * @return  UTF8格式字符串。
 */
- (NSString *)utf8StringEncoding;

/**
 * @brief   MD5转换。
 *
 * @return  转换完成的MD5字符串。
 */
- (NSString *)MD5String;

/**
 * @brief   是否为邮箱格式。
 *
 * @return  如果字符串是邮箱格式，返回YES，否则返回NO。
 */
- (BOOL)isValidEmail;

/**
 * @brief   是否为手机号码格式。
 *
 * @return  如果字符串是手机号码格式，返回YES，否则返回NO。
 */
- (BOOL)isValidMobileNumber;

/**
 * @brief   所有字符是否都为数字。
 *
 * @return  如果所有字符都是数字，返回YES，否则返回NO。
 */
- (BOOL)allCharacterIsNumber;

/**
 * @brief   转换成货币格式（逗号分隔，不含货币符号）
 *
 * @return  转换完成货币格式的字符串。
 */
- (NSString *)stringWithMoneyFormat;

/**
 * @brief   去掉字符串前后的空格和新行。
 *
 * @return  已去掉空格和新行的字符串。
 */
- (NSString *)trim;

/**
 * @brief   将字符串解析成json对象。
 *
 * @return  已经解析成功的json对象，如果返回nil，则解析失败。
 */
- (id)jsonObject;

/**
 * @brief   转换html标签。
 *
 * @return  转换html标签后的字符串。
 */
- (NSString *)escapeHTML;

/**
 * @brief   还原html标签。
 *
 * @return  还原html标签后的字符串。
 */
- (NSString *)unEscapeHTML;

/**
 * @brief   文字转拼音（不能转的文字将返回原字符）。
 *
 * @return  转好的拼音自字符。
 */
- (NSString *)pinYinString;

/**
 * @brief   对字符串进行URLEncode转换。
 *
 * @return  转换后的URLEncode。
 */
- (NSString *)URLEncodedString;

/**
 * @brief   验证是不是身份证号。
 *
 * @return  是就返回YES。
 */

- (BOOL)isIdCard;


//验证是不是纯数字
-(BOOL)isAllNumber;

@end
