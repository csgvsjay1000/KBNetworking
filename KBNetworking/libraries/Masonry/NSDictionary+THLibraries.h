//
//  NSDictionary+THLibraries.h
//  rainbowcn
//
//  Created by Lee on 14-10-27.
//  Copyright (c) 2014年 com.cn.szrainbow. All rights reserved.
//

#import <Foundation/Foundation.h>

// NSDictionary扩展类（THLibraries）。
//
//
@interface NSDictionary (THLibraries)

/**
 * @brief   转成JSON格式的字符串。
 *
 * @return  转换完成的JSON字符串。
 */
- (NSString *)jsonString;

@end
