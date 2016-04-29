//
//  UIImage+RoundedRect.h
//  ZTE_Demo
//
//  Created by WeiXinjie on 15/12/11.
//  Copyright © 2015年 admin007. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (RoundedRect)

+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r;

@end
