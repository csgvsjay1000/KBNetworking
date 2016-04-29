//
//  UIImage+THLibraries.h
//  rainbowcn
//
//  Created by Lee on 14-8-18.
//  Copyright (c) 2014年 com.cn.szrainbow. All rights reserved.
//

#import <UIKit/UIKit.h>

// UIImage扩展类（THLibraries）。
//
//
@interface UIImage (THLibraries)

/**
 * @brief   创建一张纯色图片。
 *
 * @param   bgColor 图片的背景颜色。
 * @param   size    图片的大小。
 * @param   alpha   图片的透明度。
 *
 * @return  新创建的纯色图片。
 */
+ (UIImage *)imageWithSolidColor:(UIColor *)bgColor
                            size:(CGSize)size
                           alpha:(CGFloat)alpha;

/**
 * @brief   更改图片颜色（全改，不是改色调）。
 *
 * @param   color   要更改的颜色。
 *
 * @return  更改后的图片对象。
 */
- (UIImage *)imageWithColor:(UIColor *)color;

/**
 * @brief   将图片缩放到指定尺寸，按比例整个显示。
 *
 * @param   size    尺寸大小。
 *
 * @return  缩放后的图片。
 */
- (UIImage *)imageFitInSize:(CGSize)size;

/**
 * @brief   将图片缩放到指定尺寸，按比例填充模式。
 *
 * @param   size    尺寸大小。
 *
 * @return  缩放后的图片。
 */
- (UIImage *)imageFillInSize:(CGSize)size;

/**
 * @brief   截取图片中指定区域的图片。
 *
 * @param   rect    指定的区域。
 *
 * @return  指定区域的图片。
 */
- (UIImage *)imageInRect:(CGRect)rect;

/**
 * @brief  旋转图片。
 *
 * @param   orientation 要旋转的方向。
 *
 * @return  旋转完成后的图片。
 */
- (UIImage *)rotate:(UIImageOrientation)orientation;

/**
 * @brief   毛玻璃模糊。
 *
 * @param   模糊半径（取值范围0～100）。
 * @param   iterations  叠加（覆盖）次数。
 * @param   tintColor   色系/玻璃颜色（默认白色）。
 *
 * @param   模糊后的图片。
 */
- (UIImage *)glassBlurWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor;

@end
