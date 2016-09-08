//
//  PlayerControlView1_0.m
//  VRShow
//
//  Created by chengshenggen on 9/1/16.
//  Copyright © 2016 Gan Tian. All rights reserved.
//

#import "PlayerControlView1_0.h"
#import "VRShowNavView.h"

@interface PlayerControlView1_0 ()

@property(nonatomic,strong)UIView *bottomView;

@end

@implementation PlayerControlView1_0

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.topView];
        [self addSubview:self.navView];
        [self addSubview:self.bottomView];
        [self.bottomView addSubview:self.playButton];
        [self.bottomView addSubview:self.currentTimeLabel];
        [self.bottomView addSubview:self.progressView];
        [self.bottomView addSubview:self.slider];
//        [self.bottomView addSubview:self.totalTimeLabel];
        [self.bottomView addSubview:self.vrButton];
        
        [self addSubview:self.rightView];
        [self.rightView addSubview:self.tllButton];
        [self.rightView addSubview:self.doubleButton];
        
        [self layoutSubPages];
    }
    return self;
}

-(void)layoutSubPages{
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.equalTo(@20);
    }];
    [_navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self);
        make.height.equalTo(@64);
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@44);
    }];
    
    [_playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 40));
        make.left.equalTo(_bottomView);
        make.centerY.equalTo(_bottomView);
    }];
    
    [_currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_playButton.mas_right).offset(5);
        make.top.equalTo(_slider.mas_bottom).offset(-10);
    }];
    
//    [_totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(_bottomView).offset(-30);
//        make.centerY.equalTo(_bottomView);
//    }];
    
    [_vrButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 40));
        make.right.equalTo(_bottomView);
        make.centerY.equalTo(_bottomView);
    }];
    
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1.2);
        make.left.equalTo(_playButton.mas_right).offset(5);
        make.right.equalTo(_vrButton.mas_left);
        make.centerY.equalTo(_bottomView).offset(-2);
    }];
    [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_playButton.mas_right).offset(5);
        make.right.equalTo(_vrButton.mas_left);
        make.height.equalTo(@30);
        make.centerY.equalTo(_progressView).offset(-1);
    }];
    [_rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self);
    }];
    [_tllButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(35, 35));
        make.right.top.equalTo(_rightView);
    }];
    [_doubleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_tllButton);
        make.right.bottom.equalTo(_rightView);
    }];
    
}

#pragma mark - setters and getters

- (VRShowNavView *)navView {
    if (_navView == nil) {
        _navView = [[VRShowNavView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 64)];
        _navView.leftTitleLabel.text = @"";
        _navView.backgroundColor = UIColorFromRGBA(0x000000, 0.1);
        _navView.leftTitleLabel.hidden = NO;
        _navView.navLeftButton.hidden = NO;
        _navView.titleLabel.hidden = YES;
        _navView.leftTitleLabel.textColor = [UIColor whiteColor];
    }
    return _navView;
}

- (UIView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
        _bottomView.backgroundColor = UIColorFromRGBA(0x000000, 0.1);
    }
    return _bottomView;
}

- (UIButton *)playButton {
    if (_playButton == nil) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[UIImage imageNamed:@"suspend"] forState:UIControlStateNormal];
    }
    return _playButton;
}

- (UIButton *)vrButton {
    if (_vrButton == nil) {
        _vrButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_vrButton setImage:[UIImage imageNamed:@"extend"] forState:UIControlStateNormal];
    }
    return _vrButton;
}

- (UILabel *)currentTimeLabel {
    if (_currentTimeLabel == nil) {
        _currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.font = [UIFont systemFontOfSize:14.0];
        _currentTimeLabel.text = @"00:00/00:00";
    }
    return _currentTimeLabel;
}

- (UILabel *)totalTimeLabel {
    if (_totalTimeLabel == nil) {
        _totalTimeLabel = [[UILabel alloc] init];
        _totalTimeLabel.textColor = [UIColor whiteColor];
        _totalTimeLabel.font = [UIFont systemFontOfSize:14.0];
        _totalTimeLabel.text = @"00:00";
    }
    return _totalTimeLabel;
}

- (UIProgressView *)progressView {
    if (_progressView == nil) {
        _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.progressTintColor = UIColorFromRGB(0xffffff);

        //        _progressView.progressTintColor = [UIColor redColor];
    }
    return _progressView;
}

- (UIView *)rightView {
    if (_rightView == nil) {
        _rightView = [[UIView alloc] init];
    }
    return _rightView;
}

- (UIView *)topView {
    if (_topView == nil) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor blackColor];
    }
    return _topView;
}

- (UISlider *)slider {
    if (_slider == nil) {
        _slider = [[UISlider alloc] init];
        [_slider setThumbImage:[UIImage imageNamed:@"spot"] forState:UIControlStateNormal];
        [_slider setMinimumTrackImage:[UIImage imageNamed:@"slider_02"] forState:UIControlStateNormal];
        _slider.maximumTrackTintColor = [UIColor clearColor];

    }
    return _slider;
}

