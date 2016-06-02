//
//  HomeCollectionViewCell.h
//  KBNetworking
//
//  Created by chengshenggen on 4/29/16.
//  Copyright © 2016 Gan Tian. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  视频列表item view cell
 */
@interface HomeCollectionViewCell : UICollectionViewCell

- (void)configWithData:(NSDictionary *)data;

@end

/**
 *  首页顶部轮播图 + 第三方平台 cell
 */

@protocol HomeCollectionHeaderViewCellDelegate <NSObject>

//轮播图点击
-(void)focusImageClick:(NSDictionary *)data;

@end

@interface HomeCollectionHeaderViewCell : UICollectionViewCell

@property(nonatomic,weak)id<HomeCollectionHeaderViewCellDelegate> itemDelegate;

//设置导航图
- (void)configNavImageWithData:(NSArray *)data ;

//设置第三方数据
- (void)configTagImageWithData:(NSArray *)data;


@end

/**
 *  每个视频列表的head标签
 */
@interface HomeCollectionHeadReusableView : UICollectionReusableView

@end

/**
 *  每个视频列表的foot标签
 */
@interface HomeCollectionFootReusableView : UICollectionReusableView

@end