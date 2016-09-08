//
//  PlayerControlView1_0.h
//  VRShow
//
//  Created by chengshenggen on 9/1/16.
//  Copyright © 2016 Gan Tian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VRShowNavView;

@interface PlayerControlView1_0 : UIView

@property(nonatomic,strong) VRShowNavView *navView;
@property(nonatomic,strong) UIButton *playButton;
@property(nonatomic,strong) UIProgressView *progressView;
@property(nonatomic,strong) UISlider *slider;
@property(nonatomic,strong) UILabel *currentTimeLabel;
@property(nonatomic,strong) UILabel *totalTimeLabel;
@property(nonatomic,strong)UIView *topView;

@property(nonatomic,strong)UIButton *vrButton;

//分屏按钮
@property(nonatomic,strong) UIButton *tllButton;
//全景按钮
@property(nonatomic,strong) UIButton *doubleButton;
@property(nonatomic,strong)UIView *rightView;

@end


@interface PlayerBackgroundView : UIView

@property(nonatomic,strong)UIImageView *logoImageView;

@property(nonatomic,strong)UIImageView *leftGestureImageView;
@property(nonatomic,strong)UIImageView *rightGestureImageView;
@property(nonatomic,strong)UIImageView *loadingImageView;
@property(nonatomic,strong)UILabel *titleLabel;

@end

@interface LoadingDataView : UIView

@property(nonatomic,strong)UIImageView *loadingImageView;

-(void)startAnim;
-(void)stopAnim;

@end

@interface VRCommentButtonView : UIView  //输入对话框

@property(nonatomic,strong)UIImageView *textImageView;
@property(nonatomic,strong)UIImageView *personImageView;

@end

