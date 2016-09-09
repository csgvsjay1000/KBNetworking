//
//  HomeCollectionViewCell.m
//  KBNetworking
//
//  Created by chengshenggen on 4/29/16.
//  Copyright © 2016 Gan Tian. All rights reserved.
//

#import "HomeCollectionViewCell.h"
#import "CarouselReformerKeys.h"
#import "Constants.h"

#pragma mark - 视频列表item view cell

@interface HomeCollectionViewCell ()

@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UILabel *titleLabel;

@end

@implementation HomeCollectionViewCell

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.titleLabel];
        
        [self layoutSubPages];
    }
    return self;
}

- (void)configWithData:(NSDictionary *)data{
    
    NSString *imageString = [data objectForKey:@"coverImgUrl"];
    NSString *compressString = Compress(imageString, _imageView.frame.size.width);
    [_imageView sd_setImageWithURL:[NSURL URLWithString:compressString] placeholderImage:[UIImage imageNamed:@"default_big"]];
    self.titleLabel.text = [data objectForKey:@"resourceName"];

}

-(void)layoutSubPages{
    //图片
    CGFloat itemWidth = (kScreenWidth - 55) / 2;
    CGFloat itemHeight = (itemWidth * 9/16);
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(itemWidth, itemHeight));
        make.top.equalTo(self).offset(15);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageView.mas_bottom);
        make.centerX.equalTo(self);
        make.width.equalTo([NSNumber numberWithFloat:itemWidth]);
    }];
}

-(UIImageView *)imageView{
    if (_imageView == nil) {
        CGFloat itemWidth = (kScreenWidth - 55) / 2;
        CGFloat itemHeight = (itemWidth * 9/16);
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, itemWidth,itemHeight)];
        _imageView.image = [UIImage imageNamed:@"default_big"];
    }
    return _imageView;
}

-(UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:13.0];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.text = @"test";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}


@end



#pragma mark - 首页顶部轮播图 + 第三方平台 cell

const NSInteger kFoucusImageViewTag = 100;  //轮播图标签tag
const NSInteger kThridImageViewTag = 200;   //第三方图标tag


@interface HomeCollectionHeaderViewCell ()

@property(nonatomic,strong)UIScrollView *imageScrollView;  //轮播图ScrollView
@property(nonatomic,strong)UIPageControl *imagePageControl;  //轮播图PageControl

@property(nonatomic,strong)UIScrollView *tagScrollView;  //第三方ScrollView

@property(nonatomic,strong)NSArray *imageArray;  //轮播图片

@property(nonatomic,strong)NSArray *thirdImageArray;  //第三方平台列表

@end

@implementation HomeCollectionHeaderViewCell

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageScrollView];
        [self.contentView addSubview:self.imagePageControl];
        [self.contentView addSubview:self.tagScrollView];
        [self layoutSubPages];
    }
    return self;
}

-(void)layoutSubPages{
    [_imageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo([NSNumber numberWithFloat:self.frame.size.height-70]);
    }];
    [_tagScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(_imageScrollView.mas_bottom);
        make.height.equalTo([NSNumber numberWithFloat:70]);
    }];
}


#pragma mark - public methods
//设置导航图
- (void)configNavImageWithData:(NSArray *)data{
    _imageArray = data;
    if (_imageArray && [_imageArray isKindOfClass:[NSArray class]] && _imageArray.count>0) {
        for (int i=0; i<_imageArray.count; i++) {
            CGRect frame = CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height-70);
            UIImageView *image = [[UIImageView alloc] initWithFrame:frame];
            image.userInteractionEnabled = YES;
            image.tag = kFoucusImageViewTag + i;
            [self.imageScrollView addSubview:image];
            [image addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusImageTap:)]];
            NSString *imageUrl = [[_imageArray objectAtIndex:i] objectForKey:kPropertyFocusImgPath];
            NSString *compressString = Compress(imageUrl, frame.size.width);
            [image sd_setImageWithURL:[NSURL URLWithString:compressString] placeholderImage:[UIImage imageNamed:@"default_big"]];
        }
        self.imageScrollView.contentSize = CGSizeMake(self.frame.size.width*_imageArray.count, self.imageScrollView.frame.size.height);
    }
}

