//
//  UIView+THLibraries.m
//  rainbowcn
//
//  Created by Lee on 14-8-18.
//  Copyright (c) 2014年 com.cn.szrainbow. All rights reserved.
//

#import "UIView+THLibraries.h"

@implementation UIView (THLibraries)

#pragma mark - 公有方法

- (CGPoint)origin
{
	return self.frame.origin;
}

- (void)setOrigin:(CGPoint)aPoint
{
	CGRect newframe = self.frame;
	newframe.origin = aPoint;
	self.frame = newframe;
}

- (CGSize)size
{
	return self.frame.size;
}

- (void)setSize:(CGSize)aSize
{
	CGRect newframe = self.frame;
	newframe.size = aSize;
	self.frame = newframe;
}


- (CGFloat)height
{
	return self.frame.size.height;
}

- (void)setHeight:(CGFloat)newHeight
{
	CGRect newFrame = self.frame;
	newFrame.size.height = newHeight;
	self.frame = newFrame;
}

- (CGFloat)width
{
	return self.frame.size.width;
}

- (void)setWidth:(CGFloat)newWidth
{
	CGRect newFrame = self.frame;
	newFrame.size.width = newWidth;
	self.frame = newFrame;
}

- (CGFloat)top
{
	return self.frame.origin.y;
}

- (void)setTop:(CGFloat)newTop
{
	CGRect newFrame = self.frame;
	newFrame.origin.y = newTop;
	self.frame = newFrame;
}

- (CGFloat)left
{
	return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)newLeft
{
	CGRect newFrame = self.frame;
	newFrame.origin.x = newLeft;
	self.frame = newFrame;
}

- (CGFloat)bottom
{
	return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)newBottom
{
	CGRect newFrame = self.frame;
	newFrame.origin.y = newBottom - self.frame.size.height;
	self.frame = newFrame;
}

- (CGFloat)right
{
	return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)newRight
{
	CGFloat delta = newRight - (self.frame.origin.x + self.frame.size.width);
	CGRect newFrame = self.frame;
	newFrame.origin.x += delta;
	self.frame = newFrame;
}

CGPoint CGRectGetCenter(CGRect rect)
{
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

- (void)removeAllSubviews
{
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
}

- (UIImage *)captureImage
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

@end
