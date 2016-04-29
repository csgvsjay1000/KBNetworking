//
//  UIImage+THLibraries.m
//  rainbowcn
//
//  Created by Lee on 14-8-18.
//  Copyright (c) 2014年 com.cn.szrainbow. All rights reserved.
//

#import "UIImage+THLibraries.h"
#import <Accelerate/Accelerate.h>

@interface UIImage (THLibraries_Private)

/**
 * @brief   CGSize宽度和高度对换。
 *
 * @param   size    对换之前的尺寸大小。
 *
 * @return  对换之后的尺寸大小。
 */
- (CGSize)swapWidthAndHeight:(CGSize)size;

@end

@implementation UIImage (THLibraries)

#pragma mark - 私有方法

- (CGSize)swapWidthAndHeight:(CGSize)size
{
    CGFloat swap = size.width;
    size.width  = size.height;
    size.height = swap;
    return size;
}

#pragma mark - 公有方法

+ (UIImage *)imageWithSolidColor:(UIColor *)bgColor
                            size:(CGSize)size
                           alpha:(CGFloat)alpha
{
    // 创建画布
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);

    // 获取画布内容
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 设置背景透明度
    CGContextSetAlpha(context, alpha);
    // 设置背景颜色
    CGContextSetFillColorWithColor(context, [bgColor CGColor]);
    CGContextFillRect(context, CGRectMake(0.0, 0.0, size.width, size.height));
    
    // 获取图片
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭画布
    UIGraphicsEndImageContext();
    return resultImage;
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect contextRect;
    contextRect.origin.x = 0.0f;
    contextRect.origin.y = 0.0f;
    contextRect.size = self.size;
    // Retrieve source image and begin image context
    CGSize itemImageSize = self.size;
    CGPoint itemImagePosition;
    itemImagePosition.x = ceilf((contextRect.size.width - itemImageSize.width) / 2);
    itemImagePosition.y = ceilf((contextRect.size.height - itemImageSize.height));
 
    UIGraphicsBeginImageContextWithOptions(contextRect.size, NO, [UIScreen mainScreen].scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    // Setup shadow
    // Setup transparency layer and clip to mask
    CGContextBeginTransparencyLayer(context, NULL);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    CGContextClipToMask(context,
                        CGRectMake(itemImagePosition.x, -itemImagePosition.y,
                                   itemImageSize.width, -itemImageSize.height),
                        self.CGImage);
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    contextRect.size.height = 0.0f - contextRect.size.height;
    contextRect.size.height -= 15.0f;
    // Fill and end the transparency layer
    CGContextFillRect(context, contextRect);
    CGContextEndTransparencyLayer(context);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIImage *)imageFitInSize:(CGSize)size
{
	// 计算尺寸
    CGSize drawSize;
	
	if (self.size.width / size.width >= self.size.height / size.height) {
        drawSize.width = size.width;
        drawSize.height = self.size.height * size.width / self.size.width;
	} else {
        drawSize.height = size.height;
        drawSize.width = self.size.width * size.height / self.size.height;
    }
    
    UIGraphicsBeginImageContextWithOptions(drawSize, NO, [UIScreen mainScreen].scale);
    
	[self drawInRect:CGRectMake(0.0, 0.0, drawSize.width, drawSize.height)];
	
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return newImg;
}

- (UIImage *)imageFillInSize:(CGSize)size
{
    // 计算尺寸
    CGSize drawSize;
	
	if (self.size.width / size.width <= self.size.height / size.height) {
        drawSize.width = size.width;
        drawSize.height = self.size.height * size.width / self.size.width;
	} else {
        drawSize.height = size.height;
        drawSize.width = self.size.width * size.height / self.size.height;
    }
    
    UIGraphicsBeginImageContextWithOptions(drawSize, NO, [UIScreen mainScreen].scale);
    
	[self drawInRect:CGRectMake(0.0, 0.0, drawSize.width, drawSize.height)];
	
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return newImg;
}

- (UIImage *)imageInRect:(CGRect)rect
{
    if (rect.size.width > 0 && rect.size.height > 0) {
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
        
        [self drawInRect:CGRectMake(0.0 - rect.origin.x,
                                    0.0 - rect.origin.y,
                                    self.size.width,
                                    self.size.height)];
        UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImg;
    } else {
        return nil;
    }
}

