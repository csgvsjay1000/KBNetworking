//
//  VRShowNavView.m
//  VRShow
//
//  Created by jwd on 3/3/16.
//  Copyright © 2016 Gan Tian. All rights reserved.
//

#import "VRShowNavView.h"
#import "Constants.h"

@interface VRShowNavView ()

@end

@implementation VRShowNavView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0x000000);

        [self addSubview:self.titleLabel];
        [self addSubview:self.leftTitleLabel];
        [self addSubview:self.navLeftButton];
        [self layoutSubPages];
    }
    return self;
}

-(void)layoutSubPages{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(30);
    }];
    [_navLeftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.equalTo(self).offset(10);
//        make.top.equalTo(self).offset(30);
        make.centerY.equalTo(_titleLabel);
    }];
    
    [_leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_navLeftButton.mas_right).offset(5);
        make.top.equalTo(self).offset(30);
    }];
}

#pragma mark - button response

- (void)navLeftButtonPressed:(id)sender {
    //如果block存在,执行该block
    if (_navLeftButtonBlock) {
        _navLeftButtonBlock(self);
    }
}

#pragma mark - setters and getters

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"VRShow";
        _titleLabel.textColor = [UIColor whiteColor];

        _titleLabel.font = [UIFont systemFontOfSize:15.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

-(UILabel *)leftTitleLabel{
    if (_leftTitleLabel == nil) {
        _leftTitleLabel = [[UILabel alloc]init];
        _leftTitleLabel.textColor = [UIColor whiteColor];
        _leftTitleLabel.font = [UIFont systemFontOfSize:15.0];
        _leftTitleLabel.textAlignment = NSTextAlignmentCenter;
        _leftTitleLabel.hidden = YES;
    }
    return _leftTitleLabel;
}


-(UIButton *)navLeftButton{
    if (_navLeftButton == nil) {
        UIImage *backImage = [UIImage imageNamed:@"icon_return"];
        _navLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _navLeftButton.frame = CGRectMake(10.0, 20.0, 40, 40);
        [_navLeftButton setImage:backImage forState:UIControlStateNormal];
        //返回按钮为第一响应者
        _navLeftButton.exclusiveTouch = YES;
        [_navLeftButton addTarget:self action:@selector(navLeftButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        _navLeftButton.hidden = YES;
    }
    return _navLeftButton;
}

@end

@interface VRNoDataView ()

@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UILabel *titleLabel;

@end

@implementation VRNoDataView

-(id)initWithFrame:(CGRect)frame{
    CGRect tm = CGRectMake(0, 0, 200, 200);
    self = [super initWithFrame:tm];
    if (self) {
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.imageView];
        [self layoutSubPages];
    }
    return self;
}

-(void)layoutSubPages{
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(133, 86));
        make.center.equalTo(self);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_imageView.mas_bottom).offset(5);
    }];
}

-(void)showInView:(UIView *)inView{
    [self removeFromSuperview];
    [inView addSubview:self];
    [inView bringSubviewToFront:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(inView);
        make.size.mas_equalTo(CGSizeMake(200, 200));
    }];
}

-(void)hide{
    [self removeFromSuperview];
}

#pragma mark - setters and getters
-(UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"空空的，什么也没有";
        _titleLabel.textColor = UIColorFromRGB(0xAAAAAA);
        
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

-(UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ios_empty"]];
    }
    return _imageView;
}

@end

@interface VRWaitingView ()

@property(nonatomic,strong)UIImageView *animImageView;  //跑动小人View
@property(nonatomic,strong)NSMutableArray *imageArray;

@end

@implementation VRWaitingView

-(id)initWithFrame:(CGRect)frame{
    CGRect tm = CGRectMake(0, 0, 250, 250);
    self = [super initWithFrame:tm];
    if (self) {
        
        [self addSubview:self.animImageView];
        self.animImageView.animationImages = self.imageArray;
        [self layoutSubPages];
    }
    return self;
}

-(void)layoutSubPages{
    
    [_animImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(250, 250));
        make.center.equalTo(self);
    }];
    
}

