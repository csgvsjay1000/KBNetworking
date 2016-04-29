//
//  UIView+THLibraries.h
//  rainbowcn
//
//  Created by Lee on 14-8-18.
//  Copyright (c) 2014年 com.cn.szrainbow. All rights reserved.
//

#import <UIKit/UIKit.h>

// UIView扩展类（THLibraries）。
//
//
@interface UIView (THLibraries)

/// 位置
@property CGPoint origin;
/// 尺寸
@property CGSize size;
/// 高度
@property CGFloat height;
/// 宽度
@property CGFloat width;
/// 顶部位置（y坐标值）
@property CGFloat top;
/// 左边位置（x坐标值）
@property CGFloat left;
/// 底部位置（y坐标值 + 高度值）
@property CGFloat bottom;
/// 右边位置（x坐标值 + 宽度值）
@property CGFloat right;

/**
 * @brief   获取CGRect的中心点位置。
 *
 * @param   rect    CGRect坐标和尺寸。
 *
 * @return  rect的中心位置。
 */
CGPoint CGRectGetCenter(CGRect rect);

/**
 * @brief   移除所有子视图。
 *
 */
- (void)removeAllSubviews;

/**
 * @brief   截取图片。
 *
 * @return  截取的图片。
 */
- (UIImage *)captureImage;

@end
