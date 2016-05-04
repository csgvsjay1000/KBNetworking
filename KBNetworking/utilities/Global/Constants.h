//
//  Constants.h
//  VRShow
//
//  Created by jwd on 3/4/16.
//  Copyright © 2016 Gan Tian. All rights reserved.
//

#ifndef Constants_h
#define Constants_h
#import <UIKit/UIKit.h>

//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

//测试环境
//#define Domain @"http://192.168.200.148:8080/VR_Service/api/"

//正式环境
#define Domain @"http://120.76.79.49:38080/VR_Service/api/"

//#define MD5_Key @"92A864886F70D010101050101010500048202613082025D02010002818"

#define kRSAPublicKey @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDQ9mIWe63OiIDRh9invj8PL+xQoKIcn3zlu08GCqBzCwPxcMzSfDgzPrW22VCax30sqZnycMMWXesCZLHMW7gJYyVjfGo5/dsE0rKFJ7lExJfUNOBC7fkAzoz07qpkgDHHSKc11edT7cxCh/UrEEzjeQ4/6enixYzDoWfA8upL1QIDAQAB"

#define KUMSocialShareKey @"56da594a67e58ecaf50007f5"

//存储在userdefault里的数据
#define KUserID @"userID"

//NSUserDefaults存取
#define UserDefaultSet(object,key) [[NSUserDefaults standardUserDefaults] setObject:object forKey:key]; \
[[NSUserDefaults standardUserDefaults] synchronize]

#define UserDefaultGet(object,key) NSString *object = [[NSUserDefaults standardUserDefaults] objectForKey:key]

#define UserDefaultRemove(key)  [[NSUserDefaults standardUserDefaults] removeObjectForKey:key]

//十六进制颜色转换
#define UIColorFromRGB(rgbValue) UIColorFromRGBA(rgbValue, 1.0)

#define UIColorFromRGBA(rgbValue, alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

//屏幕宽度和高度
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

//日志预定义，非定义DEBUG后，日志不再打印。
#ifdef DEBUG
#define NSLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#else
#define NSLog(...)
#endif

#pragma block defines

typedef void(^VRSHowButtonPressedBlock)(id);

//import
#import "Masonry.h"
#import "BusinessTools.h"
//#import "SVProgressHUD.h"
//#import "UIImageView+WebCache.h"
#import "VRShowNavView.h"
#import "KBAPIBaseManager.h"

//网络请求配置文件
//#import <SystemConfiguration/SystemConfiguration.h>
//#import <MobileCoreServices/MobileCoreServices.h>

//判断空字符串
#define NULL_STR(str) (str == nil || (NSNull *)str == [NSNull null] || str.length == 0)

//提示框
#define Alert(msg) [[[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show]

//压缩图片
#define Compress(imageString, imageWidth) [[NSString stringWithFormat:@"%@?imageView2/2/w/%ld",imageString, (NSInteger)imageWidth + 100]utf8StringEncoding];

#endif /* Constants_h */