- (UIButton *)tllButton {
    if (_tllButton == nil) {
        _tllButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tllButton setImage:[UIImage imageNamed:@"tl"] forState:UIControlStateNormal];
    }
    return _tllButton;
}

- (UIButton *)doubleButton {
    if (_doubleButton == nil) {
        _doubleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doubleButton setImage:[UIImage imageNamed:@"-double"] forState:UIControlStateNormal];
    }
    return _doubleButton;
}


@end

@interface PlayerBackgroundView ()


@end

@implementation PlayerBackgroundView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self addSubview:self.logoImageView];
        [self addSubview:self.leftGestureImageView];
        [self addSubview:self.rightGestureImageView];

        [self addSubview:self.loadingImageView];
        [self addSubview:self.titleLabel];
        
        [self layoutSubPages];
    }
    return self;
}

-(void)layoutSubPages{
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(138, 35));
        make.top.equalTo(self).offset(40);
        make.centerX.equalTo(self);
    }];
    [_loadingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(36, 21));
        make.top.equalTo(_logoImageView.mas_bottom).offset(30);
        make.centerX.equalTo(self);
    }];
    [_leftGestureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(33, 57));
        make.bottom.equalTo(self).offset(-10);
        make.left.equalTo(self).offset(15);
    }];
    [_rightGestureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 50));
//        make.top.equalTo(_logoImageView.mas_bottom).offset(30);
        make.bottom.equalTo(self).offset(-10);

        make.right.equalTo(self).offset(-15);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_loadingImageView.mas_bottom).offset(5);
        make.centerX.equalTo(self);
    }];
}

-(UIImageView *)logoImageView{
    if (_logoImageView == nil) {
        _logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    }
    return _logoImageView;
}

-(UIImageView *)loadingImageView{
    if (_loadingImageView == nil) {
        _loadingImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading_01"]];
        NSMutableArray *images = [NSMutableArray arrayWithCapacity:4];
        [images addObject:[UIImage imageNamed:@"loading_01"]];
        [images addObject:[UIImage imageNamed:@"loading_02"]];
        [images addObject:[UIImage imageNamed:@"loading_03"]];
        [images addObject:[UIImage imageNamed:@"loading_04"]];
        _loadingImageView.animationImages = images;
        _loadingImageView.animationDuration = 0.5;
    }
    return _loadingImageView;
}

-(UIImageView *)leftGestureImageView{
    if (_leftGestureImageView == nil) {
        _leftGestureImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"volume"]];
    }
    return _leftGestureImageView;
}

-(UIImageView *)rightGestureImageView{
    if (_rightGestureImageView == nil) {
        _rightGestureImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Schedule"]];
    }
    return _rightGestureImageView;
}

-(UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:13.0];
        _titleLabel.textColor = [UIColor whiteColor];
//        _titleLabel.text = @"test";
    }
    return _titleLabel;
}


@end


@implementation LoadingDataView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.loadingImageView];
        [self layoutSubPages];
    }
    return self;
}

-(void)layoutSubPages{

    [_loadingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(36, 21));
        make.center.equalTo(self);
    }];
    
}

-(void)startAnim{
    self.hidden = NO;
    [self.loadingImageView startAnimating];
}

-(void)stopAnim{
    self.hidden = YES;
    [self.loadingImageView stopAnimating];
}

-(UIImageView *)loadingImageView{
    if (_loadingImageView == nil) {
        _loadingImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading_01"]];
        NSMutableArray *images = [NSMutableArray arrayWithCapacity:4];
        [images addObject:[UIImage imageNamed:@"loading_01"]];
        [images addObject:[UIImage imageNamed:@"loading_02"]];
        [images addObject:[UIImage imageNamed:@"loading_03"]];
        [images addObject:[UIImage imageNamed:@"loading_04"]];
        _loadingImageView.animationImages = images;
        _loadingImageView.animationDuration = 0.5;
    }
    return _loadingImageView;
}


@end

@implementation VRCommentButtonView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.textImageView];
//        [self addSubview:self.personImageView];
        [self layoutSubPages];
    }
    return self;
}

-(void)layoutSubPages{
    [_textImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
//        make.right.equalTo(_personImageView.mas_left);
    }];
//    [_personImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(<#CGFloat width#>, <#CGFloat height#>))
//    }];
}

-(UIImageView *)textImageView{
    if (_textImageView == nil) {
        _textImageView = [[UIImageView alloc] init];
        _textImageView.image = [UIImage imageNamed:@"Dialogbox"];
        _textImageView.userInteractionEnabled = YES;
//        _textImageView
    }
    return _textImageView;
}

@end

