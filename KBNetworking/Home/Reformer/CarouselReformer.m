//
//  CarouselReformer.m
//  KBNetworking
//
//  Created by chengshenggen on 5/3/16.
//  Copyright © 2016 Gan Tian. All rights reserved.
//

#import "CarouselReformer.h"
#import "IndexApiManager.h"

NSString *const kPropertyFocusImgList = @"kPropertyFocusImgList";  //轮播图片
NSString *const kPropertyTagList = @"kPropertyTagList";  //标签
NSString *const kPropertyOneList = @"kPropertyOneList";  //精选视频
NSString *const kPropertyTwoList = @"kPropertyTwoList";  //热门视频
NSString *const kPropertyThreeList = @"kPropertyThreeList";  //美女视频


@implementation IndexReformer

- (id)manager:(KBAPIBaseManager *)manager reformData:(NSDictionary *)data{
    NSDictionary *resultData = nil;
    
    if ([manager isKindOfClass:[IndexApiManager class]]) {
        resultData = @{
                       kPropertyFocusImgList:data[@"focusImgList"],
                       kPropertyTagList:data[@"tagList"],
                       kPropertyOneList:data[@"oneList"],
                       kPropertyTwoList:data[@"twoList"],
                       kPropertyThreeList:data[@"threeList"],

                       };
    }
    
    return resultData;
}


@end

NSString *const kPropertyFocusImgPath = @"kPropertyFocusImgPath";
NSString *const kPropertyFocusImgType = @"kPropertyFocusImgType";

@implementation CarouselReformer

- (id)manager:(KBAPIBaseManager *)manager reformData:(NSDictionary *)data{
    NSDictionary *resultData = nil;
    
    if ([manager isKindOfClass:[IndexApiManager class]]) {
        resultData = @{
                       kPropertyFocusImgPath:data[@"focusImgPath"],
                       kPropertyFocusImgType:data[@"focusImgType"]
                       };
    }
    
    return resultData;
}


@end
