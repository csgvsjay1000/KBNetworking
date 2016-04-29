//
//  NSDictionary+THLibraries.m
//  rainbowcn
//
//  Created by Lee on 14-10-27.
//  Copyright (c) 2014年 com.cn.szrainbow. All rights reserved.
//

#import "NSDictionary+THLibraries.h"

@implementation NSDictionary (THLibraries)

#pragma mark - 公有方法

- (NSString *)jsonString
{
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                           options:0
                                                             error:&error];
        if (error != nil) {
            return nil;
        }
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];
        return jsonString;
    } else {
        return nil;
    }
}

@end
