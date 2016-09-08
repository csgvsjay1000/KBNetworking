//
//  KBEAGLView.h
//  VRShow
//
//  Created by chengshenggen on 8/26/16.
//  Copyright © 2016 Gan Tian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VREnumDefHeader.h"
#import <CoreMotion/CoreMotion.h>
#import "PlayerControlView1_0.h"

@protocol KBEAGLViewVRUIDelegate <NSObject>

-(void)vruiBack;
-(void)vruiVolume:(BOOL)up;
-(void)vruiPlayHistory;  //播放历史
-(void)vruiPlayAll;  //全部视频
-(void)vruiPlayWithTagid:(NSString *)tagid;  //标签下视频
-(void)vruiPlayWithResourceID:(NSString *)resourceID andReourceName:(NSString *)name;  //资源ID


@end

/**
    YUV 渲染View ,支持全景，普通模式
 */
@interface KBEAGLView : UIView

@property(nonatomic,assign ) KBPlayerLocation playerLocation;
@property(nonatomic,assign ) VideoType videoType;

//陀螺仪
@property(nonatomic,strong) CMAttitude *referenceAttitude;
@property(nonatomic,strong) CMMotionManager *motionManager;
@property (nonatomic, assign) ZFPlayerState state;  //播放状态
@property(nonatomic,assign)id<KBEAGLViewVRUIDelegate> vruiDelegate;
@property(nonatomic,strong)PlayerBackgroundView *playerBackgroundView;  //缓冲View


-(void)setPlayerLocation:(KBPlayerLocation)playerLocation andVideoType:(VideoType)videoType;
- (void)displayPixelBuffer:(CVPixelBufferRef)pixelBuffer;

@property(nonatomic,assign)BOOL isLandScape;

/// 使用陀螺仪
-(void)notUseMotion:(BOOL)use;

-(void)tearDownGL;
-(void)wait:(BOOL)value;


@end
