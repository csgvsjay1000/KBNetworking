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

-(void)show{
    self.hidden = NO;
    
}

-(void)hide{
    self.hidden = YES;
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