-(void)showInView:(UIView *)inView{
    [self removeFromSuperview];
    [inView addSubview:self];
    [inView bringSubviewToFront:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(inView);
        make.size.mas_equalTo(CGSizeMake(250, 250));
    }];
    [self.animImageView startAnimating];

}

-(void)hide{
    [self.animImageView stopAnimating];
    [self removeFromSuperview];
}

#pragma mark - setters and getters
-(UIImageView *)animImageView{
    if (_animImageView == nil) {
        _animImageView = [[UIImageView alloc]init];
        _animImageView.animationDuration = 0.5;
        _animImageView.userInteractionEnabled = YES;
        _animImageView.frame = CGRectMake(0, 0, 250, 250);
        _animImageView.center = self.center;
        _animImageView.image = [UIImage imageNamed:@"waiting_01"];
    }
    return _animImageView;
}

-(NSMutableArray *)imageArray{
    if (_imageArray == nil) {
        _imageArray = [[NSMutableArray alloc]init];
        [_imageArray addObject:[UIImage imageNamed:@"waiting_01"]];
        [_imageArray addObject:[UIImage imageNamed:@"waiting_02"]];
        [_imageArray addObject:[UIImage imageNamed:@"waiting_03"]];
        [_imageArray addObject:[UIImage imageNamed:@"waiting_04"]];
        
    }
    return _imageArray;
}

@end

@interface VRFailLoadingView ()

@property(nonatomic,strong)UIView *middleView;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UILabel *msgLabel;
@property(nonatomic,strong)UIButton *button;

@property(nonatomic,copy)VRSHowButtonPressedBlock reloadBlock;

@end

@implementation VRFailLoadingView

-(id)initWithFrame:(CGRect)frame{
    CGRect tm = CGRectMake(0, 0, 250, 300);
    
    self = [super initWithFrame:tm];
    if (self) {
        [self addSubview:self.middleView];
        [self.middleView addSubview:self.imageView];
        [self.middleView addSubview:self.msgLabel];
        [self.middleView addSubview:self.button];

        [self layoutSubPages];
    }
    return self;
}

-(void)layoutSubPages{
    
    [_middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.equalTo(self);
    }];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(123, 136));
        make.centerX.equalTo(self);
        make.top.equalTo(self);
    }];
    [_msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_imageView.mas_bottom).offset(5);
    }];
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(90, 30));
        make.top.equalTo(_msgLabel.mas_bottom).offset(10);
    }];
}

-(void)showInView:(UIView *)inView reloadBlock:(VRSHowButtonPressedBlock)reloadBlock{
    [self removeFromSuperview];
    [inView addSubview:self];
    [inView bringSubviewToFront:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(inView);
        make.size.mas_equalTo(CGSizeMake(250, 250));
    }];
    _reloadBlock = reloadBlock;
}

-(void)hide{
    [self removeFromSuperview];
}

-(void)buttonPressed{
    if (_reloadBlock) {
        [self hide];
        _reloadBlock(self);
    }
}

#pragma mark - setters and getters
-(UIView *)middleView{
    if (_middleView == nil) {
        _middleView = [[UIView alloc] init];
    }
    return _middleView;
}

-(UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]init];
        _imageView.image = [UIImage imageNamed:@"global_fail_load"];
    }
    return _imageView;
}

-(UILabel *)msgLabel{
    if (_msgLabel == nil) {
        _msgLabel = [[UILabel alloc]init];
        _msgLabel.textColor = [UIColor blackColor];
        _msgLabel.font = [UIFont systemFontOfSize:15.0];
        _msgLabel.textAlignment = NSTextAlignmentCenter;
        _msgLabel.text = @"非常抱歉,页面加载失败";
    }
    return _msgLabel;
}


-(UIButton *)button{
    if (_button == nil) {
        UIImage *backImage = [UIImage imageNamed:@"global_fail_button_bg"];
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setBackgroundImage:backImage forState:UIControlStateNormal];
        //返回按钮为第一响应者
        [_button addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_button setTitle:@"重新加载" forState:UIControlStateNormal];
    }
    return _button;
}


@end