- (UIImage *)rotate:(UIImageOrientation)orient
{
    CGRect bnds = CGRectZero;
    UIImage *copy = nil;
    CGContextRef ctxt = nil;
    CGRect rect = CGRectZero;
    CGAffineTransform tran = CGAffineTransformIdentity;
    
    bnds.size = self.size;
    rect.size = self.size;
    
    switch (orient) {
        case UIImageOrientationUp:
            return self;
            
        case UIImageOrientationUpMirrored:
            tran = CGAffineTransformMakeTranslation(rect.size.width, 0.0);
            tran = CGAffineTransformScale(tran, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown:
            tran = CGAffineTransformMakeTranslation(rect.size.width,
                                                    rect.size.height);
            tran = CGAffineTransformRotate(tran, M_PI);
            break;
            
        case UIImageOrientationDownMirrored:
            tran = CGAffineTransformMakeTranslation(0.0, rect.size.height);
            tran = CGAffineTransformScale(tran, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeft:
            bnds.size = [self swapWidthAndHeight:bnds.size];
            tran = CGAffineTransformMakeTranslation(0.0, rect.size.width);
            tran = CGAffineTransformRotate(tran, -M_PI_2);
            break;
            
        case UIImageOrientationLeftMirrored:
            bnds.size = [self swapWidthAndHeight:bnds.size];
            tran = CGAffineTransformMakeTranslation(rect.size.height,
                                                    rect.size.width);
            tran = CGAffineTransformScale(tran, -1.0, 1.0);
            tran = CGAffineTransformRotate(tran, -M_PI_2);
            break;
            
        case UIImageOrientationRight:
            bnds.size = [self swapWidthAndHeight:bnds.size];
            tran = CGAffineTransformMakeTranslation(rect.size.height, 0.0);
            tran = CGAffineTransformRotate(tran, M_PI_2);
            break;
            
        case UIImageOrientationRightMirrored:
            bnds.size = [self swapWidthAndHeight:bnds.size];
            tran = CGAffineTransformMakeScale(-1.0, 1.0);
            tran = CGAffineTransformRotate(tran, M_PI_2);
            break;
            
        default:
            // orientation value supplied is invalid
            assert(false);
            return nil;
    }
    
    UIGraphicsBeginImageContextWithOptions(bnds.size, NO, [UIScreen mainScreen].scale);
    
    ctxt = UIGraphicsGetCurrentContext();
    
    switch (orient) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextScaleCTM(ctxt, -1.0, 1.0);
            CGContextTranslateCTM(ctxt, -rect.size.height, 0.0);
            break;
            
        default:
            CGContextScaleCTM(ctxt, 1.0, -1.0);
            CGContextTranslateCTM(ctxt, 0.0, -rect.size.height);
            break;
    }
    
    CGContextConcatCTM(ctxt, tran);
    CGContextDrawImage(ctxt, rect, self.CGImage);
    
    copy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return copy;
}

- (UIImage *)glassBlurWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor
{
    if ((radius < 0.0) || (radius > 100.0)) {
        radius = 50.0;
    }
    
    if (tintColor == nil) {
        tintColor = [UIColor whiteColor];
    }
    
    if (floorf(self.size.width) * floorf(self.size.height) <= 0.0f) {
        return self;
    }

    // boxsize must be an odd integer
    uint32_t boxSize = (uint32_t)(radius * self.scale);
    if (boxSize % 2 == 0) {
        boxSize++;
    }
    // create image buffers
    CGImageRef imageRef = self.CGImage;
    vImage_Buffer buffer1, buffer2;
    buffer1.width = buffer2.width = CGImageGetWidth(imageRef);
    buffer1.height = buffer2.height = CGImageGetHeight(imageRef);
    buffer1.rowBytes = buffer2.rowBytes = CGImageGetBytesPerRow(imageRef);
    size_t bytes = buffer1.rowBytes * buffer1.height;
    buffer1.data = malloc(bytes);
    buffer2.data = malloc(bytes);
    // create temp buffer
    void *tempBuffer = malloc((size_t)vImageBoxConvolve_ARGB8888(&buffer1,
                                                                 &buffer2,
                                                                 NULL,
                                                                 0,
                                                                 0,
                                                                 boxSize,
                                                                 boxSize,
                                                                 NULL,
                                                                 kvImageEdgeExtend + kvImageGetTempBufferSize));
    // copy image data
    CFDataRef dataSource = CGDataProviderCopyData(CGImageGetDataProvider(imageRef));
    memcpy(buffer1.data, CFDataGetBytePtr(dataSource), bytes);
    CFRelease(dataSource);
    for (NSUInteger i = 0; i < iterations; i++) {
        // perform blur
        vImageBoxConvolve_ARGB8888(&buffer1,
                                   &buffer2,
                                   tempBuffer,
                                   0,
                                   0,
                                   boxSize,
                                   boxSize,
                                   NULL,
                                   kvImageEdgeExtend);
        // swap buffers
        void *temp = buffer1.data;
        buffer1.data = buffer2.data;
        buffer2.data = temp;
    }
    // free buffers
    free(buffer2.data);
    free(tempBuffer);
    // create image context from buffer
    CGContextRef ctx = CGBitmapContextCreate(buffer1.data,
                                             buffer1.width,
                                             buffer1.height,
                                             8,
                                             buffer1.rowBytes,
                                             CGImageGetColorSpace(imageRef),
                                             CGImageGetBitmapInfo(imageRef));
    // apply tint
    if (tintColor && CGColorGetAlpha(tintColor.CGColor) > 0.0) {
        CGContextSetFillColorWithColor(ctx, [tintColor colorWithAlphaComponent:0.25].CGColor);
        CGContextSetBlendMode(ctx, kCGBlendModePlusLighter);
        CGContextFillRect(ctx, CGRectMake(0, 0, buffer1.width, buffer1.height));
    }
    // create image from context
    imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *image = [UIImage imageWithCGImage:imageRef
                                         scale:self.scale
                                   orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    CGContextRelease(ctx);
    free(buffer1.data);
    
    return image;
}

@end
