//
//  VREnumDefHeader.h
//  VRShow
//
//  Created by chengshenggen on 4/13/16.
//  Copyright © 2016 Gan Tian. All rights reserved.
//

#ifndef VREnumDefHeader_h
#define VREnumDefHeader_h

typedef enum : NSUInteger {
    VideoType_Normal = 1,  //1表示普通视频
    VideoType_3D = 2,  //2表示左右格式3D
    VideoType_360 = 3,  //3表示单画面全景
    VideoType_updown_3D,  //上下格式3d
    VideoType_updown_360  //上下格式全景
} VideoType;

typedef enum : NSUInteger {
    KBPlayerLocationNone = 10,  //不分左右屏
    KBPlayerLocationLeft = 20,  //
    KBPlayerLocationRight = 30, //
    
} KBPlayerLocation;

//播放器的几种状态
typedef NS_ENUM(NSInteger, ZFPlayerState) {
    ZFPlayerStateFailed,     // 播放失败
    ZFPlayerStateBuffering,  // 缓冲中
    ZFPlayerStatePlaying,    // 播放中
    ZFPlayerStateStopped,    // 停止播放
    ZFPlayerStatePause       // 暂停播放
};

// 枚举值，包含水平移动方向和垂直移动方向
typedef NS_ENUM(NSInteger, PanDirection){
    PanDirectionHorizontalMoved, // 横向移动
    PanDirectionVerticalMoved    // 纵向移动
};

#endif /* VREnumDefHeader_h */
