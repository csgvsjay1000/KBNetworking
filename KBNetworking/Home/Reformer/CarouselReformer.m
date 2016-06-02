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
NSString *const kPropertyVideoList = @"kPropertyVideoList";  //精选视频

@implementation IndexReformer

- (id)manager:(KBAPIBaseManager *)manager reformData:(NSDictionary *)data{
    NSArray *resultData = nil;
    
    
    if ([manager isKindOfClass:[IndexApiManager class]]) {
        resultData = @[@{kPropertyFocusImgList:data[@"focusImgList"],kPropertyTagList:data[@"tagList"]},  //顶部轮播图和标签
                       @{kPropertyVideoList:data[@"oneList"]},  //精选视频
                       @{kPropertyVideoList:data[@"twoList"]},  //热门视频
                       @{kPropertyVideoList:data[@"threeList"]}  //美女视频
                       ];
    }
    
    return resultData;
}


@end

NSString *const kPropertyFocusImgPath = @"kPropertyFocusImgPath";  //轮播图url
NSString *const kPropertyFocusImgType = @"kPropertyFocusImgType";  //轮播图类型,

@implementation CarouselReformer

- (id)manager:(KBAPIBaseManager *)manager reformData:(NSDictionary *)data{
    NSDictionary *resultData = nil;
    
    if ([manager isKindOfClass:[IndexApiManager class]]) {
        if ([data isKindOfClass:[NSArray class]]) {
            NSMutableArray *marray = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in data) {
                [marray addObject:@{kPropertyFocusImgPath:dic[@"focusImgPath"],kPropertyFocusImgType:dic[@"focusImgType"]}];
            }
            return marray;
        }
        
    }
    
    return resultData;
}

@end

NSString *const kPropertyTagName = @"kPropertyTagName";  //第三方标签name
NSString *const kPropertyTagIcon = @"kPropertyTagIcon";  //第三方标签图片
NSString *const kPropertyTagId = @"kPropertyTagId";  //第三方标签id


@implementation ThridTagReformer

- (id)manager:(KBAPIBaseManager *)manager reformData:(NSDictionary *)data{
    NSDictionary *resultData = nil;
    if ([manager isKindOfClass:[IndexApiManager class]]) {
        if ([data isKindOfClass:[NSArray class]]) {
            NSMutableArray *marray = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in data) {
                [marray addObject:@{kPropertyTagName:dic[@"tagName"],
                                    kPropertyTagIcon:dic[@"tagIcon"],
                                    kPropertyTagId:dic[@"tagId"]}];
            }
            return marray;
        }
        
    }

    return resultData;
}


@end





NSString *const kPropertyVideoTagName = @"kPropertyVideoTagName";  //视频列表的标签
NSString *const kPropertyVideoResourcesList = @"kPropertyVideoResourcesList";  //每个标签下视频列表

@implementation IndexVideoTagReform

- (id)manager:(KBAPIBaseManager *)manager reformData:(NSDictionary *)data{
    NSDictionary *resultData = nil;
    if ([manager isKindOfClass:[IndexApiManager class]]) {
        resultData = @{
                       kPropertyVideoTagName:data[@"tagName"],
                       kPropertyVideoResourcesList:data[@"resourcesList"]
                       };
    }
    return resultData;
}


@end