//设置第三方数据
- (void)configTagImageWithData:(NSArray *)data{
    _thirdImageArray = data;
    if (_thirdImageArray && [_thirdImageArray isKindOfClass:[NSArray class]] && _thirdImageArray.count>0) {
        
        CGFloat width = kScreenWidth/4;
        CGFloat imageWidth = 44;
        
        for (int i=0; i<_thirdImageArray.count; i++) {
            CGRect frame = CGRectMake(i*width, 0, width, 70);
            
            UIView *tempView = [[UIView alloc] initWithFrame:frame];
            [self.tagScrollView addSubview:tempView];
            tempView.tag = kThridImageViewTag + i;
            [tempView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thridImageTap:)]];
            
            CGRect imageFrame = CGRectMake((width-imageWidth)/2, 5, imageWidth, imageWidth);
            UIImageView *image = [[UIImageView alloc] initWithFrame:imageFrame];
            [tempView addSubview:image];
            NSString *imageUrl = [[_thirdImageArray objectAtIndex:i] objectForKey:kPropertyTagIcon];
            NSString *compressString = Compress(imageUrl, frame.size.width);
            [image sd_setImageWithURL:[NSURL URLWithString:compressString] placeholderImage:[UIImage imageNamed:@"default_small"]];
            
            CGRect labelFrame = CGRectMake(0, imageFrame.size.height+5, width, frame.size.height - imageFrame.size.height-5);
            UILabel *_titleLabel = [[UILabel alloc] initWithFrame:labelFrame];
            _titleLabel.font = [UIFont systemFontOfSize:10.0];
            _titleLabel.textColor = UIColorFromRGB(0x333333);
            _titleLabel.backgroundColor = [UIColor clearColor];
            _titleLabel.textAlignment = NSTextAlignmentCenter;
            _titleLabel.text = [[_thirdImageArray objectAtIndex:i] objectForKey:kPropertyTagName];
            [tempView addSubview:_titleLabel];
            
        }
        self.tagScrollView.contentSize = CGSizeMake(width*_thirdImageArray.count, self.tagScrollView.frame.size.height);
    }
}

#pragma mark - gestures 
//轮播图点击
-(void)focusImageTap:(UITapGestureRecognizer *)gesture{
    UIImageView *imgv = (UIImageView *)gesture.view;
    NSDictionary *data = _imageArray[imgv.tag - kFoucusImageViewTag];
    if (_itemDelegate && [_itemDelegate respondsToSelector:@selector(focusImageClick:)]) {
        [_itemDelegate focusImageClick:data];
    }
}

//第三方按钮点击
-(void)thridImageTap:(UITapGestureRecognizer *)gesture{
    UIImageView *imgv = (UIImageView *)gesture.view;
//    NSDictionary *data = _imageArray[imgv.tag - kFoucusImageViewTag];
//    if (_itemDelegate && [_itemDelegate respondsToSelector:@selector(focusImageClick:)]) {
//        [_itemDelegate focusImageClick:data];
//    }
}

#pragma mark - setters and getters
-(UIScrollView *)imageScrollView{
    if (_imageScrollView == nil) {
        _imageScrollView = [[UIScrollView alloc] init];
        _imageScrollView.alwaysBounceHorizontal = YES;
        _imageScrollView.pagingEnabled = YES;
        _imageScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _imageScrollView;
}

-(UIScrollView *)tagScrollView{
    if (_tagScrollView == nil) {
        _tagScrollView = [[UIScrollView alloc] init];
        _tagScrollView.alwaysBounceHorizontal = YES;
        _tagScrollView.pagingEnabled = YES;
        _tagScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _tagScrollView;
}

@end


#pragma mark - 每个视频列表的head标签

@implementation HomeCollectionHeadReusableView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor greenColor];
    }
    return self;
}

- (void)configWithData:(NSDictionary *)data{
    //    NSLog(@"%@",data[kPropertyFocusImgPath]);
}

@end


#pragma mark - 每个视频列表的foot标签

@implementation HomeCollectionFootReusableView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
    }
    return self;
}

- (void)configWithData:(NSDictionary *)data{
    //    NSLog(@"%@",data[kPropertyFocusImgPath]);
}

@end