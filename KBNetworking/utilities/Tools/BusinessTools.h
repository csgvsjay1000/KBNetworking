//
//  BusinessTools.h
//  VRShow
//
//  Created by jwd on 3/4/16.
//  Copyright © 2016 Gan Tian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constants.h"

@interface BusinessTools : NSObject

/**
 通过xib文件名获取view
 */
+(UIView *)loadXibToViewWithName:(NSString *)name;

/**
 *  公钥加密
 */
+(NSString *)encryptWithPublicKey:(NSString *)str;

/**
 *  公钥解密
 */
+(NSString *)decryptWithPublicKey:(NSString *)str;

// 将字典转换成json字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

@end
